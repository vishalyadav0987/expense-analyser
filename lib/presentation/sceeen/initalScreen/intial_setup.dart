import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/core/constants/responsive.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/glass_card.dart';
import 'package:expense_analyser/presentation/sceeen/initalScreen/widgets/budget_rule_selector.dart';
import 'package:expense_analyser/presentation/sceeen/initalScreen/widgets/payment_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Ambient Glow Background
            Positioned(
              top: -100,
              left: -50,
              child: _ambientGlow(AppColors.primary),
            ),
            Positioned(
              bottom: 50,
              right: -50,
              child: _ambientGlow(AppColors.blueGlow),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "INITIALIZE RULES",
                      style: AppTextStyles.heading1(context),
                    ),
                    Text(
                      "Configure your financial engine",
                      style: AppTextStyles.bodySmall(context),
                    ),
                    const SizedBox(height: 32),

                    // 1. SALARY & GROWTH
                    _buildSectionTitle("Income Engine"),
                    GlassCard(
                      child: Column(
                        children: [
                          _customInputField(
                            "Enter Monthly Salary",
                            "₹0.00",
                            Icons.account_balance_wallet,
                          ),
                          const Divider(color: AppColors.white),
                          _customInputField(
                            "Est. Yearly Growth (%)",
                            "5%",
                            Icons.trending_up,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 2. BUDGETING RULE (50/30/20 or Custom)
                    _buildSectionTitle("Allocation Logic"),
                    const BudgetRuleSelector(),

                    const SizedBox(height: 24),

                    // 3. TAGS & CATEGORIES
                    _buildSectionTitle("Classification Tags"),
                    PaymentModeSelector(
                      modes: [
                        "Life Infrastructure",
                        "Future Me",
                        "Perfromance & Growth",
                        "Relationship & Generosity",
                        "Lifestyle Enjoyment",
                      ],
                      selected: {
                        "Future Me",
                        "Relationship & Generosity",
                        "Lifestyle Enjoyment",
                      },
                      bottomSheetHeading: "Add Custom Categories",
                      title: "Category",
                    ),
                    const SizedBox(height: 12),
                    PaymentModeSelector(
                      modes: ["UPI", "Bank", "Cash", "Credit"],
                      selected: {"UPI", "Bank"},
                      bottomSheetHeading: "Add Custom Payment Mode",
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              // 🔥 Soft base shadow (depth)
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, -6),
              ),

              // ✨ PRIMARY GLOW (like ambient light)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.12),
                blurRadius: 40,
                spreadRadius: 5,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0, // IMPORTANT: avoid double shadow
                  ),
                  onPressed: () => context.go('/dashboard'),
                  child: Text(
                    "ACTIVATE ENGINE",
                    style: AppTextStyles.button(
                      context,
                    ).copyWith(color: AppColors.buttonText),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ambientGlow(Color color) {
    return Container(
      width: 300,
      height: 300,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.caption(
          context,
        ).copyWith(letterSpacing: 2, color: AppColors.primary),
      ),
    );
  }

  Widget _customInputField(String label, String hint, IconData icon) {
    return TextField(
      style: AppTextStyles.bodyLarge(
        context,
      ).copyWith(fontFamily: 'JetBrains Mono'),
      decoration: InputDecoration(
        icon: Icon(icon, color: AppColors.textSecondary, size: 20),
        labelText: label,
        labelStyle: AppTextStyles.caption(context),
        hintText: hint,
        border: InputBorder.none,
      ),
    );
  }
}
