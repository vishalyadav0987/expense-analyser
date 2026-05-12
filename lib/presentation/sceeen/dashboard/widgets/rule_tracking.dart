import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_radius.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class RuleTrackingCard extends StatelessWidget {
  const RuleTrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rule Tracking (50/30/20)",
                style: AppTextStyles.heading3(context),
              ),
              const Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          _buildRuleRow(
            context,
            "NEEDS (50%)",
            "48% Used",
            0.48,
            AppColors.primary,
          ),
          SizedBox(height: AppSpacing.md),
          _buildRuleRow(
            context,
            "WANTS (30%)",
            "36% Used",
            0.72,
            AppColors.error,
          ),
          SizedBox(height: AppSpacing.md),
          _buildRuleRow(
            context,
            "SAVINGS (20%)",
            "16% Saved",
            0.80,
            Colors.blueAccent,
          ),
          SizedBox(height: AppSpacing.lg),

          // AI Insight Plate
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: const Border(
                left: BorderSide(color: AppColors.hint, width: 4),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology, color: AppColors.hint),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodySmall(
                        context,
                      ).copyWith(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: "AI Insight: ",
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: "Reduce food delivery by "),
                        TextSpan(
                          text: "₹2,000",
                          style: TextStyle(
                            color: AppColors.hint,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: " this week to align with targets.",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleRow(
    BuildContext context,
    String label,
    String status,
    double progress,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontFamily: 'JetBrains Mono'),
            ),
            Text(
              status,
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.white),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.full),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.backgroundSecondary,
            color: color,
          ),
        ),
      ],
    );
  }
}
