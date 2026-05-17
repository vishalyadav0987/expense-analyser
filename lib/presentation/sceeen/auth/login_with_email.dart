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
import 'package:expense_analyser/presentation/sceeen/auth/widgets/blob_wraper.dart';
import 'package:flutter/material.dart';
import 'package:expense_analyser/presentation/widgets/glassButton/glass_button.dart';
import 'package:expense_analyser/presentation/widgets/textFiled/custom_textfiled.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithEmail extends StatefulWidget {
  const LoginWithEmail({super.key});

  @override
  State<LoginWithEmail> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return BlobWrapper(
      child: BlocConsumer<AuthBloc, AuthState>(
        bloc: locator<AuthBloc>(),
        listener: (context, state) {
          // Listen for errors
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is AuthLoading;
          return SafeArea(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 250),

              curve: Curves.easeOut,

              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),

              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppSpacing.lg),

                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 48,
                  ),

                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(height: Responsive.h(30)),

                        /// TOP LABEL
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.full),

                            color: AppColors.white.withValues(alpha: .05),

                            border: Border.all(
                              color: AppColors.white.withValues(alpha: .08),
                            ),
                          ),

                          child: Text(
                            "EXPENSE ANALYSER",

                            style: AppTextStyles.caption(context).copyWith(
                              color: AppColors.primary,

                              letterSpacing: 2,

                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: Responsive.h(30)),

                        /// HEADING
                        Text(
                          "Track Your\nFinancial Life",

                          style: AppTextStyles.displayLarge(
                            context,
                          ).copyWith(fontWeight: FontWeight.w800, height: 1.0),
                        ),

                        SizedBox(height: AppSpacing.md),

                        Text(
                          "AI powered expense intelligence\nfor modern finance management.",

                          style: AppTextStyles.bodySmall(context).copyWith(
                            color: AppColors.white.withValues(alpha: .6),

                            height: 1.6,
                          ),
                        ),

                        SizedBox(height: Responsive.h(60)),

                        /// GLASS CARD
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.xl),

                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),

                            child: Container(
                              padding: EdgeInsets.all(AppSpacing.md),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  AppRadius.xl,
                                ),

                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,

                                  end: Alignment.bottomRight,

                                  colors: [
                                    AppColors.white.withValues(alpha: .12),

                                    AppColors.white.withValues(alpha: .04),
                                  ],
                                ),

                                border: Border.all(
                                  color: AppColors.white.withValues(alpha: .12),
                                ),

                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: .2),

                                    blurRadius: 40,

                                    spreadRadius: 4,
                                  ),
                                ],
                              ),

                              child: Column(
                                children: [
                                  /// EMAIL
                                  CustomTextField(
                                    controller: emailController,

                                    hintText: "Email Address",

                                    filled: true,

                                    fillColor: AppColors.white.withValues(
                                      alpha: 0.05,
                                    ),

                                    style: AppTextStyles.bodyMedium(
                                      context,
                                    ).copyWith(color: AppColors.white),

                                    hintStyle: AppTextStyles.bodyMedium(context)
                                        .copyWith(
                                          color: AppColors.white.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.lg,
                                      ),

                                      borderSide: BorderSide(
                                        color: AppColors.white.withValues(
                                          alpha: 0.08,
                                        ),
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.lg,
                                      ),

                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: AppSpacing.lg),

                                  /// PASSWORD
                                  CustomTextField(
                                    controller: passwordController,

                                    hintText: "Password",

                                    obscureText: true,

                                    filled: true,

                                    fillColor: AppColors.white.withValues(
                                      alpha: 0.05,
                                    ),

                                    style: AppTextStyles.bodyMedium(
                                      context,
                                    ).copyWith(color: AppColors.white),

                                    hintStyle: AppTextStyles.bodyMedium(context)
                                        .copyWith(
                                          color: AppColors.white.withValues(
                                            alpha: 0.4,
                                          ),
                                        ),

                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.lg,
                                      ),

                                      borderSide: BorderSide(
                                        color: AppColors.white.withValues(
                                          alpha: 0.08,
                                        ),
                                      ),
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.lg,
                                      ),

                                      borderSide: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: AppSpacing.xl),

                                  /// LOGIN BUTTON
                                  SizedBox(
                                    width: double.infinity,
                                    child: GlassButton(
                                      // Show Loading text if processing
                                      text: isLoading
                                          ? "Authenticating..."
                                          : "Authenticate",
                                      onPressed: isLoading
                                          ? () {} // Disable button when loading
                                          : () {
                                              // 🚨 FIRE THE EVENT 🚨
                                              locator<AuthBloc>().add(
                                                AuthRequestOtp(
                                                  email: emailController.text
                                                      .trim(),
                                                  password: passwordController
                                                      .text
                                                      .trim(),
                                                ),
                                              );
                                            },
                                    ),
                                  ),

                                  SizedBox(height: AppSpacing.lg),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: AppColors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppSpacing.md,
                                        ),

                                        child: Text(
                                          "OR",

                                          style: AppTextStyles.caption(context)
                                              .copyWith(
                                                color: AppColors.white
                                                    .withValues(alpha: 0.4),
                                              ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Divider(
                                          color: AppColors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: AppSpacing.lg),

                                  SizedBox(
                                    width: double.infinity,

                                    child: GlassButton(
                                      text: "Continue with Google",

                                      isPrimary: false,

                                      icon: const Icon(
                                        Icons.g_mobiledata,

                                        color: AppColors.white,

                                        size: 28,
                                      ),

                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
