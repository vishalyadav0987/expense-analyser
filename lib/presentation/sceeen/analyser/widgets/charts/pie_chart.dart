import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ReusablePieChart extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final List<Color> colors;
  final double centerRadius;
  final bool showPercent;

  const ReusablePieChart({
    super.key,
    required this.labels,
    required this.values,
    required this.colors,
    this.centerRadius = 55,
    this.showPercent = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PieChart(
        PieChartData(
          centerSpaceRadius: centerRadius,
          sectionsSpace: 2,
          sections: _buildSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = values.fold(0.0, (a, b) => a + b);

    return List.generate(values.length, (i) {
      final percent = (values[i] / total) * 100;

      return PieChartSectionData(
        value: values[i],
        color: colors[i],
        radius: 60,
        title: showPercent ? "${percent.toInt()}%" : labels[i],
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
