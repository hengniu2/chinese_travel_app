import 'package:flutter/material.dart';

/// 设计语言 · 圆角系统（标准化：卡片 16 / 按钮 12 / 输入 14 / 头部曲线 24）
class AppRadius {
  AppRadius._();

  /// 小 - 标签、Chip、Badge
  static const double small = 8;
  /// 中 - 主按钮、弹窗、列表项
  static const double medium = 12;
  /// 大 - 搜索栏、Sheet 顶角
  static const double large = 12;
  /// 全圆 - 胶囊、头像、图标按钮
  static const double full = 9999;

  /// 卡片、内容块
  static const double card = 16;
  /// 输入框圆角
  static const double input = 14;
  /// 头部底部曲线
  static const double headerBottomCurve = 24;
  static const double sheetTop = 16;
  /// 主内容容器
  static const double r16 = 16;
  static const double r20 = 16;
  static const double r24 = 24;
  static const double r30 = 16;
  static const double r32 = 16;

  // 兼容旧命名
  static const double xs = 4;
  static const double sm = small;
  static const double md = medium;
  static const double lg = medium;
  static const double xl = medium;

  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get fullRadius => BorderRadius.circular(full);

  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get smRadius => smallRadius;
  static BorderRadius get mdRadius => mediumRadius;
  static BorderRadius get lgRadius => mediumRadius;
  static BorderRadius get radius16 => BorderRadius.circular(r16);
  static BorderRadius get radius20 => BorderRadius.circular(r20);
  static BorderRadius get radius24 => BorderRadius.circular(r24);
  static BorderRadius get radius30 => BorderRadius.circular(r30);
  static BorderRadius get radius32 => BorderRadius.circular(r32);
  static BorderRadius get heroContentTopRadius => BorderRadius.only(
        topLeft: Radius.circular(sheetTop),
        topRight: Radius.circular(sheetTop),
      );
  static BorderRadius get inputRadius => BorderRadius.circular(input);
  static BorderRadius get headerBottomRadius => BorderRadius.only(
        bottomLeft: Radius.circular(headerBottomCurve),
        bottomRight: Radius.circular(headerBottomCurve),
      );
}
