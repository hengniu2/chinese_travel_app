import 'package:flutter/material.dart';

/// 统一文字样式（中文排版优化）
class AppTextStyles {
  AppTextStyles._();

  /// 大标题 - 页面主标题
  static TextStyle get headlineLarge => const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: 0.5,
        color: Color(0xFF1A1A1A),
      );

  /// 标题 - 区块标题
  static TextStyle get headlineMedium => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: Color(0xFF1A1A1A),
      );

  /// 小标题
  static TextStyle get headlineSmall => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: Color(0xFF1A1A1A),
      );

  /// 正文大
  static TextStyle get bodyLarge => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: Color(0xFF333333),
      );

  /// 正文
  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: Color(0xFF666666),
      );

  /// 正文小
  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.45,
        color: Color(0xFF999999),
      );

  /// 标签 / 辅助
  static TextStyle get label => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: Color(0xFF999999),
      );

  /// 按钮主
  static TextStyle get button => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.5,
      );

  /// 按钮次
  static TextStyle get buttonSecondary => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.3,
      );

  /// 价格
  static TextStyle get price => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: Color(0xFFF2483D),
      );

  /// 价格小
  static TextStyle get priceSmall => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: Color(0xFFF2483D),
      );
}
