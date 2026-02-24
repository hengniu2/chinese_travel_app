import 'package:flutter/material.dart';

/// 设计语言 · 圆角系统（中国卡通商业风）
/// 大圆角、层次清晰：主卡片 24–28 / 头部 32–40 / 胶囊 20–24 / 按钮 24–28 / 头像全圆
class AppRadius {
  AppRadius._();

  // ─────────────────────────────────────────────────────────────────────────
  // 核心圆角（Chinese cartoon-style: large, friendly）
  // ─────────────────────────────────────────────────────────────────────────

  /// 主卡片、内容块 — 24–28
  static const double card = 26;
  /// 头部底部曲线 — 32–40（沉浸式头部）
  static const double headerBottom = 36;
  /// 胶囊/标签/Pill — 20–24
  static const double pill = 22;
  /// 主按钮、CTA — 24–28
  static const double button = 26;
  /// 头像、图标按钮 — 全圆
  static const double avatar = 9999;
  /// Sheet/弹窗顶部
  static const double sheetTop = 28;

  /// 输入框（与卡片协调，略小）
  static const double input = 20;

  // ─────────────────────────────────────────────────────────────────────────
  // 语义别名（兼容 + 新规范）
  // ─────────────────────────────────────────────────────────────────────────

  static const double small = 12;
  static const double medium = 20;
  static const double large = 26;
  static const double full = 9999;

  /// 兼容旧命名
  static const double headerBottomCurve = headerBottom;
  static const double r16 = 16;
  static const double r20 = 20;
  static const double r24 = 24;
  static const double r30 = 30;
  static const double r32 = 32;

  static const double xs = 8;
  static const double sm = 12;
  static const double md = 20;
  static const double lg = 26;
  static const double xl = 28;

  // ─────────────────────────────────────────────────────────────────────────
  // BorderRadius getters
  // ─────────────────────────────────────────────────────────────────────────

  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get fullRadius => BorderRadius.circular(full);

  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
  static BorderRadius get buttonRadius => BorderRadius.circular(button);
  static BorderRadius get avatarRadius => BorderRadius.circular(avatar);
  static BorderRadius get inputRadius => BorderRadius.circular(input);

  static BorderRadius get smRadius => smallRadius;
  static BorderRadius get mdRadius => mediumRadius;
  static BorderRadius get lgRadius => largeRadius;

  static BorderRadius get radius16 => BorderRadius.circular(r16);
  static BorderRadius get radius20 => BorderRadius.circular(r20);
  static BorderRadius get radius24 => BorderRadius.circular(r24);
  static BorderRadius get radius30 => BorderRadius.circular(r30);
  static BorderRadius get radius32 => BorderRadius.circular(r32);

  /// 头部仅底部大圆角
  static BorderRadius get headerBottomRadius => BorderRadius.only(
        bottomLeft: Radius.circular(headerBottom),
        bottomRight: Radius.circular(headerBottom),
      );

  /// Sheet/全屏 overlay 仅顶部大圆角
  static BorderRadius get heroContentTopRadius => BorderRadius.only(
        topLeft: Radius.circular(sheetTop),
        topRight: Radius.circular(sheetTop),
      );
}
