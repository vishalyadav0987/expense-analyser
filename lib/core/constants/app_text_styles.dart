import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'responsive.dart';

class AppTextStyles {
  AppTextStyles._();

  // ==============================
  // CORE TEXT FACTORY
  // ==============================
  static TextStyle _base({
    required double size,
    required FontWeight weight,
    required Color color,
    double height = 1.4,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: Responsive.sp(size),
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ==============================
  // DISPLAY
  // ==============================
  static TextStyle displayLarge(BuildContext context) => _base(
        size: 40,
        weight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.2,
      );

  // ==============================
  // HEADINGS
  // ==============================
  static TextStyle heading1(BuildContext context) => _base(
        size: 34,
        weight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle heading2(BuildContext context) => _base(
        size: 28,
        weight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle heading3(BuildContext context) => _base(
        size: 22,
        weight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // ==============================
  // BODY
  // ==============================
  static TextStyle bodyLarge(BuildContext context) => _base(
        size: 18,
        weight: FontWeight.w500,
        color: AppColors.textPrimary,
        height: 1.6,
      );

  static TextStyle bodyMedium(BuildContext context) => _base(
        size: 16,
        weight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle bodySmall(BuildContext context) => _base(
        size: 14,
        weight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );

  // ==============================
  // BUTTON
  // ==============================
  static TextStyle button(BuildContext context) => _base(
        size: 16,
        weight: FontWeight.w700,
        color: AppColors.buttonText,
        letterSpacing: 0.3,
      );

  // ==============================
  // CAPTION / LABEL
  // ==============================
  static TextStyle caption(BuildContext context) => _base(
        size: 12,
        weight: FontWeight.w500,
        color: AppColors.hint,
      );

  // ==============================
  // SPECIAL USE CASES
  // ==============================
  static TextStyle otpDigit(BuildContext context) => _base(
        size: 24,
        weight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle mutedLabel(BuildContext context) => _base(
        size: 14,
        weight: FontWeight.w500,
        color: AppColors.textMuted,
        letterSpacing: 0.2,
      );
}