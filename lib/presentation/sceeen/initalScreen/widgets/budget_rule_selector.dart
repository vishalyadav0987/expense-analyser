import 'package:expense_analyser/core/constants/app_colors.dart';
import 'package:expense_analyser/core/constants/app_text_styles.dart';
import 'package:expense_analyser/presentation/sceeen/dashboard/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class BudgetRuleSelector extends StatefulWidget {
  final Function(double needs, double wants, double savings) onChanged;
  const BudgetRuleSelector({super.key, required this.onChanged});

  @override
  State<BudgetRuleSelector> createState() => _BudgetRuleSelectorState();
}

class _BudgetRuleSelectorState extends State<BudgetRuleSelector> {
  bool isCustom = false;
  double needs = 50;
  double wants = 30;
  double savings = 20;

  void _notifyParent() {
    widget.onChanged(needs, wants, savings);
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isCustom
                  ? Row(
                      children: [
                        _chip("N ${needs.toInt()}%", AppColors.primary),
                        const SizedBox(width: 6),
                        _chip("W ${wants.toInt()}%", Colors.orangeAccent),
                        const SizedBox(width: 6),
                        _chip("S ${savings.toInt()}%", Colors.blueAccent),
                      ],
                    )
                  : Text(
                      "${needs.toInt()} / ${wants.toInt()} / ${savings.toInt()} Rule",
                      style: AppTextStyles.bodyMedium(
                        context,
                      ).copyWith(fontWeight: FontWeight.w600),
                    ),
              Switch.adaptive(
                value: isCustom,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    isCustom = val;
                    if (!isCustom) {
                      // Reset to default 50/30/20 if turned off
                      needs = 50;
                      wants = 30;
                      savings = 20;
                      _notifyParent();
                    }
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// PREVIEW BAR (ALWAYS VISIBLE)
          _buildRulePreview(),

          const SizedBox(height: 20),

          /// CUSTOM SLIDERS
          if (isCustom)
            Column(
              children: [
                _buildSlider(
                  "NEEDS",
                  needs,
                  AppColors.primary,
                  (v) => setState(() => needs = v),
                ),
                _buildSlider(
                  "WANTS",
                  wants,
                  Colors.orangeAccent,
                  (v) => setState(() => wants = v),
                ),
                _buildSlider(
                  "SAVINGS",
                  savings,
                  Colors.blueAccent,
                  (v) => setState(() => savings = v),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// =========================
  /// PREMIUM DISTRIBUTION BAR
  /// =========================
  Widget _buildRulePreview() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              Expanded(
                flex: needs.toInt(),
                child: Container(height: 10, color: AppColors.primary),
              ),
              Expanded(
                flex: wants.toInt(),
                child: Container(height: 10, color: Colors.orangeAccent),
              ),
              Expanded(
                flex: savings.toInt(),
                child: Container(height: 10, color: Colors.blueAccent),
              ),
            ],
          ),
        ),

        /// RIGHT FLOATING TOTAL INDICATOR
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border.withOpacity(0.2)),
          ),
          child: Text(
            "${(needs + wants + savings).toInt()}%",
            style: AppTextStyles.caption(context).copyWith(
              fontFamily: 'JetBrains Mono',
              color: (needs + wants + savings) == 100
                  ? AppColors.primary
                  : Colors.redAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  /// =========================
  /// CLEAN SLIDER (NO TEXT CLUTTER)
  /// =========================
  Widget _buildSlider(
    String label,
    double value,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.caption(
                context,
              ).copyWith(fontSize: 10, letterSpacing: 1.2),
            ),
            const Spacer(),

            /// RIGHT SIDE LIVE PERCENT (SUBTLE)
            Text(
              "${value.toInt()}%",
              style: TextStyle(
                fontFamily: 'JetBrains Mono',
                fontSize: 12,
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            activeTrackColor: color,
            inactiveTrackColor: color.withOpacity(0.15),
            thumbColor: color,
          ),
          child: Slider(
            value: value,
            max: 100,
            divisions: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
