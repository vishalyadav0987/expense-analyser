import 'package:expense_analyser/data/datasources/local/storage/secure_storage_service.dart';
import 'package:expense_analyser/domain/models/request/create_category_request.dart';
import 'package:expense_analyser/domain/models/response/get_categories_response.dart';

import '../../domain/repositories/expense_repository.dart';
import '../../domain/models/request/add_expense_request.dart';
import '../../domain/models/response/add_expense_response.dart';
import '../datasources/remote/expense_api_service.dart';
import '../datasources/local/database/app_database.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseApiService remoteDataSource;
  final AppDatabase appDatabase;
  final SecureStorageService secureStorage;

  ExpenseRepositoryImpl({
    required this.remoteDataSource,
    required this.appDatabase,
    required this.secureStorage,
  });

  @override
  Future<AddExpenseResponse> addExpense(AddExpenseRequest request) async {
    // 1. Send Request to API
    final token = await secureStorage.getAccessToken();
    final rawData = await remoteDataSource.addExpense(request, token ?? '');

    // 2. Parse Response
    final response = AddExpenseResponse.fromJson(rawData);

    if (response.success &&
        response.data != null &&
        response.data!.transaction != null) {
      final txn = response.data!.transaction!;

      // 3. Save to Local SQLite Cache
      final db = await appDatabase.database;

      await db.insert('transactions', {
        'id': txn.transactionId,
        'category_id': txn.categoryId,
        'amount': txn.amount,
        'description': txn.description,
        'payment_mode': txn.paymentMode,
        'date': txn.date,
        'created_at': txn.createdAt,
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return response;
    } else {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : "Failed to add expense",
      );
    }
  }

  // 🚨 Add this inside ExpenseRepositoryImpl
  @override
  Future<List<CategoryModel>> getCategories() async {
    final token = await secureStorage.getAccessToken();
    final db = await appDatabase.database;

    // We need the user's ID to fetch/save from local DB correctly
    final userData = await secureStorage.getUserData();
    final userId = userData?['id'] ?? 'unknown';

    try {
      // 1. Try fetching from Network
      final rawData = await remoteDataSource.getCategories(token ?? '');
      final response = GetCategoriesResponse.fromJson(rawData);

      if (response.success) {
        // 2. Network Success: Update SQLite Cache!
        await db.transaction((txn) async {
          // Note: SDE3s usually delete old categories and insert new ones to avoid stale data,
          // or use ConflictAlgorithm.replace. We will use replace.
          final batch = txn.batch();
          for (var cat in response.data) {
            batch.insert(
              'categories',
              cat.toMap(userId),
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
          await batch.commit();
        });

        return response.data;
      } else {
        throw Exception("API returned false success flag");
      }
    } catch (e) {
      // 3. Network Failed (Offline) -> Fetch from Local SQLite!
      final List<Map<String, dynamic>> maps = await db.query(
        'categories',
        where: 'user_id = ?',
        whereArgs: [userId],
      );

      if (maps.isNotEmpty) {
        // Return cached categories
        return maps.map((e) => CategoryModel.fromJson(e)).toList();
      } else {
        throw Exception(
          "Failed to load categories. No internet and no offline cache.",
        );
      }
    }
  }

  // 🚨 Add this inside ExpenseRepositoryImpl
  @override
  Future<CategoryModel> createCategory(CreateCategoryRequest request) async {
    final token = await secureStorage.getAccessToken();

    // 1. API Call
    final rawData = await remoteDataSource.createCategory(request, token ?? '');

    // 2. Parse response
    if (rawData['success'] == true && rawData['data'] != null) {
      final newCategory = CategoryModel.fromJson(rawData['data']);

      // 3. 🚨 SDE3: Save to SQLite instantly for offline backup!
      final db = await appDatabase.database;
      final userData = await secureStorage.getUserData();
      final userId = userData?['id'] ?? 'unknown';

      await db.insert(
        'categories',
        newCategory.toMap(userId),
        conflictAlgorithm: ConflictAlgorithm.replace, // Overwrite if exists
      );

      return newCategory;
    } else {
      throw Exception(rawData['message'] ?? "Failed to create category");
    }
  }
}
