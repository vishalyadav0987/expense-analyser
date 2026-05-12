import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class YearlySummarySection extends StatelessWidget {
  const YearlySummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SummaryCard(
          title: "Total Spent",
          amount: "₹4,82,000",
          growth: "+12%",
          icon: Icons.trending_down_rounded,
          growthColor: Colors.redAccent,
        ),

        SizedBox(height: 16),

        SummaryCard(
          title: "Total Saved",
          amount: "₹1,25,000",
          growth: "+18%",
          icon: Icons.savings_rounded,
          growthColor: Colors.greenAccent,
        ),

        SizedBox(height: 16),

        SummaryCard(
          title: "Avg Monthly",
          amount: "₹40,200",
          growth: "-2%",
          icon: Icons.bar_chart_rounded,
          growthColor: Colors.orangeAccent,
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String growth;
  final IconData icon;
  final Color growthColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.growth,
    required this.icon,
    required this.growthColor,
  });

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
            Colors.blue.withOpacity(0.16),
            Colors.purple.withOpacity(0.10),
          ],
        ),

        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// TOP ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: Colors.white70,
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: growthColor.withOpacity(0.15),
                ),

                child: Icon(
                  icon,
                  color: growthColor,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// AMOUNT
          Text(
            amount,
            style: AppTextStyles.heading2(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          /// GROWTH
          Row(
            children: [
              Icon(
                growth.startsWith("-")
                    ? Icons.arrow_downward_rounded
                    : Icons.arrow_upward_rounded,
                color: growthColor,
                size: 16,
              ),

              const SizedBox(width: 4),

              Text(
                growth,
                style: TextStyle(
                  color: growthColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                "vs last year",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}