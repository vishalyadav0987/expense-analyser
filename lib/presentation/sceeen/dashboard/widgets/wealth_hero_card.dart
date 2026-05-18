import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/domain/models/response/dashboard_response.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class WealthHeroCard extends StatelessWidget {
  final TopCard data;
  const WealthHeroCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TOTAL BALANCE",
                style: AppTextStyles.caption(
                  context,
                ).copyWith(letterSpacing: 1.2),
              ),
              Text(
                "₹${data.totalSalary.toStringAsFixed(0)}",
                style: AppTextStyles.heading1(context),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _miniData(
                    context,
                    "BUDGET LEFT",
                    "₹${data.budgetPending.toStringAsFixed(0)}",
                    AppColors.primary,
                  ),
                  const SizedBox(width: 24),
                  _miniData(
                    context,
                    "SAVINGS RATE",
                    "₹${data.savingTarget.toStringAsFixed(0)}",
                    AppColors.blueGlow,
                  ),
                ],
              ),
            ],
          ),
          _buildProgressRing(context),
        ],
      ),
    );
  }

  Widget _miniData(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption(context).copyWith(fontSize: 10),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge(
            context,
          ).copyWith(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProgressRing(BuildContext context) {
    final double progress = data.currentSavingRate / 100;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: 8,
            backgroundColor: AppColors.cardBackground,
            color: progress >= 0.20 ? AppColors.primary : AppColors.error,
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          children: [
            Text(
              "SAVED",
              style: AppTextStyles.caption(context).copyWith(fontSize: 8),
            ),
            Text(
              "${data.currentSavingRate.toStringAsFixed(1)}%",
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
