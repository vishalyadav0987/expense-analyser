import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/analytics_section_card.dart';
import 'package:flutter/material.dart';

class MonthlyBreakdownSection extends StatelessWidget {
  const MonthlyBreakdownSection({super.key});

  @override
  Widget build(BuildContext context) {

    final months = [

      ["January", "₹42,000"],
      ["February", "₹38,000"],
      ["March", "₹51,000"],
    ];

    return AnalyticsSectionCard(

      title: "Monthly Breakdown",

      child: Column(

        children: months.map((e) {

          return ListTile(

            contentPadding: EdgeInsets.zero,

            title: Text(
              e[0],
              style: AppTextStyles.bodyLarge(context),
            ),

            trailing: Text(
              e[1],
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}