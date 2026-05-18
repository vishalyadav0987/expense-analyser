import 'package:expense_analyser/application/expense/expense_event.dart';
import 'package:expense_analyser/application/expense/expense_state.dart';
import 'package:expense_analyser/domain/models/response/get_categories_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/expense_repository.dart';
// Import events and states...

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository expenseRepository;

  ExpenseBloc({required this.expenseRepository}) : super(ExpenseInitial()) {
    on<SubmitAddExpenseEvent>((event, emit) async {
      emit(ExpenseLoading());

      try {
        final response = await expenseRepository.addExpense(
          event.requestPayload,
        );
        emit(ExpenseSuccess(response: response));
      } catch (e) {
        emit(ExpenseError(message: e.toString()));
      }
    });

    // Inside ExpenseBloc constructor, add this new event handler
    on<FetchCategoriesEvent>((event, emit) async {
      emit(CategoriesLoading());

      try {
        final List<CategoryModel> categories = await expenseRepository
            .getCategories();

        // 🚨 SDE3: Data Transformation for UI 🚨
        final Map<String, List<String>> groupedCategories = {
          "Need": [],
          "Want": [],
          "Saving": [],
        };

        for (var cat in categories) {
          // backend se "Need" ya "Want" aayega, usko match karke list me daalo
          if (groupedCategories.containsKey(cat.type)) {
            groupedCategories[cat.type]!.add(cat.name);
          }
        }

        emit(
          CategoriesLoaded(
            categorizedData: groupedCategories,
            rawCategories: categories,
          ),
        );
      } catch (e) {
        emit(CategoriesError(message: e.toString()));
      }
    });

    // Inside ExpenseBloc constructor, add this event listener
    on<SubmitCreateCategoryEvent>((event, emit) async {
      // 🚨 SDE3 TRICK: Hum purani state store kar lenge
      final currentState = state;

      try {
        // 1. Hit API and SQLite
        final newCategory = await expenseRepository.createCategory(
          event.requestPayload,
        );

        // 2. Agar current state already loaded hai, toh bina API call kiye list update karo!
        if (currentState is CategoriesLoaded) {
          // A. Purani raw list ki copy banao
          final updatedRawCategories = List<CategoryModel>.from(
            currentState.rawCategories,
          );
          updatedRawCategories.add(newCategory);

          // B. Purane Map ki deep copy banao
          final Map<String, List<String>> updatedMap = {
            "Need": List<String>.from(
              currentState.categorizedData["Need"] ?? [],
            ),
            "Want": List<String>.from(
              currentState.categorizedData["Want"] ?? [],
            ),
            "Saving": List<String>.from(
              currentState.categorizedData["Saving"] ?? [],
            ),
          };

          // C. Nayi category map mein ghusao
          if (updatedMap.containsKey(newCategory.type)) {
            // 🚨 FIX 3: THE DUPLICATE CHECK
            if (!updatedMap[newCategory.type]!.contains(newCategory.name)) {
              updatedMap[newCategory.type]!.add(newCategory.name);
            }
          }

          // D. Nayi loaded state emit kardo (UI automatically react karega)
          emit(
            CategoriesLoaded(
              categorizedData: updatedMap,
              rawCategories: updatedRawCategories,
            ),
          );
        } else {
          // Agar galti se state loaded nahi thi, toh fetch call kardo
          add(FetchCategoriesEvent());
        }
      } catch (e) {
        // Error aaye toh popup dikhane ke liye state emit karo
        emit(ExpenseError(message: e.toString()));
        // Error ke baad purani state wapas la do taaki UI kharab na ho
        if (currentState is CategoriesLoaded) {
          emit(currentState);
        }
      }
    });
  }
}
