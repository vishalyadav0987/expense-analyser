import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/presentation/sceeen/auth/widgets/glow_effect.dart';
import 'package:flutter/material.dart';

class BlobWrapper extends StatelessWidget {
  final Widget child;

  const BlobWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Stack(
        children: [
          /// BACKGROUND GRADIENT
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

          /// GREEN GLOW
          Positioned(
            top: -120,
            left: -80,

            child: GlowWidget(color: AppColors.primary, size: 260),
          ),

          /// BLUE GLOW
          Positioned(
            bottom: -100,
            right: -50,

            child: GlowWidget(color: AppColors.blueGlow, size: 220),
          ),

          // =================================================
          // CONTENT
          // =================================================
          child,
        ],
      ),
    );
  }
}
