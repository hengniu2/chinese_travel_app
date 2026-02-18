import 'package:flutter/material.dart';

/// 统一圆角
class AppRadius {
  AppRadius._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;

  /// 卡片圆角 16
  static const double card = 16;
  static const double lg = 20;
  static const double xl = 24;

  /// 全圆（胶囊/头像）
  static const double full = 999;

  static BorderRadius get cardRadius => BorderRadius.circular(card);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}
