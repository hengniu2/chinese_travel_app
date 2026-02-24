import 'package:flutter/material.dart';

/// Luxury micro-interaction system: 60fps, no bounce, no flash.
///
/// Rules:
/// - All button presses: 0.96 scale
/// - Page transitions: slow fade + slide, 250ms
/// - Cards: lift 4px on tap
/// - Bottom sheet: soft fade background + smooth rise
/// - Curve: [luxuryCurve] (easeInOutCubic)
class LuxuryInteractions {
  LuxuryInteractions._();

  /// Standard curve: smooth, no aggressive bounce.
  static const Curve luxuryCurve = Curves.easeInOutCubic;

  /// ~15 frames @ 60fps. Used for page transitions, bottom sheet, button/card animations.
  static const Duration duration = Duration(milliseconds: 250);

  /// Slightly shorter reverse for snappy feel (e.g. page pop).
  static const Duration durationReverse = Duration(milliseconds: 220);

  /// Button press scale (all buttons).
  static const double buttonPressedScale = 0.96;

  /// Card lift on tap (pixels up).
  static const double cardLiftPx = 4.0;

  /// Bottom sheet barrier opacity (soft fade).
  static const double bottomSheetBarrierOpacity = 0.35;
}
