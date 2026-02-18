import 'package:flutter/material.dart';

/// 统一留白（舒适留白）
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// 水平/垂直 边距
  static EdgeInsets get paddingPage => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      );

  static EdgeInsets get paddingCard => const EdgeInsets.all(16);

  static EdgeInsets get paddingCardSm => const EdgeInsets.all(12);

  /// 列表项间距
  static EdgeInsets get paddingListItem => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      );

  /// 仅水平
  static EdgeInsets get paddingH => const EdgeInsets.symmetric(horizontal: 16);

  /// 仅垂直
  static EdgeInsets get paddingV => const EdgeInsets.symmetric(vertical: 16);

  /// 组件间距
  static double get gapXs => xs;
  static double get gapSm => sm;
  static double get gapMd => md;
  static double get gapLg => lg;
  static double get gapXl => xl;
}
