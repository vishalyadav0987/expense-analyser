import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_radius.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class AnalyzerFilterBar extends StatefulWidget {
  final String selectedRange;
  final int selectedMonth;
  final int selectedYear;

  final Function(int) onMonthChanged;
  final Function(int) onYearChanged;

  const AnalyzerFilterBar({
    super.key,
    required this.selectedRange,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  State<AnalyzerFilterBar> createState() => _AnalyzerFilterBarState();
}

class _AnalyzerFilterBarState extends State<AnalyzerFilterBar> {
  String selectedCategory = "All";
  String selectedMode = "All";

  final List<String> months = [
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
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HANDLE
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            Text("Filters", style: AppTextStyles.heading3(context)),

            SizedBox(height: AppSpacing.lg),

            /// =========================
            /// DYNAMIC DATE FILTERS
            /// =========================
            Text("Date Filter", style: AppTextStyles.mutedLabel(context)),

            SizedBox(height: AppSpacing.sm),

            if (widget.selectedRange == "Weekly") _buildWeeklyFilter(),

            if (widget.selectedRange == "Monthly") _buildMonthlyFilter(),

            if (widget.selectedRange == "Yearly") _buildYearlyFilter(),

            SizedBox(height: AppSpacing.lg),

            /// CATEGORY
            Text("Expense Category", style: AppTextStyles.mutedLabel(context)),

            SizedBox(height: AppSpacing.sm),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ["All", "NEED", "WANT", "SAVING"].map((cat) {
                final isSelected = selectedCategory == cat;

                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = cat;
                    });
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.cardBackground,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.buttonText : AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: AppSpacing.lg),

            /// PAYMENT MODE
            Text("Payment Mode", style: AppTextStyles.mutedLabel(context)),

            SizedBox(height: AppSpacing.sm),

            _CustomDropdown(
              value: selectedMode,
              items: const [
                "All",
                "UPI",
                "Cash",
                "Credit Card",
                "Bank Transfer",
              ],
              onChanged: (val) {
                setState(() {
                  selectedMode = val!;
                });
              },
            ),

            SizedBox(height: AppSpacing.xl),

            /// APPLY BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Apply Filters",
                style: AppTextStyles.button(context),
              ),
            ),

            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// WEEKLY
  /// =========================

  Widget _buildWeeklyFilter() {
    return _CustomDropdown(
      value: "This Week",
      items: const ["This Week", "Last Week", "2 Weeks Ago", "3 Weeks Ago"],
      onChanged: (_) {},
    );
  }

  /// =========================
  /// MONTHLY
  /// =========================

  Widget _buildMonthlyFilter() {
    return Row(
      children: [
        Expanded(
          child: _CustomDropdown(
            value: months[widget.selectedMonth - 1],
            items: months,
            onChanged: (val) {
              widget.onMonthChanged(months.indexOf(val!) + 1);
            },
          ),
        ),

        SizedBox(width: AppSpacing.md),

        Expanded(
          child: _CustomDropdown(
            value: widget.selectedYear.toString(),
            items: List.generate(10, (i) => (2020 + i).toString()),
            onChanged: (val) {
              widget.onYearChanged(int.parse(val!));
            },
          ),
        ),
      ],
    );
  }

  /// =========================
  /// YEARLY
  /// =========================

  Widget _buildYearlyFilter() {
    return _CustomDropdown(
      value: widget.selectedYear.toString(),
      items: List.generate(10, (i) => (2020 + i).toString()),
      onChanged: (val) {
        widget.onYearChanged(int.parse(val!));
      },
    );
  }
}

class _CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _CustomDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.backgroundSecondary,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: AppTextStyles.bodyMedium(
                  context,
                ).copyWith(color: AppColors.white),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
