import 'package:flutter/material.dart';

/// 设计语言 · 圆角系统（偏小：卡片 8 / 按钮 6 / 标签 4）
class AppRadius {
  AppRadius._();

  /// 小 - 标签、Chip
  static const double small = 4;
  /// 中 - 列表项、图片缩略图
  static const double medium = 6;
  /// 大 - 主 CTA 按钮
  static const double large = 8;
  /// 全圆 - 胶囊、头像
  static const double full = 9999;

  /// 卡片、内容块
  static const double card = 8;
  /// 搜索栏、大按钮
  static const double search = 8;
  /// 主内容容器
  static const double r16 = 8;
  static const double r20 = 8;
  static const double r24 = 8;
  static const double r30 = 8;
  static const double r32 = 8;

  // 兼容旧命名
  static const double xs = small;
  static const double sm = medium;
  static const double md = large;
  static const double lg = 8;
  static const double xl = 8;

  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get fullRadius => BorderRadius.circular(full);

  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get smRadius => mediumRadius;
  static BorderRadius get mdRadius => largeRadius;
  static BorderRadius get lgRadius => BorderRadius.circular(card);
  static BorderRadius get radius16 => BorderRadius.circular(r16);
  static BorderRadius get radius20 => BorderRadius.circular(r20);
  static BorderRadius get radius24 => BorderRadius.circular(r24);
  static BorderRadius get radius30 => BorderRadius.circular(r30);
  static BorderRadius get radius32 => BorderRadius.circular(r32);
  static BorderRadius get heroContentTopRadius => BorderRadius.only(
        topLeft: Radius.circular(r32),
        topRight: Radius.circular(r32),
      );
}
