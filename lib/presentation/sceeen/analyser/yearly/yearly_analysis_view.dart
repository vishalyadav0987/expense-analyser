import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/monthly_breakdown_section.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/needs_want_section.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/savings_line_chart.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/smart_insights_section.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/yearly_bar_chart.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/yearly/widgets/yearly_summary_section.dart';
import 'package:flutter/material.dart';

class YearlyAnalysisView extends StatelessWidget {
  const YearlyAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const SizedBox(height: 10),

          /// SUMMARY
          const YearlySummarySection(),

          const SizedBox(height: 32),

          /// YEARLY CHART
          const YearlyBarChart(),

          const SizedBox(height: 32),

          /// SAVINGS TREND
          const SavingsLineChart(),

          const SizedBox(height: 32),

          /// NEEDS/WANTS
          const NeedsWantsSection(),
          const SizedBox(height: 32),


          /// SMART INSIGHTS
          const SmartInsightsSection(),

          const SizedBox(height: 32),

          /// MONTHLY BREAKDOWN
          const MonthlyBreakdownSection(),

          const SizedBox(height: 32),

          /// GOALS
          // const GoalsProgressSection(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
