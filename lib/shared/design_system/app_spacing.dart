import 'package:flutter/material.dart';

/// 设计语言 · 间距系统（4/8/12/16/20/24）
/// 基础单位 4px，全部为 4 的整数倍
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// 页面级水平边距（内容区左右）
  static const double pageHorizontal = lg;

  /// 区块间间距（模块标题与内容、卡片组之间）- 紧凑
  static const double sectionGap = 16;
  /// 内容块间距（表单项、卡片内区块）
  static const double contentBlockGap = 12;

  /// 页面内边距（常规列表/表单）
  static EdgeInsets get paddingPage => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      );

  /// 卡片内边距（标准 12–14）
  static EdgeInsets get paddingCard => const EdgeInsets.all(14);

  /// 卡片内边距（紧凑）
  static EdgeInsets get paddingCardSm => const EdgeInsets.all(12);

  /// 列表项间距（紧凑）
  static const double itemSpacing = 8;
  static const double itemSpacingTight = 6;

  /// 列表项间距（信息密度与可点区域平衡）
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
