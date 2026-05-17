import 'dart:async';
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
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MpinScreen extends StatefulWidget {
  final bool isSetupMode;
  final String? email;
  final String? otpAccessToken;
  const MpinScreen({
    super.key,
    required this.isSetupMode,
    this.email,
    this.otpAccessToken,
  });

  @override
  State<MpinScreen> createState() => _MpinScreenState();
}

class _MpinScreenState extends State<MpinScreen> {
  static const int pinLength = 4;

  String _mpin = "";

  bool isLoading = false;

  void _onKeyTap(String value) {
    if (_mpin.length < pinLength) {
      HapticFeedback.lightImpact();
      setState(() => _mpin += value);
      if (_mpin.length == pinLength) {
        _verifyMpin();
      }
    }
  }

  void _onBackspace() {
    if (_mpin.isNotEmpty) {
      HapticFeedback.mediumImpact();

      setState(() => _mpin = _mpin.substring(0, _mpin.length - 1));
    }
  }

  Future<void> _verifyMpin() async {
    if (widget.isSetupMode) {
      // Fire Setup Event
      locator<AuthBloc>().add(
        AuthSetupMpin(mpin: _mpin, otpAccessToken: widget.otpAccessToken!),
      );
    } else {
      // Fire Login Event
      locator<AuthBloc>().add(AuthLoginMpin(email: widget.email!, mpin: _mpin));
    }
  }

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: locator<AuthBloc>(),
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            // Clear the pin so they can type again
            setState(() => _mpin = "");
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return Stack(
            children: [
              // Background Ambient Glows
              Positioned(
                top: -100,
                left: -50,

                child: _buildGlow(AppColors.primary, 300),
              ),

              Positioned(
                bottom: -50,
                right: -50,

                child: _buildGlow(AppColors.blueGlow, 250),
              ),

              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: Responsive.h(60)),

                    _buildHeader(),

                    const Spacer(),

                    _buildPinDisplay(),

                    const Spacer(),

                    _buildCustomKeypad(),
                  ],
                ),
              ),

              if (isLoading) _buildLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Security Icon with Glass Plate
        Container(
          padding: EdgeInsets.all(AppSpacing.lg),

          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.5),

            borderRadius: BorderRadius.circular(AppRadius.xl),

            border: Border.all(color: AppColors.border),
          ),

          child: const Icon(
            Icons.fingerprint,

            color: AppColors.primary,

            size: 40,
          ),
        ),

        SizedBox(height: AppSpacing.lg),

        Text(
          "SECURITY CHALLENGE",

          style: AppTextStyles.caption(context).copyWith(
            fontFamily: 'JetBrains Mono',

            letterSpacing: 2,

            color: AppColors.primary,
          ),
        ),

        SizedBox(height: AppSpacing.sm),

        Text(
          widget.isSetupMode ? "Setup your MPIN" : "Enter your MPIN",

          style: AppTextStyles.heading2(
            context,
          ).copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPinDisplay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: List.generate(pinLength, (index) {
        bool isFilled = _mpin.length > index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),

          width: Responsive.w(60),

          height: Responsive.h(70),

          margin: EdgeInsets.symmetric(horizontal: AppSpacing.sm),

          decoration: BoxDecoration(
            color: isFilled ? AppColors.cardBackground : Colors.transparent,

            borderRadius: BorderRadius.circular(AppRadius.lg),

            border: Border.all(
              color: isFilled ? AppColors.primary : AppColors.border,

              width: 1.5,
            ),

            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),

                      blurRadius: 10,
                    ),
                  ]
                : [],
          ),

          alignment: Alignment.center,

          child: Text(
            isFilled ? "•" : "",

            style: AppTextStyles.heading1(
              context,
            ).copyWith(color: AppColors.primary),
          ),
        );
      }),
    );
  }

  Widget _buildCustomKeypad() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),

        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.w(40),

            vertical: Responsive.h(30),
          ),

          decoration: BoxDecoration(
            color: AppColors.cardBackground.withOpacity(0.7),

            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),

            border: Border.all(color: AppColors.border.withOpacity(0.5)),
          ),

          child: GridView.count(
            shrinkWrap: true,

            crossAxisCount: 3,

            mainAxisSpacing: 20,

            crossAxisSpacing: 40,

            childAspectRatio: 1.2,

            physics: const NeverScrollableScrollPhysics(),

            children: [
              ...[
                "1",
                "2",
                "3",
                "4",
                "5",
                "6",
                "7",
                "8",
                "9",
              ].map((n) => _keyBtn(n)),

              _keyBtn("forget", isIcon: true, icon: Icons.help_outline),

              _keyBtn("0"),

              _keyBtn("back", isIcon: true, icon: Icons.backspace_outlined),
            ],
          ),
        ),
      ),
    );
  }

  Widget _keyBtn(String val, {bool isIcon = false, IconData? icon}) {
    return InkWell(
      onTap: () =>
          isIcon ? (val == "back" ? _onBackspace() : null) : _onKeyTap(val),

      borderRadius: BorderRadius.circular(AppRadius.lg),

      child: Container(
        alignment: Alignment.center,

        child: isIcon
            ? Icon(icon, color: AppColors.textMuted)
            : Text(
                val,

                style: AppTextStyles.heading3(
                  context,
                ).copyWith(fontWeight: FontWeight.w500),
              ),
      ),
    );
  }

  Widget _buildGlow(Color color, double size) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),

            blurRadius: 100,

            spreadRadius: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),

      child: Container(
        color: Colors.black.withValues(alpha: 0.5),

        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}
