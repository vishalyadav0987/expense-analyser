import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/widgets/analyzer_filter_bar.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/widgets/charts/pie_chart.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/widgets/pie_chart_category.dart';
import 'package:expense_analyser/presentation/sceeen/analyser/yearly/yearly_analysis_view.dart';
import 'package:flutter/material.dart';
import 'widgets/time_range_toggle.dart';
import 'widgets/expense_chart_section.dart';
import 'widgets/transaction_list_section.dart';

class AnalyserScreen extends StatefulWidget {
  const AnalyserScreen({super.key});

  @override
  State<AnalyserScreen> createState() => _AnalyserScreenState();
}

class _AnalyserScreenState extends State<AnalyserScreen> {
  String selectedRange = "Weekly"; // Weekly, Monthly, Yearly
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  final List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("Analysis", style: AppTextStyles.heading3(context)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.primary),
            onPressed: () => _showFilterBottomSheet(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          children: [
            SizedBox(height: AppSpacing.md),
            TimeRangeToggle(
              currentValue: selectedRange,
              onChanged: (val) => setState(() => selectedRange = val),
            ),
            SizedBox(height: AppSpacing.lg),

            // Section 1: Bar Graph (Rupees vs Time)
            if (selectedRange != "Yearly" ) const ExpenseChartSection(),

            if (selectedRange != "Yearly" )  SizedBox(height: AppSpacing.lg),

            if (selectedRange != "Yearly" ) PieChartCategory(
              heading: "Spending Habits",
              labels: ["Needs", "Wants", "Savings"],
              colors: [AppColors.primary, Colors.orange, Colors.blue],
              child: ReusablePieChart(
                labels: ["Needs", "Wants", "Savings"],
                values: [50, 30, 20],
                colors: [AppColors.primary, Colors.orange, Colors.blue],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            PieChartCategory(
              heading: "Spending Habits",
              labels: [
                "Life Infrastructure",
                "Future Me",
                "Performance & Growth",
                "Relationship & Generosity",
                "Lifestyle Enjoyment",
              ],
              colors: [
                Colors.blue,
                Colors.purple,
                Colors.orange,
                Colors.green,
                Colors.pink,
              ],
              child: ReusablePieChart(
                labels: [
                  "Life Infrastructure",
                  "Future Me",
                  "Performance & Growth",
                  "Relationship & Generosity",
                  "Lifestyle Enjoyment",
                ],
                values: [25, 20, 20, 15, 20],
                colors: [
                  Colors.blue,
                  Colors.purple,
                  Colors.orange,
                  Colors.green,
                  Colors.pink,
                ],
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            if (selectedRange == "Monthly") ...[
              SizedBox(height: AppSpacing.lg),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 31,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final day = index + 1;

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.border.withOpacity(0.15),
                      ),
                    ),

                    child: ListTile(
                      contentPadding: EdgeInsets.zero,

                      onTap: () {
                        // OPEN DETAILS
                      },

                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Text(
                          "$day",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      title: Text(
                        "${_months[selectedMonth - 1]} $day",
                        style: const TextStyle(color: Colors.white),
                      ),

                      subtitle: const Text(
                        "6 Transactions",
                        style: TextStyle(color: Colors.grey),
                      ),

                      trailing: const Text(
                        "₹1,240",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],

            // Section 3: Recent Transactions
            if (selectedRange == "Weekly") TransactionListSection(),

            if (selectedRange == "Yearly") YearlyAnalysisView(),

            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        top: false,
        child: AnalyzerFilterBar(
          selectedRange: selectedRange,
          selectedMonth: selectedMonth,
          selectedYear: selectedYear,
          onMonthChanged: (month) {
            setState(() => selectedMonth = month);
          },
          onYearChanged: (year) {
            setState(() => selectedYear = year);
          },
        ),
      ),
    );
  }
}
