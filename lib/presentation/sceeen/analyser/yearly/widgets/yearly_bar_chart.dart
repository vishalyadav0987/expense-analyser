import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/analytics_section_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class YearlyBarChart extends StatelessWidget {
  const YearlyBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AnalyticsSectionCard(
      title: "Yearly Expense Trend",

      child: SizedBox(
        height: 300,

        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            groupsSpace: 14,

            /// TOUCH
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(

                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    "₹${rod.toY.toInt()}K",
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),

            /// GRID
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,

              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white.withOpacity(0.05),
                  strokeWidth: 1,
                );
              },
            ),

            /// BORDER
            borderData: FlBorderData(show: false),

            /// LIMIT LINE
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                HorizontalLine(
                  y: 75,
                  color: Colors.redAccent,
                  strokeWidth: 1.5,
                  dashArray: [6, 4],

                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,

                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),

                    labelResolver: (line) => "Budget Limit",
                  ),
                ),
              ],
            ),

            /// TITLES
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  interval: 25,

                  getTitlesWidget: (value, meta) {
                    return Text(
                      "${value.toInt()}K",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ),

              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,

                  getTitlesWidget: (value, meta) {
                    const months = [
                      'Jan',
                      'Feb',
                      'Mar',
                      'Apr',
                      'May',
                      'Jun',
                      'Jul',
                      'Aug',
                      'Sep',
                      'Oct',
                      'Nov',
                      'Dec',
                    ];

                    final index = value.toInt();

                    if (index < 0 || index >= months.length) {
                      return const SizedBox.shrink();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(top: 8),

                      child: Text(
                        months[index],
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  },
                ),
              ),

              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),

              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),

            /// BAR GROUPS
            barGroups: _buildGroups(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildGroups() {
    final data = [
      40.0,
      70.0,
      30.0,
      90.0,
      55.0,
      62.0,
      48.0,
      75.0,
      82.0,
      64.0,
      52.0,
      95.0,
    ];

    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,

        barRods: [
          BarChartRodData(
            toY: data[i],
            width: 16,

            borderRadius: BorderRadius.circular(8),

            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,

              colors: [Colors.cyan, Colors.blue, Colors.purple],
            ),
          ),
        ],
      );
    });
  }
}
