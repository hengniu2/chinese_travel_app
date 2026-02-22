import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 设计语言 · 渐变常量
/// 品牌渐变 / 页面背景 / 按钮渐变
class AppGradients {
  AppGradients._();

  /// 品牌渐变（Primary → Primary Dark）- 头部、主 CTA 按钮、全应用统一
  static List<Color> get brand => [
        AppColors.primary,
        AppColors.primaryDark,
      ];

  static List<double>? get brandStops => const [0.0, 1.0];

  /// 页面背景三阶（暖黄主导）
  static List<Color> get page => [
        AppColors.gradientStart,
        AppColors.gradientAccent,
        AppColors.gradientEnd,
      ];

  static List<double>? get pageStops => const [0.0, 0.4, 1.0];

  /// 暖白到白（柔和背景、次级区域，非黄块）
  static List<Color> get light => [
        AppColors.gradientStart,
        AppColors.card,
      ];

  static List<double>? get lightStops => const [0.0, 1.0];

  /// 酒店列表页 Header：暖橙 → 柔粉（沉浸式）
  static List<Color> get hotelHeaderWarm => [
        const Color(0xFFFFB74D),
        const Color(0xFFFFCCBC),
        const Color(0xFFF8BBD9),
      ];

  static List<double>? get hotelHeaderWarmStops => const [0.0, 0.5, 1.0];

  /// 酒店列表页 Header：浅绿 → 薄荷（备选）
  static List<Color> get hotelHeaderMint => [
        const Color(0xFFC8E6C9),
        const Color(0xFFB2DFDB),
        const Color(0xFFB2EBF2),
      ];

  static List<double>? get hotelHeaderMintStops => const [0.0, 0.5, 1.0];

  /// 陪游/结伴页 Header：主色渐变（与 brand 一致）
  static List<Color> get companionHeader => [
        AppColors.primary,
        AppColors.primaryDark,
      ];

  static List<double>? get companionHeaderStops => const [0.0, 1.0];

  /// 套餐/打包推荐卡片：黄到金高亮
  static List<Color> get bundleHighlight => [
        const Color(0xFFFFF8E1),
        const Color(0xFFFFECB3),
        const Color(0xFFFFE082),
      ];

  static List<double>? get bundleHighlightStops => const [0.0, 0.5, 1.0];
}
