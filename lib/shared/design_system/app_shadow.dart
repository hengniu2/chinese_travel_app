import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 设计语言 · 阴影系统（中国卡通商业风）
/// 仅软阴影、无硬边框；阴影色略带主题色；blur 20–30，Y offset 8–12
class AppShadow {
  AppShadow._();

  // ─────────────────────────────────────────────────────────────────────────
  // 软阴影（主题色微 tint，blur 20–30，Y 8–12）
  // ─────────────────────────────────────────────────────────────────────────

  /// 主阴影色 — 深灰带主色微 tint（柔和，非纯黑）
  static Color get _shadowColor =>
      (Color.lerp(
            const Color(0xFF1A1A1A),
            AppColors.primaryDark.withValues(alpha: 0.15),
            0.12,
          ) ??
          const Color(0xFF1A1A1A))
          .withValues(alpha: 0.12);

  /// 卡片/列表项 — 软、Y 8–12，blur 20–30
  static List<BoxShadow> get light => [
        BoxShadow(
          color: _shadowColor,
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ];

  /// 悬浮/按钮/选中态 — 略强，仍软
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: _shadowColor,
          offset: const Offset(0, 10),
          blurRadius: 28,
          spreadRadius: 0,
        ),
      ];

  /// 弹窗/Sheet — 浮层感，仍软
  static List<BoxShadow> get heavy => [
        BoxShadow(
          color: _shadowColor.withValues(alpha: 0.18),
          offset: const Offset(0, 12),
          blurRadius: 32,
          spreadRadius: 0,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // 组件语义别名
  // ─────────────────────────────────────────────────────────────────────────

  /// 卡片默认
  static List<BoxShadow> get card => light;

  /// 卡片立体感（略强于 light）
  static List<BoxShadow> get cardElevated => [
        BoxShadow(
          color: _shadowColor,
          offset: const Offset(0, 10),
          blurRadius: 26,
          spreadRadius: 0,
        ),
      ];

  /// 卡片悬浮/点击
  static List<BoxShadow> get cardHover => medium;

  /// 按钮、悬浮元素
  static List<BoxShadow> get floating => medium;
}
