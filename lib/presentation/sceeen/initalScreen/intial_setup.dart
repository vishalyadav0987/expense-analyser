import 'package:expense_analyser/application/auth/auth_bloc.dart';
import 'package:expense_analyser/application/auth/auth_event.dart';
import 'package:expense_analyser/application/setup/setup_bloc.dart';
import 'package:expense_analyser/application/setup/setup_event.dart';
import 'package:expense_analyser/application/setup/setup_state.dart';
import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/core/constants/responsive.dart';
import 'package:expense_analyser/core/locator/setup_locator.dart';
import 'package:expense_analyser/domain/models/request/initial_setup_request.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/glass_card.dart';
import 'package:expense_analyser/presentation/sceeen/initalScreen/widgets/budget_rule_selector.dart';
import 'package:expense_analyser/presentation/sceeen/initalScreen/widgets/payment_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({super.key});

  @override
  State<InitialSetupScreen> createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  // Controllers to capture user input
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _growthController = TextEditingController();
  final TextEditingController _weeklyLimitController = TextEditingController();

  double _needs = 50;
  double _wants = 30;
  double _savings = 20;

  // Initialize modes and default to ALL selected
  final List<String> _categoryModes = [
    "Life Infrastructure (Need)",
    "Future Me (Saving)",
    "Performance & Growth (Want)",
    "Relationship & Generosity (Want)",
    "Lifestyle Enjoyment (Want)",
  ];
  late final Set<String> _selectedCategories = Set.from(_categoryModes);

  final List<String> _paymentModes = ["Cash", "Debit Card", "Credit Card", "Upi","Bank"];
  late final Set<String> _selectedPaymentModes = Set.from(_paymentModes);

  @override
  void dispose() {
    _salaryController.dispose();
    _growthController.dispose();
    _weeklyLimitController.dispose();
    super.dispose();
  }

  void _submitSetup() {
    // 1. Safe parsing of text inputs
    final double salary = double.tryParse(_salaryController.text) ?? 0.0;
    final double growth =
        double.tryParse(_growthController.text.replaceAll('%', '')) ?? 0.0;
    final double weeklyLimit =
        double.tryParse(_weeklyLimitController.text) ?? 0.0;

    // 2. Parse Categories (String to Model)
    // Extracting "Life Infrastructure" and "Need" from "Life Infrastructure (Need)"
    final List<CategoryReq> parsedCategories = _selectedCategories.map((
      catString,
    ) {
      if (catString.contains('(') && catString.contains(')')) {
        final parts = catString.split('(');
        return CategoryReq(
          name: parts[0].trim(),
          type: parts[1].replaceAll(')', '').trim(),
        );
      }
      return CategoryReq(name: catString, type: "Unknown");
    }).toList();

    // 3. Parse Payment Methods
    final List<PaymentMethodReq> parsedPayments = _selectedPaymentModes.map((
      method,
    ) {
      return PaymentMethodReq(
        methodName: method,
        weeklyLimit: 0.0, // Default limit, user can edit later
        isActive: true,
      );
    }).toList();

    // 4. Construct Request Model
    final requestPayload = InitialSetupRequest(
      financials: FinancialsReq(
        monthlySalary: salary,
        yearlyHikePercentage: growth,
        xxWeeklyLimit: weeklyLimit,
      ),
      smartRules: SmartRulesReq(
        needsPercentage: _needs.toInt(),
        wantsPercentage: _wants.toInt(),
        savingsPercentage: _savings.toInt(),
      ),
      categories: parsedCategories,
      paymentMethods: parsedPayments,
    );

    // 5. Fire Event to BLoC!
    locator<SetupBloc>().add(
      SubmitInitialSetupEvent(requestPayload: requestPayload),
    );
  }

  void _showSummaryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.primary.withOpacity(0.3)),
          ),
          title: Text(
            "Engine Summary",
            style: AppTextStyles.heading2(
              context,
            ).copyWith(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _summaryRow(
                "Salary",
                _salaryController.text.isEmpty
                    ? "₹0.00"
                    : _salaryController.text,
              ),
              const SizedBox(height: 8),
              _summaryRow(
                "Weekly Limit",
                _weeklyLimitController.text.isEmpty
                    ? "₹0.00"
                    : _weeklyLimitController.text,
              ),
              const SizedBox(height: 8),
              // Note: Connect this to your actual BudgetRuleSelector state
              _summaryRow("Smart Rule", "Selected Rule / Custom"),
            ],
          ),
          actions: [
            // Wrap the buttons in a Row to control their layout
            Row(
              children: [
                // 1st Button (50% width) - Cancel
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        // Optional: Add a subtle border so it matches the UI style
                        side: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.2),
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),

                const SizedBox(width: 12), // Space between the buttons
                // 2nd Button (50% width) - Activate Engine
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        // Optional: Add a subtle border so it matches the UI style
                        side: BorderSide(
                          color: AppColors.textSecondary.withOpacity(0.2),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      _submitSetup(); // 🚨 Trigger API/DB!
                    },
                    child: Text(
                      "Activate",
                      style: TextStyle(color: AppColors.background),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<SetupBloc, SetupState>(
          bloc: locator<SetupBloc>(),
          listener: (context, state) {
            if (state is SetupError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
            if (state is SetupSuccess) {
              // 🚨 SDE3 MASTERSTROKE: Ask AuthBloc to re-check Vault.
              // AuthBloc will find SetupComplete = true and route to Dashboard automatically!
              locator<AuthBloc>().add(const AuthAppStarted());
            }
          },
          builder: (context, state) {
            final isLoading = state is SetupLoading;
            return Stack(
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
                        Column(
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
                          ],
                        ),

                        const SizedBox(height: 24),

                        // 1. SALARY & GROWTH & WEEKLY LIMIT
                        _buildSectionTitle("Income Engine"),
                        GlassCard(
                          child: Column(
                            children: [
                              _customInputField(
                                "Enter Monthly Salary",
                                "₹0.00",
                                Icons.account_balance_wallet,
                                _salaryController,
                              ),
                              const Divider(color: AppColors.white),
                              _customInputField(
                                "Est. Yearly Growth (%)",
                                "5%",
                                Icons.trending_up,
                                _growthController,
                              ),
                              const Divider(color: AppColors.white),
                              // Added Weekly Limit Field
                              _customInputField(
                                "Weekly Limit",
                                "₹0.00",
                                Icons.account_balance_wallet,
                                _weeklyLimitController,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 2. BUDGETING RULE (50/30/20 or Custom)
                        _buildSectionTitle("Allocation Logic"),
                        BudgetRuleSelector(
                          onChanged: (n, w, s) {
                            setState(() {
                              _needs = n;
                              _wants = w;
                              _savings = s;
                            });
                          },
                        ),

                        const SizedBox(height: 24),

                        // 3. TAGS & CATEGORIES
                        _buildSectionTitle("Classification Tags"),
                        PaymentModeSelector(
                          modes: _categoryModes,
                          selected: _selectedCategories,
                          bottomSheetHeading: "Add Custom Category",
                          title: "Category",
                          showTypeTags:
                              true, // Enables the Need/Want/Saving selection
                        ),
                        const SizedBox(height: 12),
                        PaymentModeSelector(
                          modes: _paymentModes,
                          selected: _selectedPaymentModes,
                          bottomSheetHeading: "Add Custom Payment Mode",
                          showTypeTags: false, // Hidden for Payment modes
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 20,
                spreadRadius: 1,
                offset: const Offset(0, -6),
              ),
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
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16,
              ), // Added bottom padding for a better look
              child: Row(
                children: [
                  // 1st Button (50% width) - SKIP
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.5),
                        ), // Outline border
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _showSummaryDialog,
                      child: Text(
                        "SKIP",
                        style: AppTextStyles.button(
                          context,
                        ).copyWith(color: AppColors.primary),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16), // Space between buttons
                  // 2nd Button (50% width) - ACTIVATE
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => {_submitSetup()},
                      child: Text(
                        "ACTIVATE",
                        style: AppTextStyles.button(
                          context,
                        ).copyWith(color: AppColors.buttonText),
                      ),
                    ),
                  ),
                ],
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

  Widget _customInputField(
    String label,
    String hint,
    IconData icon,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      style: AppTextStyles.bodyLarge(
        context,
      ).copyWith(fontFamily: 'JetBrains Mono'),
      keyboardType: TextInputType.number, // Optional: restricts to numbers
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
