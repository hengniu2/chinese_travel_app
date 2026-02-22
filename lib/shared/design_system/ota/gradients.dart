import 'package:flutter/material.dart';

import 'colors.dart';

/// OTA Design System — Reusable gradient styles
/// Primary button, selected tabs, premium overlays
class OtaGradients {
  OtaGradients._();

  /// Primary button: Orange → Main Yellow
  /// #FFA500 → #FFD60A
  static const List<Color> primaryButton = [
    OtaColors.accentOrange,
    OtaColors.primary,
  ];

  static const List<double> primaryButtonStops = [0.0, 1.0];

  static LinearGradient get primaryButtonGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: primaryButton,
        stops: primaryButtonStops,
      );

  /// Selected tabs: Main Yellow → Light Yellow
  /// #FFD60A → #FFF176
  static const Color selectedTabEnd = Color(0xFFF5FCE0);

  static const List<Color> selectedTab = [
    OtaColors.primary,
    selectedTabEnd,
  ];

  static const List<double> selectedTabStops = [0.0, 1.0];

  static LinearGradient get selectedTabGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: selectedTab,
        stops: selectedTabStops,
      );

  /// Premium background — very light yellow overlay
  /// Use as overlay or soft page background
  static LinearGradient premiumBackground(Color baseColor) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          OtaColors.primary.withValues(alpha: 0.05),
          baseColor,
        ],
        stops: const [0.0, 0.4],
      );

  /// Hero / header warm gradient (optional)
  static const List<Color> heroWarm = [
    OtaColors.accentOrange,
    OtaColors.primary,
    OtaColors.secondaryYellow,
  ];

  static LinearGradient get heroWarmGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: heroWarm,
        stops: [0.0, 0.5, 1.0],
      );
}
