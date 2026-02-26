import 'package:flutter/material.dart';

/// Profile screen typography and icon colors for clear hierarchy and readability.
class ProfileTheme {
  ProfileTheme._();

  /// Section titles (e.g. 我的订单, 我的工具) — rich slate, strong contrast
  static const Color sectionTitle = Color(0xFF1E293B);

  /// Labels under icons and list item text — warm gray, readable
  static const Color label = Color(0xFF475569);

  /// Secondary / hint text on profile cards
  static const Color labelSecondary = Color(0xFF64748B);
}
