import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_radius.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final String title;
  final List<String> items;
  final Set<String> selected;
  final Function(String) onToggle;
  final VoidCallback onAddTap;

  const CategorySelector({
    super.key,
    required this.title,
    required this.items,
    required this.selected,
    required this.onToggle,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading3(
            context,
          ).copyWith(fontSize: 18, letterSpacing: 1.2),
        ),
        SizedBox(height: AppSpacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _AddChip(onTap: onAddTap),
              SizedBox(width: AppSpacing.md),
              // Map items to the new UI chips
              ...items.map((item) {
                final isSelected = selected.contains(item);
                return Padding(
                  padding: EdgeInsets.only(right: AppSpacing.md),
                  child: _TagChip(
                    label: item,
                    isSelected: isSelected,
                    onTap: () => onToggle(item),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TagChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12, // Slightly taller for better touch target
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.white.withOpacity(
                    0.08,
                  ), // Softer border for unselected
            width: 1.5,
          ),
          // Adding a subtle neon glow when selected
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Optional: Dynamic Icon logic could be added here
            Text(
              label,
              style: AppTextStyles.button(context).copyWith(
                color: isSelected ? AppColors.buttonText : AppColors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddChip extends StatelessWidget {
  final VoidCallback onTap;

  const _AddChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 18, color: AppColors.primary),
            SizedBox(width: AppSpacing.sm),
            Text(
              "Add",
              style: AppTextStyles.button(
                context,
              ).copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
