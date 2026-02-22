import 'package:flutter/material.dart';

/// OTA Design System — Shadow system
/// Three levels for clear elevation hierarchy
class OtaShadows {
  OtaShadows._();

  /// Level 1 — cards, list items, inputs
  /// 0 4 12 rgba(0,0,0,0.06)
  static List<BoxShadow> get level1 => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.06),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];

  /// Level 2 — elevated cards, dropdowns
  /// 0 8 24 rgba(0,0,0,0.08)
  static List<BoxShadow> get level2 => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.08),
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ];

  /// Level 3 — floating elements (FAB, modals, sticky bars)
  /// 0 12 32 rgba(0,0,0,0.12)
  static List<BoxShadow> get level3 => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.12),
          offset: const Offset(0, 12),
          blurRadius: 32,
          spreadRadius: 0,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC ALIASES
  // ─────────────────────────────────────────────────────────────────────────
  static List<BoxShadow> get card => level1;
  static List<BoxShadow> get elevated => level2;
  static List<BoxShadow> get floating => level3;
}
