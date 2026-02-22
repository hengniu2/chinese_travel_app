import 'package:flutter/material.dart';

/// OTA Design System — Radius system
/// Consistent roundness for cartoon-style, premium OTA look
class OtaRadius {
  OtaRadius._();

  /// Small — chips, tags, small buttons
  static const double small = 8;

  /// Medium — cards, inputs, list items
  static const double medium = 16;

  /// Large — modals, hero cards
  static const double large = 20;

  /// Extra large — bottom sheets, full-width cards
  static const double extraLarge = 24;

  /// Pill — pills, tabs, full-round buttons
  static const double pill = 999;

  // ─────────────────────────────────────────────────────────────────────────
  // BorderRadius getters
  // ─────────────────────────────────────────────────────────────────────────
  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(extraLarge);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);

  /// Bottom-only large (e.g. app bar under image)
  static BorderRadius get bottomLarge => BorderRadius.only(
        bottomLeft: Radius.circular(large),
        bottomRight: Radius.circular(large),
      );

  static BorderRadius get bottomExtraLarge => BorderRadius.only(
        bottomLeft: Radius.circular(extraLarge),
        bottomRight: Radius.circular(extraLarge),
      );
}
