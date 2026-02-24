import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Travel typography hierarchy — 中国卡通商业风.
/// Title/Section: Ma Shan Zheng 毛笔风格 | Content: Noto Sans SC
class TravelTypography {
  TravelTypography._();

  /// Title — Ma Shan Zheng 毛笔风格
  static TextStyle title(
    Color color, {
    double? fontSize,
  }) =>
      GoogleFonts.maShanZheng(
        fontSize: fontSize ?? 28,
        fontWeight: FontWeight.w400,
        height: 1.2,
        letterSpacing: 1.0,
        color: color,
      );

  /// Section title — Ma Shan Zheng 毛笔风格
  static TextStyle sectionTitle(
    Color color, {
    double? fontSize,
  }) =>
      GoogleFonts.maShanZheng(
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.w400,
        height: 1.3,
        letterSpacing: 0.8,
        color: color,
      );

  /// Content — Medium
  static TextStyle content(
    Color color, {
    double? fontSize,
  }) =>
      GoogleFonts.notoSansSc(
        fontSize: fontSize ?? 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: color,
      );

  /// Hint / secondary — Regular
  static TextStyle hint(Color color, {double? fontSize}) =>
      GoogleFonts.notoSansSc(
        fontSize: fontSize ?? 13,
        fontWeight: FontWeight.w400,
        height: 1.42,
        color: color,
      );

  /// Label (form labels, chips) — ZCOOL KuaiLe 卡通风格
  static TextStyle label(Color color, {double? fontSize}) =>
      GoogleFonts.zcoolKuaiLe(
        fontSize: fontSize ?? 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.2,
        color: color,
      );

  /// Button text — ZCOOL KuaiLe 卡通风格
  static TextStyle button(Color color, {double? fontSize}) =>
      GoogleFonts.zcoolKuaiLe(
        fontSize: fontSize ?? 16,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: 0.3,
        color: color,
      );
}
