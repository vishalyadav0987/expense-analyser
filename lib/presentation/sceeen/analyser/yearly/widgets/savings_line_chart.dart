import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/analytics_section_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SavingsLineChart extends StatelessWidget {
  const SavingsLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalyticsSectionCard(
      title: "Savings Consistency",

      child: SizedBox(
        height: 250,

        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                isCurved: true,

                spots: const [
                  FlSpot(0, 3),
                  FlSpot(1, 4),
                  FlSpot(2, 2),
                  FlSpot(3, 5),
                  FlSpot(4, 6),
                ],

                color: Colors.green,
                barWidth: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
