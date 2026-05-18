import 'package:expense_analyser/application/expense/expense_bloc.dart';
import 'package:expense_analyser/application/expense/expense_event.dart';
import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_spacing.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/core/locator/setup_locator.dart';
import 'package:expense_analyser/domain/models/request/create_category_request.dart';
import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/category_selector.dart';
import 'package:flutter/material.dart';

class CategorizedTypeSelector extends StatefulWidget {
  final Map<String, List<String>> categories;
  final Set<String> selected;
  final String title;

  const CategorizedTypeSelector({
    super.key,
    required this.categories,
    required this.selected,
    this.title = "Category",
  });

  @override
  State<CategorizedTypeSelector> createState() =>
      _CategorizedTypeSelectorState();
}

class _CategorizedTypeSelectorState extends State<CategorizedTypeSelector> {
  String _activeTab = "Need";

  void _addCustomCategory(String value, String tag) {
    if (value.isEmpty) return;

    setState(() {
      // 1. 🚨 OPTIMISTIC UI UPDATE: Ensure the list exists, add the value locally
      final list = List<String>.from(widget.categories[tag] ?? []);
      if (!list.contains(value)) {
        list.add(value);
        widget.categories[tag] = list;
      }

      // 2. 🚨 AUTO-SELECT: Select the newly created category instantly
      widget.selected.clear();
      widget.selected.add(value);
      _activeTab = tag; // Switch tab to show the new item
    });

    // 3. 🚨 BACKGROUND SYNC: Fire Event to BLoC to save in Backend & SQLite
    locator<ExpenseBloc>().add(
      SubmitCreateCategoryEvent(
        requestPayload: CreateCategoryRequest(name: value, type: tag),
      ),
    );
  }

  void _openAddSheet() {
    final controller = TextEditingController();
    String sheetActiveTag = _activeTab; // Default to currently viewed tab
    final List<String> availableTags = ["Need", "Want", "Saving"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Center(
                      child: Text(
                        "Create Custom Category",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "e.g. Groceries, Netflix...",
                        hintStyle: TextStyle(color: AppColors.textSecondary),
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Text(
                      "Select Type",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Need / Want / Saving Selection Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: availableTags.map((tag) {
                        final isSelected = sheetActiveTag == tag;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                sheetActiveTag = tag;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.2)
                                    : AppColors.background,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.blueGlow,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                tag,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _addCustomCategory(
                          controller.text.trim(),
                          sheetActiveTag,
                        );
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Create",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final subCategories = widget.categories[_activeTab] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Text(
            widget.title,
            style: AppTextStyles.heading3(
              context,
            ).copyWith(fontSize: 18, letterSpacing: 1.2),
          ),
          SizedBox(height: AppSpacing.md),
        ],

        // TOP ROW: Type Tabs (Need, Want, Saving)
        Row(
          children: widget.categories.keys.map((tabKey) {
            final isActive = _activeTab == tabKey;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _activeTab = tabKey),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.glass : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabKey,
                    style: TextStyle(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        SizedBox(height: AppSpacing.md),

        // BOTTOM ROW: Sub-categories
        CategorySelector(
          title: "", // Hide inner title
          items: subCategories,
          selected: widget.selected,
          showAddButton: true,
          onToggle: (value) {
            setState(() {
              // Usually categories are single select per expense
              widget.selected.clear();
              widget.selected.add(value);
            });
          },
          onAddTap: _openAddSheet,
        ),
      ],
    );
  }
}
