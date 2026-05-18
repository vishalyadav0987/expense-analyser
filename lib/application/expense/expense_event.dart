import 'package:equatable/equatable.dart';
import 'package:expense_analyser/domain/models/request/create_category_request.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/request/add_expense_request.dart';

@immutable
sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

final class SubmitAddExpenseEvent extends ExpenseEvent {
  final AddExpenseRequest requestPayload;

  const SubmitAddExpenseEvent({required this.requestPayload});

  @override
  List<Object?> get props => [requestPayload];
}

final class FetchCategoriesEvent extends ExpenseEvent {}

// Add this event
final class SubmitCreateCategoryEvent extends ExpenseEvent {
  final CreateCategoryRequest requestPayload;

  const SubmitCreateCategoryEvent({required this.requestPayload});

  @override
  List<Object?> get props => [requestPayload];
}
