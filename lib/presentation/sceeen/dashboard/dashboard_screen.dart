import 'package:expense_analyser/application/dashboard/dashboard_bloc.dart';
import 'package:expense_analyser/application/dashboard/dashboard_event.dart';
import 'package:expense_analyser/application/dashboard/dashboard_state.dart';
import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/core/constants/responsive.dart';
import 'package:expense_analyser/core/locator/setup_locator.dart';
import 'package:expense_analyser/domain/models/response/dashboard_response.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/glass_card.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/monthly_card.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/rule_tracking.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/transaction_tile.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/wealth_hero_card.dart';
import 'package:expense_analyser/presentation/widgets/universalHeader/universal_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    locator<DashboardBloc>().add(FetchDashboardEvent());
  }

  String _getScoreLabel(int score) {
    if (score >= 80) return "EXCELLENT CONTROL";
    if (score >= 60) return "STABLE FINANCES";
    if (score >= 40) return "NEEDS ATTENTION";
    return "HIGH RISK";
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: UniversalHeader(username: "vi9shal"),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        bloc: locator<DashboardBloc>(),
        builder: (context, state) {
          // 1. Loading State (First time only)
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // 2. Error State
          if (state is DashboardError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // 3. Loaded State (Local Cache or Fresh API)
          if (state is DashboardLoaded) {
            final DashboardData data = state.data;
            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Syncing Indicator (If showing offline data)
                        if (state.isOfflineData)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Syncing fresh data...",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        WealthHeroCard(data: data.topCard),
                        const SizedBox(height: 16),
                        _buildFinancialScore(context, data.financialScore),
                        const SizedBox(height: 24),
                        _buildSectionHeader(context, "Recent Transactions"),
                        const SizedBox(height: 16),
                        if (data.recentTransactions.isEmpty)
                          const Center(
                            child: Text(
                              "No transactions yet.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

                        ...data.recentTransactions.map((txn) {
                          // Simple UI mapping based on type
                          bool isIncome =
                              txn.type ==
                              "Saving"; // Just for visual difference
                          IconData icon = txn.type == "Need"
                              ? Icons.home
                              : (txn.type == "Want"
                                    ? Icons.restaurant
                                    : Icons.savings);
                          Color bgColor = txn.type == "Want"
                              ? const Color(0xFFFFB3AF)
                              : AppColors.primary;

                          return TransactionTile(
                            icon: icon,
                            title: txn.description,
                            category: "${txn.category} • ${txn.paymentMode}",
                            amount: "₹${txn.amount.toStringAsFixed(0)}",
                            iconBgColor: bgColor,
                            isIncome: isIncome,
                          );
                        }),
                        const SizedBox(height: 16),
                        RuleTrackingCard(data: data.ruleProgress),
                        const SizedBox(height: 16),
                        MonthlyGoalCard(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildFinancialScore(BuildContext context, int score) {
    Color scoreColor = score >= 60
        ? AppColors.primary
        : (score >= 40 ? Colors.orange : AppColors.error);
    return GlassCard(
      borderColor: scoreColor,
      child: Column(
        children: [
          Text("FINANCIAL HEALTH SCORE", style: AppTextStyles.caption(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                score.toString(),
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
              _getScoreLabel(score),
              style: AppTextStyles.caption(context).copyWith(color: scoreColor),
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
