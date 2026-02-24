import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// 设计语言 · 字体系统（H1–H6 / 正文 / 标签 / 价格）
/// 标题使用 Ma Shan Zheng 毛笔风格，正文保持可读性
/// 与 Theme 中 TextTheme 对齐，此处提供带语义的静态样式
class AppTextStyles {
  AppTextStyles._();

  /// Header font — Ma Shan Zheng: brush-style calligraphy, distinctive
  static TextStyle _headerFont({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double height = 1.25,
    double letterSpacing = 0.8,
    List<Shadow>? shadows,
  }) =>
      GoogleFonts.maShanZheng(
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        color: color,
        shadows: shadows,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // 标题层级 H1–H6 · Ma Shan Zheng 毛笔风格
  // ─────────────────────────────────────────────────────────────────────────
  /// H1 / Display - 34px，营销主标题、落地页首屏
  static TextStyle get display => _headerFont(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.2,
        letterSpacing: 1.2,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      );

  /// H2 - 26px，页面主标题、模块标题
  static TextStyle get headlineLarge => _headerFont(
        fontSize: 26,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.25,
        letterSpacing: 1.0,
      );

  /// H3 - 22px，区块标题、卡片主标题
  static TextStyle get headlineMedium => _headerFont(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.3,
        letterSpacing: 0.8,
      );

  /// H4 - 19px，列表项标题、弹窗标题
  static TextStyle get headlineSmall => _headerFont(
        fontSize: 19,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.35,
        letterSpacing: 0.6,
      );

  /// H5 - 17px，小节标题
  static TextStyle get titleMedium => _headerFont(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.4,
        letterSpacing: 0.5,
      );

  /// H6 - 16px，标签式标题、Tab
  static TextStyle get titleSmall => _headerFont(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.45,
        letterSpacing: 0.5,
      );

  /// Header style with custom color/size — for page titles, section headers
  static TextStyle header(Color color, {double? fontSize}) =>
      _headerFont(
        fontSize: fontSize ?? 22,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.25,
        letterSpacing: 0.8,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // 正文
  // ─────────────────────────────────────────────────────────────────────────
  /// Body Large - 16px Regular
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  /// Body Medium - 14px Regular，默认正文
  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.48,
        color: AppColors.textSecondary,
      );

  /// Body Small - 12px Regular，辅助说明
  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.42,
        color: AppColors.textTertiary,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // 标签与辅助
  // ─────────────────────────────────────────────────────────────────────────
  /// Caption - 12px Regular，图注、时间、来源
  static TextStyle get caption => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.38,
        letterSpacing: 0.2,
        color: AppColors.textTertiary,
      );

  /// Overline - 11px Medium，分类标签、角标
  static TextStyle get overline => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.36,
        letterSpacing: 0.3,
        color: AppColors.textTertiary,
      );

  /// Label - 14px Medium，表单项标签、按钮内文
  static TextStyle get label => GoogleFonts.zcoolKuaiLe(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.2,
        color: AppColors.textPrimary,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // 按钮 · 卡通风格
  // ─────────────────────────────────────────────────────────────────────────
  static TextStyle get button => GoogleFonts.zcoolKuaiLe(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonSecondary => GoogleFonts.zcoolKuaiLe(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.3,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // 价格 · 卡通风格
  // ─────────────────────────────────────────────────────────────────────────
  /// Price Large - 22px Bold，主价格、详情页
  static TextStyle get priceLarge => GoogleFonts.zcoolKuaiLe(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0.2,
        color: AppColors.price,
      );

  /// Price Medium - 17px Semi-bold，列表卡片价格
  static TextStyle get priceMedium => GoogleFonts.zcoolKuaiLe(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0.2,
        color: AppColors.price,
      );

  /// Price Small - 15px Medium，副价格、起价
  static TextStyle get priceSmall => GoogleFonts.zcoolKuaiLe(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.2,
        color: AppColors.price,
      );

  /// 兼容：price 指向 priceMedium
  static TextStyle get price => priceMedium;
}
