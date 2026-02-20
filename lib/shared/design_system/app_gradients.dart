import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 设计语言 · 渐变常量
/// 品牌渐变 / 页面背景 / 按钮渐变
class AppGradients {
  AppGradients._();

  /// 品牌渐变（Primary Dark → Primary）- 头部、主 CTA 按钮
  static List<Color> get brand => [
        AppColors.primaryDark,
        AppColors.primary,
      ];

  static List<double>? get brandStops => const [0.0, 1.0];

  /// 页面背景三阶（与主色协调）
  static List<Color> get page => [
        AppColors.gradientStart,
        AppColors.gradientAccent,
        AppColors.gradientEnd,
      ];

  static List<double>? get pageStops => const [0.0, 0.4, 1.0];

  /// 浅绿到白（柔和背景、次级区域）
  static List<Color> get light => [
        AppColors.primaryPale,
        AppColors.card,
      ];

  static List<double>? get lightStops => const [0.0, 1.0];
}
