import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isLoading; // 🚨 SDE3 Addition: Loading State Flag

  const CircularIconButton({
    super.key,
    required this.icon,
    this.backgroundColor = AppColors.glass,
    this.iconColor = AppColors.white,
    required this.onTap,
    this.isLoading = false, // Default is false so old buttons don't break
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 🚨 SDE3: Agar load ho raha hai, toh tap disable kar do (null)
      onTap: isLoading ? null : onTap,
      child: Container(
        height: AppSizes.iconXl * 0.7,
        width: AppSizes.iconXl * 0.7,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  // Loader ka size icon ke size se thoda chota rakha hai clean look ke liye
                  height: AppSizes.iconMd * 0.8,
                  width: AppSizes.iconMd * 0.8,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color:
                        iconColor, // Loader ka color icon ke color se match karega
                  ),
                )
              : Icon(icon, color: iconColor, size: AppSizes.iconMd),
        ),
      ),
    );
  }
}
