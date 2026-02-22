import 'package:flutter/material.dart';

import 'colors.dart';

/// OTA Design System — Typography
/// Chinese-font optimized: Bold titles, Medium card headings, Regular body, Light secondary
/// Hierarchy: H1 22–24, H2 18–20, Body 14–16, Caption 12–13
class OtaTypography {
  OtaTypography._();

  // ─────────────────────────────────────────────────────────────────────────
  // HEADINGS
  // ─────────────────────────────────────────────────────────────────────────
  /// H1 — 22–24sp Bold (page titles)
  static TextStyle h1([Color? color]) => TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0,
        color: color ?? OtaColors.textPrimary,
      );

  /// H2 — 18–20sp Bold/Medium (card headings, section titles)
  static TextStyle h2([Color? color]) => TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: 0,
        color: color ?? OtaColors.textPrimary,
      );

  /// H3 — 16–17sp Medium (list item titles)
  static TextStyle h3([Color? color]) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0,
        color: color ?? OtaColors.textPrimary,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // BODY
  // ─────────────────────────────────────────────────────────────────────────
  /// Body — 14–16sp Regular
  static TextStyle body([Color? color]) => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0,
        color: color ?? OtaColors.textSecondary,
      );

  /// Body small — 13–14sp Regular
  static TextStyle bodySmall([Color? color]) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0,
        color: color ?? OtaColors.textSecondary,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // CAPTION & LABELS
  // ─────────────────────────────────────────────────────────────────────────
  /// Caption — 12–13sp (secondary text, hints)
  static TextStyle caption([Color? color]) => TextStyle(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0,
        color: color ?? OtaColors.textTertiary,
      );

  /// Label — 12–14sp Medium (buttons, tags)
  static TextStyle label([Color? color]) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0,
        color: color ?? OtaColors.textPrimary,
      );

  /// Overline — 11sp (category, meta)
  static TextStyle overline([Color? color]) => TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.36,
        letterSpacing: 0.3,
        color: color ?? OtaColors.textTertiary,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // PRICE & CTA
  // ─────────────────────────────────────────────────────────────────────────
  /// Price large — for prominent price
  static TextStyle priceLarge([Color? color]) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0,
        color: color ?? OtaColors.accentRed,
      );

  /// Price medium
  static TextStyle priceMedium([Color? color]) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0,
        color: color ?? OtaColors.accentRed,
      );

  /// Button text
  static TextStyle button([Color? color]) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.5,
        color: color ?? OtaColors.neutral0,
      );
}
