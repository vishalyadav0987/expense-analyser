import 'package:flutter/material.dart';

class GlowWidget extends StatelessWidget {
  final Color color;
  final double size;

  const GlowWidget({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: RadialGradient(
          colors: [color.withValues(alpha: .45), color.withValues(alpha: .0)],
        ),
      ),
    );
  }
}
