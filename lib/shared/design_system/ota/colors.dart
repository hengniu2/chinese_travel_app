import 'package:flutter/material.dart';

/// OTA Design System — Color system
/// Direction: Cartoon-style, Youthful, Premium, Yellow-focused, OTA-level commercial
class OtaColors {
  OtaColors._();

  // ─────────────────────────────────────────────────────────────────────────
  // PRIMARY BRAND — RGB(203, 235, 34) #CBEB22，与主应用一致
  // ─────────────────────────────────────────────────────────────────────────
  /// Main primary — RGB(203, 235, 34)
  static const Color primary = Color(0xFFCBEB22);

  /// Secondary — lighter accent
  static const Color secondaryYellow = Color(0xFFD4EE4D);

  /// Tertiary — lightest accent / backgrounds
  static const Color tertiaryYellow = Color(0xFFF5FCE0);

  // ─────────────────────────────────────────────────────────────────────────
  // ACCENT COLORS
  // ─────────────────────────────────────────────────────────────────────────
  /// Green — rating, refundable, success
  static const Color accentGreen = Color(0xFF2ECC71);

  /// Red — price, urgency, CTA
  static const Color accentRed = Color(0xFFFF4D4F);

  /// Orange — gradient start (primary button)
  static const Color accentOrange = Color(0xFFFFA500);

  // ─────────────────────────────────────────────────────────────────────────
  // NEUTRALS
  // ─────────────────────────────────────────────────────────────────────────
  static const Color neutral900 = Color(0xFF111111);
  static const Color neutral800 = Color(0xFF333333);
  static const Color neutral600 = Color(0xFF666666);
  static const Color neutral500 = Color(0xFF999999);
  static const Color neutral100 = Color(0xFFF7F8FA);
  static const Color neutral0 = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC ALIASES (for Theme / components)
  // ─────────────────────────────────────────────────────────────────────────
  /// Primary text / titles
  static const Color textPrimary = neutral900;

  /// Secondary text / body
  static const Color textSecondary = neutral800;

  /// Tertiary / captions / hints
  static const Color textTertiary = neutral600;

  /// Quaternary / disabled
  static const Color textQuaternary = neutral500;

  /// Page background
  static const Color background = neutral100;

  /// Card / surface
  static const Color surface = neutral0;

  /// Border / divider
  static const Color border = Color(0xFFEEEEEE);

  /// Premium background overlay (very light yellow)
  static Color get premiumOverlay => primary.withValues(alpha: 0.05);
}
