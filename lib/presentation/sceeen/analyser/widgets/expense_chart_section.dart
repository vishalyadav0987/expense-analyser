import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/widgets/charts/expense_chart.dart';
import 'package:flutter/material.dart';

class ExpenseChartSection extends StatelessWidget {
  const ExpenseChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Spending Statistics", style: AppTextStyles.bodyLarge(context)),
        SizedBox(height: AppSpacing.md),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: const ExpenseBarChart(),
          ),
        ),
      ],
    );
  }
}
