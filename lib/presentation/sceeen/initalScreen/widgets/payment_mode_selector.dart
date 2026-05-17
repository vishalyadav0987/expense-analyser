import 'package:expense_analyser/presentation/sceeen/initalScreen/widgets/tag_manager.dart';
import 'package:flutter/material.dart';
import 'package:expense_analyser/core/constants/app_colors.dart';

class PaymentModeSelector extends StatefulWidget {
  final List<String> modes;
  final Set<String> selected;
  final String bottomSheetHeading;
  final String title;
  final bool
  showTypeTags; // Flag to determine if Need/Want/Saving chips are shown

  const PaymentModeSelector({
    super.key,
    required this.modes,
    required this.selected,
    required this.bottomSheetHeading,
    this.title = "Payment Modes",
    this.showTypeTags = false,
  });

  @override
  State<PaymentModeSelector> createState() => _PaymentModeSelectorState();
}

class _PaymentModeSelectorState extends State<PaymentModeSelector> {
  void _addCustomMode(String value, String? tag) {
    if (value.isEmpty) return;

    // Optional: Append the tag visually to the mode name or handle via your actual data models
    String finalValue = (tag != null && widget.showTypeTags)
        ? "$value ($tag)"
        : value;

    if (widget.modes.contains(finalValue)) return;

    setState(() {
      final modifiableModes = List<String>.from(widget.modes);
      final modifiableSelected = Set<String>.from(widget.selected);

      modifiableModes.add(finalValue);
      modifiableSelected.add(finalValue); // Select by default when added

      widget.modes.clear();
      widget.modes.addAll(modifiableModes);

      widget.selected.clear();
      widget.selected.addAll(modifiableSelected);
    });
  }

  void _openAddSheet() {
    final controller = TextEditingController();
    String activeTag = "Need";
    final List<String> availableTags = ["Need", "Want", "Saving"];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // StatefulBuilder allows us to update the UI inside the bottom sheet
        // dynamically (like selecting different tags)
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
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

                  Center(
                    child: Text(
                      widget.bottomSheetHeading,
                      style: const TextStyle(
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
                      hintText: widget.showTypeTags
                          ? "e.g. Groceries, Rent"
                          : "e.g. Wallet, Crypto",
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Tag Selector for Category Selection
                  if (widget.showTypeTags) ...[
                    const SizedBox(height: 16),
                    Text(
                      "Select Tag Type",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: availableTags.map((tag) {
                        final isSelected = activeTag == tag;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setModalState(() {
                                activeTag = tag;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.2)
                                    : AppColors.background,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
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
                  ],

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
                      _addCustomMode(
                        controller.text.trim(),
                        widget.showTypeTags ? activeTag : null,
                      );
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TagManagerSelectable(
      title: widget.title,
      items: widget.modes,
      selected: widget.selected,
      onToggle: (value) {
        setState(() {
          final modifiableSelected = Set<String>.from(widget.selected);

          if (modifiableSelected.contains(value)) {
            modifiableSelected.remove(value);
          } else {
            modifiableSelected.add(value);
          }

          widget.selected.clear();
          widget.selected.addAll(modifiableSelected);
        });
      },
      onAddTap: _openAddSheet,
    );
  }
}
