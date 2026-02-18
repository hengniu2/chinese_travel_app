import 'package:flutter/material.dart';

/// 统一色彩规范（中国旅行风）
class AppColors {
  AppColors._();

  /// 主色 - 中国绿 #3DBE6C
  static const Color primary = Color(0xFF3DBE6C);

  /// 主色浅色（悬浮、浅底）
  static const Color primaryLight = Color(0xFFE8F5EC);
  static const Color primaryLight2 = Color(0xFFC8E6D3);

  /// 主色深色（按下、强调）
  static const Color primaryDark = Color(0xFF2E9B54);

  /// 背景
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundCard = Colors.white;
  static const Color surface = Color(0xFFF0F2F5);

  /// 文字
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textHint = Color(0xFFB3B3B3);

  /// 分割线 / 边框
  static const Color divider = Color(0xFFEEEEEE);
  static const Color border = Color(0xFFE5E5E5);

  /// 功能色
  static const Color success = Color(0xFF52C41A);
  static const Color warning = Color(0xFFFAAD14);
  static const Color error = Color(0xFFF5222D);
  static const Color info = Color(0xFF1890FF);

  /// 价格 / 强调红
  static const Color price = Color(0xFFF2483D);
  static const Color tagHot = Color(0xFFFF6B35);
}
