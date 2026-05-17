import 'dart:math';
import 'dart:ui';

import 'package:expense_analyser/application/auth/auth_bloc.dart';
import 'package:expense_analyser/application/auth/auth_event.dart';
import 'package:expense_analyser/application/auth/auth_state.dart';
import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_radius.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/core/constants/responsive.dart';
import 'package:expense_analyser/core/locator/setup_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class BoimtericSetupScreen extends StatefulWidget {
  const BoimtericSetupScreen({super.key});

  @override
  State<BoimtericSetupScreen> createState() => _BoimtericSetupScreenState();
}

class _BoimtericSetupScreenState extends State<BoimtericSetupScreen>
    with TickerProviderStateMixin {
  // =========================================================
  // BIOMETRIC
  // =========================================================

  final LocalAuthentication auth = LocalAuthentication();

  bool isLoading = false;

  bool biometricEnabled = false;

  // =========================================================
  // ANIMATION
  // =========================================================

  late AnimationController _pulseController;

  late AnimationController _rotateController;

  late Animation<double> _pulseAnimation;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: .94, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _pulseController.dispose();

    _rotateController.dispose();

    super.dispose();
  }

  // =========================================================
  // SMART SDE3 ENABLE BIOMETRIC
  // =========================================================
  Future<void> enableBiometric() async {
    // Prevent double taps while already processing
    if (isLoading) return;

    try {
      setState(() => isLoading = true);

      // 1. Hardware Check
      final bool isSupported = await auth.isDeviceSupported();
      final bool canCheckBiometrics = await auth.canCheckBiometrics;

      if (!isSupported || !canCheckBiometrics) {
        _showMessage(
          "Biometric authentication is not available on this device.",
        );
        setState(() => isLoading = false);
        return;
      }

      // 2. Enrollment Check (Did the user register a fingerprint in phone settings?)
      final availableBiometrics = await auth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        _showMessage(
          "No biometrics enrolled. Please set up in device settings first.",
        );
        setState(() => isLoading = false);
        return;
      }

      // 3. The Native OS Prompt
      final bool authenticated = await auth.authenticate(
        localizedReason:
            "Authenticate to enable biometrics for Expense Analyser",
        biometricOnly: true,
      );

      if (authenticated) {
        // SUCCESS: Update UI to show your Green Tick Animation
        setState(() {
          biometricEnabled = true;
          isLoading = false; // Stop loading spinner
        });

        _showMessage("Biometric Enabled Successfully");

        // 🚨 UX TRICK: Let the user enjoy the Green Tick for 1.5 seconds 🚨
        await Future.delayed(const Duration(milliseconds: 1500));

        // 🚨 SDE3 ARCHITECTURE: Tell BLoC to save the flag and go to Dashboard 🚨
        if (mounted) {
          context.read<AuthBloc>().add(const AuthEnableBiometricSetup());
        }
      } else {
        // User cancelled the prompt or fingerprint didn't match
        _showMessage("Authentication Cancelled or Failed");
        setState(() => isLoading = false);
      }
    } catch (e) {
      // Catch platform exceptions (e.g. user locked out of biometrics after 5 wrong tries)
      setState(() => isLoading = false);
      _showMessage("System error: Authentication temporarily locked.");
    }
  }

  // =========================================================
  // SNACKBAR
  // =========================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.backgroundSecondary,

        behavior: SnackBarBehavior.floating,

        content: Text(
          message,
          style: AppTextStyles.bodySmall(
            context,
          ).copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    final animationSize = Responsive.screenWidth * .58;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: locator<AuthBloc>(),
        listener: (context, state) {
          if (state is AuthError) {
            _showMessage(state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Stack(
            children: [
              // =================================================
              // BACKGROUND
              // =================================================
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.background,
                      AppColors.backgroundSecondary,
                      AppColors.background,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              // =================================================
              // GLOWS
              // =================================================
              Positioned(
                top: -140,
                left: -90,
                child: _buildGlow(color: AppColors.primary, size: 280),
              ),

              Positioned(
                bottom: -120,
                right: -70,
                child: _buildGlow(color: AppColors.blueGlow, size: 240),
              ),

              // =================================================
              // CONTENT
              // =================================================
              SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.lg,
                  ),

                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: Responsive.screenHeight - 40,
                    ),

                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // =====================================
                          // ANIMATION
                          // =====================================
                          AnimatedBuilder(
                            animation: Listenable.merge([
                              _pulseController,
                              _rotateController,
                            ]),

                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,

                                child: Stack(
                                  alignment: Alignment.center,

                                  children: [
                                    // ROTATING RING
                                    Transform.rotate(
                                      angle: _rotateController.value * 2 * pi,

                                      child: Container(
                                        width: animationSize,
                                        height: animationSize,

                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,

                                          border: Border.all(
                                            color: AppColors.primary
                                                .withOpacity(.12),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // SECOND RING
                                    Container(
                                      width: animationSize * .78,
                                      height: animationSize * .78,

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        border: Border.all(
                                          color: AppColors.primary.withOpacity(
                                            .18,
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                    ),

                                    // INNER GLOW
                                    Container(
                                      width: animationSize * .60,
                                      height: animationSize * .60,

                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                        gradient: RadialGradient(
                                          colors: [
                                            AppColors.primary.withOpacity(.22),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),

                                    // CENTER GLASS
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),

                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 15,
                                          sigmaY: 15,
                                        ),

                                        child: Container(
                                          width: 120,
                                          height: 120,

                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,

                                            color: AppColors.glass,

                                            border: Border.all(
                                              color: AppColors.border,
                                            ),
                                          ),

                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),

                                            child: Icon(
                                              biometricEnabled
                                                  ? Icons.verified_user_rounded
                                                  : Icons.fingerprint_rounded,

                                              key: ValueKey(biometricEnabled),

                                              color: AppColors.primary,

                                              size: 68,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          SizedBox(height: AppSpacing.xl),

                          // =====================================
                          // TITLE
                          // =====================================
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),

                            child: Text(
                              biometricEnabled
                                  ? "Biometric Enabled"
                                  : "Enable Biometrics",

                              key: ValueKey(biometricEnabled),

                              textAlign: TextAlign.center,

                              style: AppTextStyles.heading2(context),
                            ),
                          ),

                          SizedBox(height: AppSpacing.md),

                          // =====================================
                          // SUBTITLE
                          // =====================================
                          Text(
                            biometricEnabled
                                ? "Your account is now protected with biometric authentication."
                                : "Use Fingerprint or Face ID for faster and secure access.",

                            textAlign: TextAlign.center,

                            style: AppTextStyles.bodyMedium(context),
                          ),

                          SizedBox(height: AppSpacing.xl),

                          // =====================================
                          // FEATURES
                          // =====================================
                          _buildFeatureCard(
                            icon: Icons.flash_on_rounded,
                            title: "Quick Login",
                            subtitle: "Login instantly without passwords.",
                          ),

                          // SizedBox(height: AppSpacing.md),

                          // _buildFeatureCard(
                          //   icon: Icons.security_rounded,
                          //   title: "Secure Authentication",
                          //   subtitle: "Advanced biometric protection.",
                          // ),

                          // SizedBox(height: AppSpacing.md),

                          // _buildFeatureCard(
                          //   icon: Icons.phone_android_rounded,
                          //   title: "Trusted Device",
                          //   subtitle: "Authentication only on your device.",
                          // ),

                          // const Spacer(),
                          SizedBox(height: AppSpacing.xl),

                          // =====================================
                          // BUTTON
                          // =====================================
                          SizedBox(
                            width: double.infinity,
                            height: Responsive.h(60),
                            child: ElevatedButton(
                              // Disable button if loading or already enabled
                              onPressed: biometricEnabled || isLoading
                                  ? null
                                  : enableBiometric,
                              style: ElevatedButton.styleFrom(
                                // ... your styling
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: AppColors.buttonText,
                                      )
                                    : Text(
                                        biometricEnabled
                                            ? "Enabled Successfully"
                                            : "Enable Biometrics",
                                        style: AppTextStyles.button(context),
                                      ),
                              ),
                            ),
                          ),

                          SizedBox(height: AppSpacing.md),

                          // =====================================
                          // SETUP LATER
                          // =====================================
                          TextButton(
                            // 🚨 FIRE THE OPT-OUT EVENT 🚨
                            onPressed: isLoading
                                ? null
                                : () {
                                    locator<AuthBloc>().add(
                                      const AuthSkipBiometricSetup(),
                                    );
                                  },
                            child: Text(
                              "Setup Later",
                              style: AppTextStyles.bodySmall(context).copyWith(
                                color: isLoading
                                    ? Colors.grey
                                    : AppColors.primary,
                              ),
                            ),
                          ),
                          SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // =========================================================
  // FEATURE CARD
  // =========================================================

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),

      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),

        child: Container(
          padding: EdgeInsets.all(AppSpacing.lg),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),

            color: AppColors.glass,

            border: Border.all(color: AppColors.border),
          ),

          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.md),

                  color: AppColors.primary.withOpacity(.12),
                ),

                child: Icon(icon, color: AppColors.primary, size: 28),
              ),

              SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: AppTextStyles.bodyLarge(
                        context,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),

                    SizedBox(height: AppSpacing.xs),

                    Text(subtitle, style: AppTextStyles.bodySmall(context)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // GLOW
  // =========================================================

  Widget _buildGlow({required Color color, required double size}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),

      child: Container(
        width: size,
        height: size,

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(.18),
        ),
      ),
    );
  }
}
