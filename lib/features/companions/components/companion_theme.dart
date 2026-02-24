import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';

/// Theme-driven colors for companion UI. Extend by adding more slots or overriding.
class CompanionThemeData {
  const CompanionThemeData({
    this.badgeTop1PercentGradient,
    this.badgeCityPreferredColor,
    this.badgeHighPopularityColor,
    this.badgeVerifiedColor,
    this.sectionBarColor,
    this.ctaGradientColors,
    this.ctaShadowColor,
  });

  final LinearGradient? badgeTop1PercentGradient;
  final Color? badgeCityPreferredColor;
  final Color? badgeHighPopularityColor;
  final Color? badgeVerifiedColor;
  final Color? sectionBarColor;
  final List<Color>? ctaGradientColors;
  final Color? ctaShadowColor;

  /// Emotional warm defaults: gold ranking, warm CTA, trust-friendly accents.
  static const CompanionThemeData defaultTheme = CompanionThemeData(
    badgeTop1PercentGradient: LinearGradient(
      colors: [Color(0xFFE8C547), Color(0xFFD4A017), Color(0xFFB8860B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    badgeCityPreferredColor: AppColors.accentCool,
    badgeHighPopularityColor: AppColors.accentWarm,
    badgeVerifiedColor: Color(0xFF1890FF),
    ctaGradientColors: [
      Color(0xFFFFB74D),
      Color(0xFFFF8F00),
      Color(0xFFE65100),
    ],
    ctaShadowColor: Color(0xFFE65100),
  );

  Color get sectionBarColorResolved => sectionBarColor ?? AppColors.primary;
  List<Color> get ctaGradientColorsResolved =>
      ctaGradientColors ?? defaultTheme.ctaGradientColors!;
  Color get ctaShadowColorResolved =>
      ctaShadowColor ?? defaultTheme.ctaShadowColor!;
}
