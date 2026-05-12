import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/core/constants/responsive.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/glass_card.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/monthly_card.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/rule_tracking.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/transaction_tile.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/wealth_hero_card.dart';
import 'package:expense_analyser/presentation/widgets/universalHeader/universal_header.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: UniversalHeader(username: "vi9shal"),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WealthHeroCard(),
                  const SizedBox(height: 16),
                  _buildFinancialScore(context),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, "Recent Transactions"),
                  const SizedBox(height: 16),
                  const TransactionTile(
                    icon: Icons.restaurant,
                    title: "Swiggy",
                    category: "Food & Dining • Today",
                    amount: "₹420.00",
                    iconBgColor: Color(0xFFFFB3AF),
                  ),
                  const TransactionTile(
                    icon: Icons.payments,
                    title: "InnoTech Solutions",
                    category: "Salary • 2 days ago",
                    amount: "₹85k",
                    iconBgColor: AppColors.primary,
                    isIncome: true,
                  ),
                  const SizedBox(height: 16),
                  RuleTrackingCard(),
                  const SizedBox(height: 16),
                  MonthlyGoalCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialScore(BuildContext context) {
    return GlassCard(
      borderColor: AppColors.primary,
      child: Column(
        children: [
          Text("FINANCIAL HEALTH SCORE", style: AppTextStyles.caption(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "82",
                style: AppTextStyles.displayLarge(
                  context,
                ).copyWith(fontSize: 64, color: AppColors.primary),
              ),
              Text("/100", style: AppTextStyles.bodyLarge(context)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "EXCELLENT CONTROL",
              style: AppTextStyles.caption(
                context,
              ).copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading3(context)),

        GestureDetector(
          onTap: onViewAll,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              children: const [
                Text(
                  "View All",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
