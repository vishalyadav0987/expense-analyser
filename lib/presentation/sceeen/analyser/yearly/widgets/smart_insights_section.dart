import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/analytics_section_card.dart';
import 'package:flutter/material.dart';

class SmartInsightsSection extends StatelessWidget {
  const SmartInsightsSection({super.key});

  @override
  Widget build(BuildContext context) {

    final insights = [

      "You spent 22% more on lifestyle this year.",

      "March was your strongest savings month.",

      "Weekend spending increased by 41%.",

      "Food delivery crossed ₹48,000.",
    ];

    return AnalyticsSectionCard(

      title: "Smart Insights",

      child: Column(

        children: insights.map((e) {

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(

              color: Colors.white.withOpacity(0.03),

              borderRadius: BorderRadius.circular(18),

              border: Border.all(
                color: Colors.white.withOpacity(0.05),
              ),
            ),

            child: Row(

              children: [

                const Icon(
                  Icons.auto_awesome,
                  color: Colors.cyan,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    e,
                    style: AppTextStyles.bodyMedium(context),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}