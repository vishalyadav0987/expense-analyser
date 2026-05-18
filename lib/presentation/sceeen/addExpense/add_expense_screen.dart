import 'package:expense_analyser/application/expense/expense_bloc.dart';
import 'package:expense_analyser/application/expense/expense_event.dart';
import 'package:expense_analyser/application/expense/expense_state.dart';
import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_radius.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/core/locator/setup_locator.dart';
import 'package:expense_analyser/domain/models/request/add_expense_request.dart';
import 'package:expense_analyser/domain/models/response/get_categories_response.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/circular_icon_button.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/scanner_card.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/type_selected.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/categorized_type_selector.dart'; // Add this import
import 'package:expense_analyser/presentation/widgets/customBorder/custom_dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController amountController = TextEditingController(
    text: "248.50",
  );
  final TextEditingController descriptionController = TextEditingController();

  // Selected state for Payment
  final List<String> _paymentModes = ["Upi", "Bank", "Cash", "Credit"];
  final Set<String> _selectedPaymentMode = {"Upi"}; // Set default

  // Selected state for Category maps
  Map<String, List<String>> _expenseCategories = {
    "Need": [],
    "Want": [],
    "Saving": [],
  };
  final Set<String> _selectedCategory = {};

  List<CategoryModel> _rawCategories = [];

  @override
  void initState() {
    super.initState();
    final currentState = locator<ExpenseBloc>().state;
    if (currentState is CategoriesLoaded) {
      _expenseCategories = {
        "Need": List<String>.from(currentState.categorizedData["Need"] ?? []),
        "Want": List<String>.from(currentState.categorizedData["Want"] ?? []),
        "Saving": List<String>.from(
          currentState.categorizedData["Saving"] ?? [],
        ),
      };
      _rawCategories = List.from(currentState.rawCategories);

      if (_selectedCategory.isEmpty && _expenseCategories["Need"]!.isNotEmpty) {
        _selectedCategory.add(_expenseCategories["Need"]!.first);
      }
    }

    // Uske baad background me API fetch maar do naye data ke liye
    locator<ExpenseBloc>().add(FetchCategoriesEvent());
  }

  void _submitExpense() {
    FocusScope.of(context).unfocus();

    final amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid amount"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final description = descriptionController.text.trim();
    final paymentMode = _selectedPaymentMode.isNotEmpty
        ? _selectedPaymentMode.first
        : "Cash";
    final categoryName = _selectedCategory.isNotEmpty
        ? _selectedCategory.first
        : "";

    String categoryId = "";

    try {
      // 3. 🚨 SDE3 DYNAMIC ID MAPPING: Naam (e.g. "Rent") se uska ID (e.g. "cat_xxx") dhundo
      categoryId = _rawCategories
          .firstWhere((cat) => cat.name == categoryName)
          .id;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a category"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    final requestPayload = AddExpenseRequest(
      amount: amount,
      categoryId: categoryId, // DYNAMIC ID GAYA YAHAN!
      description: description,
      paymentMode: paymentMode,
      date: DateTime.now(),
    );

    locator<ExpenseBloc>().add(
      SubmitAddExpenseEvent(requestPayload: requestPayload),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        body: BlocConsumer<ExpenseBloc, ExpenseState>(
          bloc: locator<ExpenseBloc>(),
          listener: (context, state) {
            // ERROR CASE
            if (state is CategoriesLoaded) {
              setState(() {
                // 🚨 FIX 2: DEEP COPY THE MAP (Isse memory referencing ka issue solve hoga)
                _expenseCategories = {
                  "Need": List<String>.from(
                    state.categorizedData["Need"] ?? [],
                  ),
                  "Want": List<String>.from(
                    state.categorizedData["Want"] ?? [],
                  ),
                  "Saving": List<String>.from(
                    state.categorizedData["Saving"] ?? [],
                  ),
                };
                _rawCategories = List.from(state.rawCategories);

                if (_selectedCategory.isEmpty &&
                    _expenseCategories["Need"]!.isNotEmpty) {
                  _selectedCategory.add(_expenseCategories["Need"]!.first);
                }
              });
            }
            if (state is ExpenseError) {
              debugPrint("Check: ${state.message}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }

            // SUCCESS CASE
            if (state is ExpenseSuccess) {
              final warning = state.response.data?.limitWarning;

              // 🚨 SMART UX: Limit Warning Interception
              if (warning != null) {
                // Show Budget Exceeded Warning
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      warning.message,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.orangeAccent.shade700,
                    duration: const Duration(seconds: 4),
                  ),
                );
              } else {
                // Normal Success
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Expense added successfully!"),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }

              // Navigate back to Dashboard smoothly
              context.go('/dashboard');
            }
          },
          builder: (context, state) {
            final isLoading = state is ExpenseLoading;
            return SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: AppSpacing.lg,
                      right: AppSpacing.lg,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HEADER
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircularIconButton(
                                  icon: Icons.arrow_back,
                                  onTap: () {},
                                ),
                                Text(
                                  "Quick Add",
                                  style: AppTextStyles.bodyLarge(context),
                                ),
                                CircularIconButton(
                                  icon: Icons.check,
                                  backgroundColor: AppColors.primary,
                                  iconColor: AppColors.buttonText,
                                  isLoading: isLoading,
                                  onTap: _submitExpense,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.lg),

                          // TOTAL AMOUNT
                          Center(
                            child: Text(
                              "TOTAL AMOUNT",
                              style: AppTextStyles.mutedLabel(
                                context,
                              ).copyWith(letterSpacing: 2),
                            ),
                          ),
                          SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r"₹",
                                style: AppTextStyles.heading1(context).copyWith(
                                  color: AppColors.primary,
                                  fontSize: 32,
                                ),
                              ),
                              CustomDottedBorder(
                                borderType: BorderTypeEnum.bottom,
                                color: AppColors.textMuted,
                                child: SizedBox(
                                  width: 200,
                                  child: TextField(
                                    controller: amountController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.heading1(context)
                                        .copyWith(
                                          color: AppColors.primary,
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.lg),

                          // SCANNER CARD
                          const ScannerCard(),
                          SizedBox(height: AppSpacing.lg),

                          // PAYMENT MODES (Single select, no add button)
                          TypeSelected(
                            modes: _paymentModes,
                            selected: _selectedPaymentMode,
                            bottomSheetHeading:
                                "", // Unused since Add is hidden
                            title: "Payment Mode",
                            singleSelect: true,
                            showAddButton: false,
                          ),
                          SizedBox(height: AppSpacing.lg),

                          // DESCRIPTION FIELD
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.description_outlined,
                                  color: AppColors.textMuted,
                                ),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: TextField(
                                    controller: descriptionController,
                                    style: AppTextStyles.bodySmall(context),
                                    decoration: const InputDecoration(
                                      hintText: "Add a description...",
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.eco,
                                  color: AppColors.primaryDark,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),

                          // CATEGORIES (Need/Want/Saving tabs)
                          CategorizedTypeSelector(
                            categories: _expenseCategories,
                            selected: _selectedCategory,
                            title: "Category",
                          ),
                          SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
