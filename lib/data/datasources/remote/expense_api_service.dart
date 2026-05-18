import 'package:dio/dio.dart';
import 'package:expense_analyser/domain/models/request/create_category_request.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../domain/models/request/add_expense_request.dart';

class ExpenseApiService {
  final Dio dio;

  ExpenseApiService({required this.dio});

  Future<Map<String, dynamic>> addExpense(
    AddExpenseRequest request,
    String accessToken,
  ) async {
    final response = await dio.post(
      ApiEndpoints.createExpense,
      data: request.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getCategories(String accessToken) async {
    final response = await dio.get(
      ApiEndpoints.getCategories,
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return response.data;
  }

  // 🚨 Add this inside expense_api_service.dart
  Future<Map<String, dynamic>> createCategory(
    CreateCategoryRequest request,
    String accessToken,
  ) async {
    final response = await dio.post(
      ApiEndpoints.createCategory,
      data: request.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
    );
    return response.data;
  }
}
