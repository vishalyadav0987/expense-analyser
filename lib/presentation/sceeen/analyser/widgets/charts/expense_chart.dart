import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseBarChart extends StatelessWidget {
  const ExpenseBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          groupsSpace: 10,

          barTouchData: BarTouchData(enabled: true),

          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),

          barGroups: _buildGroups(),

          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 75,
                color: Colors.redAccent,
                strokeWidth: 1.5,
                dashArray: [6, 4], // makes it dashed
                label: HorizontalLineLabel(
                  show: false,
                  alignment: Alignment.topRight,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                  labelResolver: (line) => "Limit 75",
                ),
              ),
            ],
          ),

          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  return Text(
                    "${value.toInt()}",
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
                  const labels = [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                  ];

                  final index = value.toInt();

                  if (index < 0 || index >= labels.length) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      labels[index],
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
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
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildGroups() {
    final data = [40.0, 70.0, 30.0, 90.0, 55.0, 40.0, 70.0, 30.0, 90.0, 55.0];

    return List.generate(data.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i],
            width: 16,
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ],
      );
    });
  }
}
