import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class UniversalHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? username;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final bool showNotificationBadge;

  const UniversalHeader({
    super.key,
    this.username,
    this.onProfileTap,
    this.onNotificationTap,
    this.showNotificationBadge = true,
  });

  String get _initial => (username?.isNotEmpty ?? false)
      ? username!.trim().substring(0, 1).toUpperCase()
      : "V";

  static const double _baseHeight = 60;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: _baseHeight + topPadding - 16,

          padding: EdgeInsets.only(top: 36, left: 20, right: 20),

          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.75),
            border: Border(
              bottom: BorderSide(color: AppColors.border.withOpacity(0.08)),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // PROFILE (INITIAL ONLY)
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(.9),
                        AppColors.primary.withOpacity(.2),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initial,
                    style: AppTextStyles.bodyLarge(context).copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

              // NOTIFICATION ONLY
              Row(
                children: [
                  GestureDetector(
                    onTap: onNotificationTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.04),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: onNotificationTap,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.04),
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                      ),

                      if (showNotificationBadge)
                        Positioned(
                          top: 7,
                          right: 7,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_baseHeight);
}
