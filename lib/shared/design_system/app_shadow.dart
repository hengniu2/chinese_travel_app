import 'package:flutter/material.dart';

/// 设计语言 · 阴影系统（轻 / 中，无重阴影，保持 premium 轻盈感）
/// 仅用两层表达层级；颜色为带透明度黑
class AppShadow {
  AppShadow._();

  /// 轻 - 默认卡片、列表项、输入框聚焦
  static List<BoxShadow> get light => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  /// 中 - 悬浮卡片、主按钮、选中态（仍保持克制）
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: -2,
        ),
      ];

  /// 弹窗/Sheet（轻量浮层，非重阴影）
  static List<BoxShadow> get heavy => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          offset: const Offset(0, 6),
          blurRadius: 20,
          spreadRadius: -2,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // 组件语义别名
  // ─────────────────────────────────────────────────────────────────────────
  /// 卡片默认（轻）
  static List<BoxShadow> get card => light;

  /// 卡片立体感（略强于 light，仍克制）
  static List<BoxShadow> get cardElevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 3),
          blurRadius: 10,
          spreadRadius: -1,
        ),
      ];

  /// 卡片悬浮/点击（中，不加重）
  static List<BoxShadow> get cardHover => medium;

  /// 浮动感（按钮、悬浮元素）
  static List<BoxShadow> get floating => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: -1,
        ),
      ];
}
