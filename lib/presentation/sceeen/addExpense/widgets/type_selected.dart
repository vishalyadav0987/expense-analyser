import 'package:expense_analyser/presentation/sceeen/addExpense/widgets/category_selector.dart';
import 'package:flutter/material.dart';
import 'package:expense_analyser/core/constants/app_colors.dart';

class TypeSelected extends StatefulWidget {
  final List<String> modes;
  final Set<String> selected;
  final String bottomSheetHeading;
  final String title;
  final bool singleSelect;
  final bool showAddButton;

  const TypeSelected({
    super.key,
    required this.modes,
    required this.selected,
    required this.bottomSheetHeading,
    this.title = "Payment Modes",
    this.singleSelect = false,
    this.showAddButton = true,
  });

  @override
  State<TypeSelected> createState() => _TypeSelectedState();
}

class _TypeSelectedState extends State<TypeSelected> {
  void _addCustomMode(String value) {
    if (value.isEmpty || widget.modes.contains(value)) return;

    setState(() {
      final modifiableModes = List<String>.from(widget.modes);
      final modifiableSelected = Set<String>.from(widget.selected);

      modifiableModes.add(value);
      
      if (widget.singleSelect) {
        modifiableSelected.clear();
      }
      modifiableSelected.add(value);

      widget.modes.clear();
      widget.modes.addAll(modifiableModes);

      widget.selected.clear();
      widget.selected.addAll(modifiableSelected);
    });
  }

  void _openAddSheet() {
    if (!widget.showAddButton) return;
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.bottomSheetHeading,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "e.g. Wallet, Crypto",
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {
                    _addCustomMode(controller.text.trim());
                    Navigator.pop(context);
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CategorySelector(
      title: widget.title,
      items: widget.modes,
      selected: widget.selected,
      showAddButton: widget.showAddButton,
      onToggle: (value) {
        setState(() {
          final modifiableSelected = Set<String>.from(widget.selected);

          if (widget.singleSelect) {
            modifiableSelected.clear();
            modifiableSelected.add(value);
          } else {
            if (modifiableSelected.contains(value)) {
              modifiableSelected.remove(value);
            } else {
              modifiableSelected.add(value);
            }
          }

          widget.selected.clear();
          widget.selected.addAll(modifiableSelected);
        });
      },
      onAddTap: _openAddSheet,
    );
  }
}