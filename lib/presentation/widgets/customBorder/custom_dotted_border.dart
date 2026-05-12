import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

enum BorderTypeEnum { all, bottom }

class CustomDottedBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final List<double> dashPattern;
  final BorderTypeEnum borderType;
  final double radius;
  final EdgeInsets padding;

  const CustomDottedBorder({
    super.key,
    required this.child,
    this.color = Colors.black,
    this.strokeWidth = 1,
    this.dashPattern = const [6, 3],
    this.borderType = BorderTypeEnum.all,
    this.radius = 0,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    if (borderType == BorderTypeEnum.bottom) {
      return DottedBorder(
        options: CustomPathDottedBorderOptions(
          color: color,
          strokeWidth: strokeWidth,
          dashPattern: dashPattern,
          padding: padding,
          customPath: (size) {
            return Path()
              ..moveTo(0, size.height)
              ..lineTo(size.width, size.height);
          },
        ),

        child: child,
      );
    } else {
      return DottedBorder(
        options: RoundedRectDottedBorderOptions(
          color: color,
          strokeWidth: strokeWidth,
          dashPattern: dashPattern,
          radius: Radius.circular(radius),
          padding: padding,
        ),
        child: child,
      );
    }
  }
}
