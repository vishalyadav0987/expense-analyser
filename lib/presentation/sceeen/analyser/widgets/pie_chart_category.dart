import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class PieChartCategory extends StatelessWidget {
  final Widget child;
  final String heading;
  final List<String>? labels; // Added to show a legend
  final List<Color>? colors;

  const PieChartCategory({
    super.key,
    required this.child,
    required this.heading,
    this.labels,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading, style: AppTextStyles.bodyLarge(context)),
        SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              SizedBox(height: 250, child: child), // Fixed height for chart
              if (labels != null && colors != null) ...[
                const SizedBox(height: 16),
                _buildLegend(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(labels!.length, (i) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: colors![i],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              labels![i],
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        );
      }),
    );
  }
}
