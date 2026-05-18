import 'package:expense_analyser/domain/models/request/create_category_request.dart';
import 'package:expense_analyser/domain/models/response/get_categories_response.dart';

import '../models/request/add_expense_request.dart';
import '../models/response/add_expense_response.dart';

abstract class ExpenseRepository {
  Future<AddExpenseResponse> addExpense(AddExpenseRequest request);
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> createCategory(CreateCategoryRequest request);
}
