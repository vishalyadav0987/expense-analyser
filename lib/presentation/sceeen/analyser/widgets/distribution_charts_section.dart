import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class DistributionChartsSection extends StatelessWidget {
  const DistributionChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildPieCard(context, "By Category", "Food, Needs..."),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _buildPieCard(context, "By Mode", "UPI, Cash...")),
      ],
    );
  }

  Widget _buildPieCard(BuildContext context, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyles.bodySmall(
              context,
            ).copyWith(color: AppColors.white),
          ),
          const SizedBox(height: 12),
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.glass,
          ), // Placeholder for PieChart
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: AppTextStyles.caption(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
