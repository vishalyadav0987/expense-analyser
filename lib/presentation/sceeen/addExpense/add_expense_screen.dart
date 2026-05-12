import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_radius.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/circular_icon_button.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/scanner_card.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/type_selected.dart';
import 'package:expense_analyser/presentation/widgets/customBorder/custom_dotted_border.dart';
import 'package:flutter/material.dart';

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
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      // HEADER
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
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
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),

                      // TOTAL AMOUNT
                      Text(
                        "TOTAL AMOUNT",
                        style: AppTextStyles.mutedLabel(
                          context,
                        ).copyWith(letterSpacing: 2),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r"₹",
                            style: AppTextStyles.heading1(
                              context,
                            ).copyWith(color: AppColors.primary, fontSize: 32),
                          ),
                          CustomDottedBorder(
                            borderType: BorderTypeEnum.bottom,
                            color: AppColors.textMuted,
                            child: SizedBox(
                              width: 200,
                              child: TextField(
                                controller: amountController,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.heading1(context).copyWith(
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

                      // CATEGORIES
                      TypeSelected(
                        modes: ["UPI", "Bank", "Cash", "Credit"],
                        selected: {"UPI", "Bank"},
                        bottomSheetHeading: "Add Custom Payment Mode",
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

                            const Icon(Icons.eco, color: AppColors.primaryDark),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),

                      TypeSelected(
                        modes: ["UPI", "Bank", "Cash", "Credit"],
                        selected: {"UPI", "Bank"},
                        bottomSheetHeading: "Add Custom Payment Mode",
                        title: "Category",
                      ),
                      SizedBox(height: AppSpacing.xl),
                      SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
