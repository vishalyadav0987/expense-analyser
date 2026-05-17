import 'package:sqflite/sqflite.dart';

import '../../domain/repositories/setup_repository.dart';
import '../../domain/models/request/initial_setup_request.dart';
import '../../domain/models/response/initial_setup_response.dart';
import '../datasources/remote/setup_api_service.dart';
import '../datasources/local/database/app_database.dart';
import '../datasources/local/storage/secure_storage_service.dart';

class SetupRepositoryImpl implements SetupRepository {
  final SetupApiService remoteDataSource;
  final AppDatabase appDatabase;
  final SecureStorageService secureStorage;

  SetupRepositoryImpl({
    required this.remoteDataSource,
    required this.appDatabase,
    required this.secureStorage,
  });

  @override
  Future<void> submitInitialSetup(InitialSetupRequest request) async {
    // 1. Send Request to Backend
    final token = await secureStorage.getAccessToken();
    final rawData = await remoteDataSource.submitInitialSetup(
      request,
      token ?? '',
    );

    // 2. Parse into Strongly-Typed Response Model
    final response = InitialSetupResponse.fromJson(rawData);

    if (response.success && response.data != null) {
      final resData = response.data!;
      final userId = resData.user?.id ?? 'unknown_user';
      final isSetupComplete = resData.user?.setupCompleted ?? false;

      // 3. Save Response to SQLite Offline Cache (Using Transaction!)
      final db = await appDatabase.database;

      await db.transaction((txn) async {
        // A. Insert Profile using Response Data
        if (resData.financialInfo != null && resData.smartRules != null) {
          await txn.insert('user_profile', {
            'user_id': userId,
            'monthly_salary': resData.financialInfo!.monthlySalary,
            'yearly_hike': resData.financialInfo!.yearlyHikePercentage,
            'xx_weekly_limit': resData.financialInfo!.xxWeeklyLimit,
            'needs_pct': resData.smartRules!.needsPercentage,
            'wants_pct': resData.smartRules!.wantsPercentage,
            'savings_pct': resData.smartRules!.savingsPercentage,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }

        // B. Insert Categories using Backend IDs
        final batch = txn.batch();
        for (var cat in resData.savedCategories) {
          batch.insert('categories', {
            'id': cat.id,
            'user_id': cat.userId,
            'name': cat.name,
            'type': cat.type,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }

        // C. Insert Payment Methods using Backend IDs
        for (var method in resData.savedPaymentMethods) {
          batch.insert('payment_methods', {
            'id': method.id,
            'user_id': method.userId,
            'method_name': method.methodName,
            'weekly_limit': method.weeklyLimit,
            'is_active': method.isActive ? 1 : 0,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }

        await batch.commit();
      });

      // 4. Update Secure Storage Flag (For App Router Interception)
      final Map<String, dynamic>? currentLocalUser = await secureStorage
          .getUserData();
      if (currentLocalUser != null) {
        currentLocalUser['SetupComplete'] = isSetupComplete;
        await secureStorage.saveUserData(currentLocalUser);
      } else {
        await secureStorage.saveUserData({
          'SetupComplete': isSetupComplete,
          'Email': '',
        }); // Save fallback if null
      }
    } else {
      throw Exception(
        response.message.isNotEmpty
            ? response.message
            : "Failed to setup profile",
      );
    }
  }
}
