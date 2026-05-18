import 'package:expense_analyser/domain/models/response/dashboard_response.dart';

abstract class DashboardRepository {
  Future<DashboardData?> getLocalDashboardData(String cacheKey);
  Future<DashboardData> getRemoteDashboardData(
    String cacheKey, {
    int? month,
    int? year,
  });
}
