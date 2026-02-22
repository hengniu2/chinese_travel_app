import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Travel Planner design system tokens.
/// Use for consistent styling: modern travel green, soft shadows, clear hierarchy.
class TravelDesignTokens {
  TravelDesignTokens._();

  // ─────────────────────────────────────────────────────────────────────────
  // Brand identity (aligned with AppColors.primary)
  // ─────────────────────────────────────────────────────────────────────────
  /// Brand green — primary buttons, links, key icons (consistent with AppColors)
  static Color get primary => AppColors.primary;
  /// Soft accent (pale)
  static Color get accentLimeStart => AppColors.primaryDark;
  static Color get accentLimeEnd => AppColors.primaryPale;
  /// Page background — light gray
  static const Color background = Color(0xFFF8FAF9);
  /// Card surface — white
  static const Color card = Color(0xFFFFFFFF);

  /// Brand gradient (for accents)
  static List<Color> get accentLimeGradient => [AppColors.primaryDark, AppColors.primary];

  // ─────────────────────────────────────────────────────────────────────────
  // Radius system — max 12–16dp: Small 8 / Medium 12 / Large 12
  // ─────────────────────────────────────────────────────────────────────────
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 12;

  static BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(radiusLarge);

  // ─────────────────────────────────────────────────────────────────────────
  // Standard padding
  // ─────────────────────────────────────────────────────────────────────────
  /// Screen horizontal padding
  static const double screenHorizontal = 16;
  /// Card inner padding
  static const double cardPadding = 16;
  /// Between sections
  static const double sectionGap = 24;

  static EdgeInsets get paddingScreen => const EdgeInsets.symmetric(horizontal: 16);
  static EdgeInsets get paddingCard => const EdgeInsets.all(16);
  static EdgeInsets get paddingSection => const EdgeInsets.symmetric(vertical: 24);

  // ─────────────────────────────────────────────────────────────────────────
  // Shadow — Level 1 soft, Level 2 medium. Avoid heavy.
  // ─────────────────────────────────────────────────────────────────────────
  /// Level 1 — soft subtle (cards, list items)
  static List<BoxShadow> get shadowLevel1 => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  /// Level 2 — medium, light (elevated cards, buttons; no heavy shadow)
  static List<BoxShadow> get shadowLevel2 => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: -1,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // Typography — clear hierarchy
  // ─────────────────────────────────────────────────────────────────────────
  /// Title XL — 22–24sp bold
  static TextStyle titleXL(Color? color) => TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: color ?? AppColors.textPrimary,
      );

  /// Title L — 18–20sp semi-bold
  static TextStyle titleL(Color? color) => TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color ?? AppColors.textPrimary,
      );

  /// Body — 14–16sp regular
  static TextStyle body(Color? color) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: color ?? AppColors.textSecondary,
      );

  /// Caption — 12–13sp
  static TextStyle caption(Color? color) => TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        height: 1.38,
        color: color ?? AppColors.textTertiary,
      );
}
