import 'dart:convert';
import 'package:expense_analyser/data/datasources/local/database/app_database.dart';
import 'package:expense_analyser/data/datasources/local/storage/secure_storage_service.dart';
import 'package:expense_analyser/data/datasources/remote/dashboard_api_service.dart';
import 'package:expense_analyser/domain/models/response/dashboard_response.dart';
import 'package:expense_analyser/domain/repositories/dashboard_repository.dart';
import 'package:sqflite/sqflite.dart';
// imports...

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardApiService apiService;
  final AppDatabase appDatabase;
  final SecureStorageService secureStorage;

  DashboardRepositoryImpl({
    required this.apiService,
    required this.appDatabase,
    required this.secureStorage,
  });

  // 1. 🚨 SDE3: Get data from local SQLite instantly
  @override
  Future<DashboardData?> getLocalDashboardData(String cacheKey) async {
    try {
      final db = await appDatabase.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'api_cache',
        where: 'endpoint = ?',
        whereArgs: [cacheKey],
      );

      if (maps.isNotEmpty) {
        final String rawJsonStr = maps.first['json_data'];
        final Map<String, dynamic> jsonMap = jsonDecode(rawJsonStr);
        return DashboardData.fromJson(jsonMap);
      }
    } catch (e) {
      return null; // Local cache fail is okay, we will try network
    }
    return null;
  }

  // 2. 🚨 SDE3: Get from Network AND update SQLite
  @override
  Future<DashboardData> getRemoteDashboardData(
    String cacheKey, {
    int? month,
    int? year,
  }) async {
    final token = await secureStorage.getAccessToken() ?? '';
    final rawData = await apiService.getDashboardSummary(
      token,
      month: month,
      year: year,
    );

    if (rawData['success'] == true && rawData['data'] != null) {
      final dashboardData = DashboardData.fromJson(rawData['data']);

      // Save raw JSON to SQLite cache silently in background
      final db = await appDatabase.database;
      await db.insert('api_cache', {
        'endpoint': cacheKey,
        'json_data': dashboardData.toJsonString(),
        'updated_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);

      return dashboardData;
    } else {
      throw Exception(rawData['message'] ?? "Failed to fetch dashboard");
    }
  }
}
