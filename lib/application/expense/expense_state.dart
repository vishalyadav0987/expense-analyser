import 'package:equatable/equatable.dart';
import 'package:expense_analyser/domain/models/response/get_categories_response.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/response/add_expense_response.dart';

@immutable
sealed class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseLoading extends ExpenseState {}

final class ExpenseSuccess extends ExpenseState {
  final AddExpenseResponse response;

  const ExpenseSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class ExpenseError extends ExpenseState {
  final String message;
  const ExpenseError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Add these new states
final class CategoriesLoading extends ExpenseState {}

final class CategoriesLoaded extends ExpenseState {
  final Map<String, List<String>> categorizedData; // The Map UI needs!
  // SDE3 tip: Store the raw models too in case you need the backend ID later
  final List<CategoryModel> rawCategories;

  const CategoriesLoaded({
    required this.categorizedData,
    required this.rawCategories,
  });

  @override
  List<Object?> get props => [categorizedData, rawCategories];
}

final class CategoriesError extends ExpenseState {
  final String message;
  const CategoriesError({required this.message});

  @override
  List<Object?> get props => [message];
}
