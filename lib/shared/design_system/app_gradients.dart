import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 设计语言 · 渐变常量（中国卡通商业风）
/// 用于：Headers / CTA 按钮 / Active tabs / 价格文案 / 选中底部导航
class AppGradients {
  AppGradients._();

  // ─────────────────────────────────────────────────────────────────────────
  // 通用：头部、CTA、Active 态、选中导航
  // ─────────────────────────────────────────────────────────────────────────

  /// 品牌渐变（Primary → Primary Dark）— 头部、主 CTA 按钮、选中底 Nav
  static List<Color> get brand => [
        AppColors.primary,
        AppColors.primaryDark,
      ];

  static List<double>? get brandStops => const [0.0, 1.0];

  /// CTA 按钮渐变（与 brand 一致，可单独扩展）
  static List<Color> get ctaButton => brand;
  static List<double>? get ctaButtonStops => brandStops;

  /// Active Tab 背景/指示
  static List<Color> get activeTab => [
        AppColors.primaryPale,
        AppColors.primaryLight.withValues(alpha: 0.4),
      ];
  static List<double>? get activeTabStops => const [0.0, 1.0];

  /// 价格文案渐变（暖红/金感）
  static List<Color> get price => [
        AppColors.price,
        AppColors.accentWarm,
      ];
  static List<double>? get priceStops => const [0.0, 1.0];

  /// 选中底部导航项背景（弱渐变）
  static List<Color> get selectedNav => [
        AppColors.primaryPale,
        AppColors.primaryLight.withValues(alpha: 0.3),
      ];
  static List<double>? get selectedNavStops => const [0.0, 1.0];

  // ─────────────────────────────────────────────────────────────────────────
  // 页面背景
  // ─────────────────────────────────────────────────────────────────────────

  /// 页面背景三阶（暖黄主导，避免纯白）
  static List<Color> get page => [
        AppColors.gradientStart,
        AppColors.gradientAccent,
        AppColors.gradientEnd,
      ];

  static List<double>? get pageStops => const [0.0, 0.4, 1.0];

  /// 暖白到白（柔和背景、次级区域）
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

  /// 陪游页 Header：橙 → 暖黄（中国卡通商业风）
  static List<Color> get companionHeaderOrangeWarm => [
        const Color(0xFFFF8A00),
        const Color(0xFFFFB74D),
        const Color(0xFFFFD54F),
      ];

  static List<double>? get companionHeaderOrangeWarmStops =>
      const [0.0, 0.5, 1.0];

  /// 定制旅行页 Header：鲜青柠 → 柔和绿（premium green theme）
  static List<Color> get customTravelHeader => [
        const Color(0xFFAED581),
        const Color(0xFF81C784),
        const Color(0xFF66BB6A),
      ];

  static List<double>? get customTravelHeaderStops =>
      const [0.0, 0.5, 1.0];

  /// 定制旅行 CTA：强绿渐变 + 光晕
  static List<Color> get customTravelCta => [
        const Color(0xFF7CB342),
        const Color(0xFF558B2F),
      ];

  static List<double>? get customTravelCtaStops => const [0.0, 1.0];

  /// 套餐/打包推荐卡片：黄到金高亮
  static List<Color> get bundleHighlight => [
        const Color(0xFFFFF8E1),
        const Color(0xFFFFECB3),
        const Color(0xFFFFE082),
      ];

  static List<double>? get bundleHighlightStops => const [0.0, 0.5, 1.0];
}
