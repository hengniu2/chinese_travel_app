import 'package:flutter/material.dart';

/// 设计语言 · 阴影系统（轻 / 中 / 重）
/// 仅用三层，表达层级；颜色为带透明度黑
class AppShadow {
  AppShadow._();

  /// 轻 - 默认卡片、列表项、输入框聚焦
  static List<BoxShadow> get light => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  /// 中 - 悬浮卡片、主按钮、选中卡片
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: -2,
        ),
      ];

  /// 重 - 弹窗、Bottom Sheet、固定底栏
  static List<BoxShadow> get heavy => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          offset: const Offset(0, 8),
          blurRadius: 24,
          spreadRadius: -4,
        ),
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // 组件语义别名
  // ─────────────────────────────────────────────────────────────────────────
  /// 卡片默认（轻）
  static List<BoxShadow> get card => light;

  /// 卡片立体感（商业级：略强一层，增强质感）
  static List<BoxShadow> get cardElevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.045),
          offset: const Offset(0, 1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.07),
          offset: const Offset(0, 4),
          blurRadius: 14,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 10),
          blurRadius: 24,
          spreadRadius: -4,
        ),
      ];

  /// 卡片悬浮/点击（中强）
  static List<BoxShadow> get cardHover => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 8),
          blurRadius: 20,
          spreadRadius: -2,
        ),
      ];

  /// 浮动感（Y 4～8，统一向下）
  static List<BoxShadow> get floating => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          offset: const Offset(0, 8),
          blurRadius: 20,
          spreadRadius: -2,
        ),
      ];
}
