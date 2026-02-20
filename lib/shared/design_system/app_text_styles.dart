import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 设计语言 · 字体系统（H1–H6 / 正文 / 标签 / 价格）
/// 与 Theme 中 TextTheme 对齐，此处提供带语义的静态样式
class AppTextStyles {
  AppTextStyles._();

  // ─────────────────────────────────────────────────────────────────────────
  // 标题层级 H1–H6
  // ─────────────────────────────────────────────────────────────────────────
  /// H1 / Display - 28px Bold，营销主标题、落地页首屏
  static TextStyle get display => const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  /// H2 - 22px Bold，页面主标题、模块标题
  static TextStyle get headlineLarge => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  /// H3 - 18px Semi-bold，区块标题、卡片主标题
  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  /// H4 - 16px Semi-bold，列表项标题、弹窗标题
  static TextStyle get headlineSmall => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  /// H5 - 15px Medium，小节标题
  static TextStyle get titleMedium => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0,
        color: AppColors.textPrimary,
      );

  /// H6 - 14px Medium，标签式标题、Tab
  static TextStyle get titleSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        letterSpacing: 0,
        color: AppColors.textPrimary,
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
  static TextStyle get label => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textPrimary,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // 按钮
  // ─────────────────────────────────────────────────────────────────────────
  static TextStyle get button => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.5,
      );

  static TextStyle get buttonSecondary => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.3,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // 价格
  // ─────────────────────────────────────────────────────────────────────────
  /// Price Large - 20px Bold，主价格、详情页
  static TextStyle get priceLarge => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: AppColors.price,
      );

  /// Price Medium - 16px Semi-bold，列表卡片价格
  static TextStyle get priceMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.price,
      );

  /// Price Small - 14px Medium，副价格、起价
  static TextStyle get priceSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: AppColors.price,
      );

  /// 兼容：price 指向 priceMedium
  static TextStyle get price => priceMedium;
}
