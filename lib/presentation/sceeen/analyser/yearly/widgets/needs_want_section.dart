import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class NeedsWantsSection extends StatelessWidget {
  const NeedsWantsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,

          colors: [
            Colors.blue.withOpacity(0.12),
            Colors.purple.withOpacity(0.08),
          ],
        ),

        border: Border.all(color: Colors.white.withOpacity(0.06)),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// TITLE
          Text("Financial Balance", style: AppTextStyles.heading3(context)),

          const SizedBox(height: 8),

          Text(
            "Needs vs Wants vs Savings",
            style: AppTextStyles.bodyMedium(
              context,
            ).copyWith(color: Colors.white70),
          ),

          const SizedBox(height: 28),

          /// PIE CHART
          SizedBox(
            height: 240,

            child: Stack(
              alignment: Alignment.center,

              children: [
                PieChart(
                  PieChartData(
                    centerSpaceRadius: 70,
                    sectionsSpace: 4,

                    sections: [
                      PieChartSectionData(
                        value: 50,
                        color: Colors.cyan,
                        radius: 55,
                        title: "50%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      PieChartSectionData(
                        value: 30,
                        color: Colors.orangeAccent,
                        radius: 55,
                        title: "30%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),

                      PieChartSectionData(
                        value: 20,
                        color: Colors.greenAccent,
                        radius: 55,
                        title: "20%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                /// CENTER TEXT
                Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(
                      "Balanced",
                      style: AppTextStyles.bodyLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Financial Health",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// LEGEND
          Column(
            children: const [
              _LegendTile(
                color: Colors.cyan,
                title: "Needs",
                percentage: "50%",
              ),

              SizedBox(height: 14),

              _LegendTile(
                color: Colors.orangeAccent,
                title: "Wants",
                percentage: "30%",
              ),

              SizedBox(height: 14),

              _LegendTile(
                color: Colors.greenAccent,
                title: "Savings",
                percentage: "20%",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendTile extends StatelessWidget {
  final Color color;
  final String title;
  final String percentage;

  const _LegendTile({
    required this.color,
    required this.title,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// COLOR DOT
        Container(
          width: 14,
          height: 14,

          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),

        const SizedBox(width: 12),

        /// TITLE
        Expanded(child: Text(title, style: AppTextStyles.bodyMedium(context))),

        /// PERCENTAGE
        Text(
          percentage,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
