import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_shadow.dart';

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
  // Radius — Chinese cartoon: card 26 / pill 22 / button 26 (use AppRadius)
  // ─────────────────────────────────────────────────────────────────────────
  static const double radiusSmall = 12;
  static const double radiusMedium = 20;
  static const double radiusLarge = 26;
  static const double radiusPill = 22;

  static BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
  static BorderRadius get borderRadiusMedium => BorderRadius.circular(radiusMedium);
  static BorderRadius get borderRadiusLarge => BorderRadius.circular(radiusLarge);
  static BorderRadius get borderRadiusPill => BorderRadius.circular(radiusPill);

  // ─────────────────────────────────────────────────────────────────────────
  // Spacing — section 20 / card 16 / page horizontal 16 (use AppSpacing)
  // ─────────────────────────────────────────────────────────────────────────
  /// Screen horizontal padding
  static const double screenHorizontal = 16;
  /// Card inner padding
  static const double cardPadding = 16;
  /// Between sections
  static const double sectionGap = 20;

  static EdgeInsets get paddingScreen => const EdgeInsets.symmetric(horizontal: 16);
  static EdgeInsets get paddingCard => const EdgeInsets.all(16);
  static EdgeInsets get paddingSection => const EdgeInsets.symmetric(vertical: 20);

  // ─────────────────────────────────────────────────────────────────────────
  // Shadow — soft only, tinted, blur 20–30, Y 8–12 (delegate to AppShadow)
  // ─────────────────────────────────────────────────────────────────────────
  /// Level 1 — soft (cards, list items)
  static List<BoxShadow> get shadowLevel1 => AppShadow.light;
  /// Level 2 — medium soft (elevated cards, buttons)
  static List<BoxShadow> get shadowLevel2 => AppShadow.medium;

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
