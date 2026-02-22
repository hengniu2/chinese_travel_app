import 'package:flutter/material.dart';

/// Hotel feature UI constants — 8px grid, radii, animation.
/// Use with Theme.of(context) for dark-mode–aware colors.
class HotelTheme {
  HotelTheme._();

  static const double grid1 = 8;
  static const double grid2 = 16;
  static const double grid3 = 24;
  static const double grid4 = 32;
  static const double grid5 = 40;
  static const double grid6 = 48;

  static const double cardRadius = 20;
  static const double imageRadius = 16;
  static const double chipRadius = 8;
  static const double buttonRadius = 12;
  static const double overlayButtonRadius = 24;

  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationStagger = Duration(milliseconds: 50);
  static const Curve animationCurve = Curves.easeOutCubic;

  static const double minTouchTarget = 44;
}
