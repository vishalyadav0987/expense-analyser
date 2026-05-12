import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_radius.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String category;
  final String amount;
  final Color iconBgColor;
  final bool isIncome;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.amount,
    required this.iconBgColor,
    this.isIncome = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconBgColor.withValues(alpha: 0.2),
            child: Icon(icon, color: iconBgColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLarge(context).copyWith(fontWeight: FontWeight.bold)),
                Text(category, style: AppTextStyles.bodySmall(context)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isIncome ? '+' : ''}$amount",
                style: AppTextStyles.bodyLarge(context).copyWith(
                  color: isIncome ? AppColors.primary : AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.check_circle, size: 14, color: AppColors.primary),
            ],
          )
        ],
      ),
    );
  }
}