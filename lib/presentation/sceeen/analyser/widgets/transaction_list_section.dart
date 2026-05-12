import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class TransactionListSection extends StatelessWidget {
  const TransactionListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Recent Activity", style: AppTextStyles.bodyLarge(context)),
            _ViewAllButton(),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        // Generating 5 tiles as requested
        ...List.generate(
          5,
          (index) => TransactionTile(
            title: "Grocery Shopping",
            category: "NEED",
            amount: "₹1,200",
            icon: Icons.shopping_basket,
            iconBgColor: Colors.orange.withOpacity(0.2),
            isIncome: false,
          ),
        ),
      ],
    );
  }
}

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
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.white, size: 20),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium(
                    context,
                  ).copyWith(color: AppColors.white),
                ),
                Text(category, style: AppTextStyles.caption(context)),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: isIncome ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Text(
          "View All",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 4),
        Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
      ],
    );
  }
}
