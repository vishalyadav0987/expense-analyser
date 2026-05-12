import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class WealthHeroCard extends StatelessWidget {
  const WealthHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("TOTAL BALANCE", style: AppTextStyles.caption(context).copyWith(letterSpacing: 1.2)),
              Text("₹48,540", style: AppTextStyles.heading1(context)),
              const SizedBox(height: 20),
              Row(
                children: [
                  _miniData(context, "BUDGET LEFT", "₹12,300", AppColors.primary),
                  const SizedBox(width: 24),
                  _miniData(context, "SAVINGS RATE", "24%", AppColors.blueGlow),
                ],
              )
            ],
          ),
          _buildProgressRing(context),
        ],
      ),
    );
  }

  Widget _miniData(BuildContext context, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption(context).copyWith(fontSize: 10)),
        Text(value, style: AppTextStyles.bodyLarge(context).copyWith(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProgressRing(
    BuildContext context
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: 0.24,
            strokeWidth: 8,
            backgroundColor: AppColors.cardBackground,
            color: AppColors.primary,
            strokeCap: StrokeCap.round,
          ),
        ),
        Column(
          children: [
            Text("TARGET", style: AppTextStyles.caption(context).copyWith(fontSize: 8)),
            Text("24%", style: AppTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.bold)),
          ],
        )
      ],
    );
  }
}