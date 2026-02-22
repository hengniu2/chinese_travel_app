import 'package:flutter/material.dart';

/// Hotel feature UI constants — 8px grid, premium radii, animation curves.
/// Use with Theme.of(context) for dark mode–aware colors.
class HotelUIConstants {
  HotelUIConstants._();

  // 8px grid
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

  /// Minimum touch target for accessibility (44pt)
  static const double minTouchTarget = 44;

  // Responsive breakpoints (logical pixels)
  /// Below this width: phone (1 column list).
  static const double tabletBreakpoint = 600;
  /// Above this width: tablet (2-column grid list, larger detail banner).
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  static bool isPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < tabletBreakpoint;
}
