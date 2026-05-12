import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class AnalyticsSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const AnalyticsSectionCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: AppColors.cardBackground,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: Colors.white.withOpacity(0.06)),

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(title, style: AppTextStyles.heading3(context)),

          const SizedBox(height: 20),

          child,
        ],
      ),
    );
  }
}
