import 'package:dio/dio.dart';
import 'package:expense_analyser/core/constants/api_endpoints.dart';
// import endpoints...

class DashboardApiService {
  final Dio dio;
  DashboardApiService({required this.dio});

  Future<Map<String, dynamic>> getDashboardSummary(
    String token, {
    int? month,
    int? year,
  }) async {
    final response = await dio.get(
      ApiEndpoints.dashboardSummary, // e.g. '/dashboard/summary'
      queryParameters: {
        if (month != null) 'month': month,
        if (year != null) 'year': year,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data;
  }
}
