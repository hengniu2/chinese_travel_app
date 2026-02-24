import 'package:flutter/material.dart';

/// 设计语言 · 间距系统（中国卡通商业风 · 紧凑有序）
/// Section 20 / Card 16 / Pills 8–12 / Page horizontal 16
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// 页面级水平边距（内容区左右）— 16
  static const double pageHorizontal = 16;

  /// 区块/模块间间距 — 20
  static const double sectionGap = 20;
  /// 内容块间距（表单项、卡片内区块）
  static const double contentBlockGap = 12;

  /// 卡片内边距 — 16
  static const double cardPadding = 16;
  /// 胶囊/标签之间 — 8–12
  static const double pillGap = 10;

  /// 页面内边距（常规列表/表单）
  static EdgeInsets get paddingPage => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      );

  /// 卡片内边距（标准 16）
  static EdgeInsets get paddingCard => const EdgeInsets.all(16);

  /// 卡片内边距（紧凑）
  static EdgeInsets get paddingCardSm => const EdgeInsets.all(12);

  /// 列表项间距
  static const double itemSpacing = 8;
  static const double itemSpacingTight = 6;

  /// 列表项内边距
  static EdgeInsets get paddingListItem => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      );

  static EdgeInsets get paddingH => const EdgeInsets.symmetric(horizontal: 16);
  static EdgeInsets get paddingV => const EdgeInsets.symmetric(vertical: 16);

  /// 弹窗内边距
  static EdgeInsets get paddingDialog => const EdgeInsets.all(20);

  static double get gapXs => xs;
  static double get gapSm => sm;
  static double get gapMd => md;
  static double get gapLg => lg;
  static double get gapXl => xl;
  static double get gapXxl => xxl;
}
