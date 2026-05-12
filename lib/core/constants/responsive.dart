import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static late MediaQueryData _mediaQuery;

  static late double screenWidth;

  static late double screenHeight;

  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQuery = MediaQuery.of(context);

    screenWidth = _mediaQuery.size.width;

    screenHeight = _mediaQuery.size.height;

    textScaleFactor = _mediaQuery.textScaleFactor;
  }

  /// BASE WIDTH = iPhone 13 width
  static const double baseWidth = 390;

  /// RESPONSIVE WIDTH
  static double w(double width) {
    return (screenWidth / baseWidth) * width;
  }

  /// RESPONSIVE HEIGHT
  static double h(double height) {
    return (screenHeight / 844) * height;
  }

  /// RESPONSIVE FONT
  static double sp(double size) {
    double value = (screenWidth / baseWidth) * size;

    return value.clamp(size * 0.85, size * 1.20);
  }

  static bool get isSmallPhone => screenWidth < 360;

  static bool get isMediumPhone => screenWidth >= 360 && screenWidth < 400;

  static bool get isLargePhone => screenWidth >= 400;
}
