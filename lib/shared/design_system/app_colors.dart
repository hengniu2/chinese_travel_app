import 'package:flutter/material.dart';

/// 设计语言 · 颜色系统（中国主流商业旅行风）
/// 主色 / 辅助色 / 功能色 / 灰阶 / 渐变
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────────────────────────────────
  // 主色（Primary）
  // ─────────────────────────────────────────────────────────────────────────
  /// 主色 - 主按钮、选中态、链接、核心图标
  static const Color primary = Color(0xFF2E9B54);
  /// 主色浅 - 悬浮、浅底、次要强调（与品牌绿衔接）
  static const Color primaryLight = Color(0xFF3DBE6C);
  /// 主色深 - 按下态、深色背景上的主色
  static const Color primaryDark = Color(0xFF24804A);
  /// 主色极浅 - 标签背景、高亮区块、弱强调
  static const Color primaryPale = Color(0xFFE8F5EC);

  // ─────────────────────────────────────────────────────────────────────────
  // 辅助色（Accent）
  // ─────────────────────────────────────────────────────────────────────────
  /// 暖辅助 - 促销、热门、TOP 标签、节日
  static const Color accentWarm = Color(0xFFFF6B35);
  /// 冷辅助 - 信息、链接、部分分类图标
  static const Color accentCool = Color(0xFF1890FF);
  /// 金色辅助 - 评分、星级、签到、权益
  static const Color accentGold = Color(0xFFFAAD14);

  // ─────────────────────────────────────────────────────────────────────────
  // 功能色（Semantic）
  // ─────────────────────────────────────────────────────────────────────────
  /// 价格 / 强 CTA
  static const Color price = Color(0xFFF2483D);
  /// 成功、已确认、保障勾选
  static const Color success = Color(0xFF52C41A);
  /// 待付款、即将过期
  static const Color warning = Color(0xFFFAAD14);
  /// 失败、错误、不可用
  static const Color error = Color(0xFFF5222D);
  /// 提示、说明
  static const Color info = Color(0xFF1890FF);

  // ─────────────────────────────────────────────────────────────────────────
  // 灰阶（Neutral）- 商业级对比度，符合 WCAG AA
  // ─────────────────────────────────────────────────────────────────────────
  /// 主标题、正文主色（#1A1A1A，白底对比度 >12:1）
  static const Color textPrimary = Color(0xFF1A1A1A);
  /// 副标题、次要信息（#525252，白底约 8:1，层次清晰）
  static const Color textSecondary = Color(0xFF525252);
  /// 辅助说明、占位符（#737373，白底约 4.6:1）
  static const Color textTertiary = Color(0xFF737373);
  /// 禁用、不可点击
  static const Color textDisabled = Color(0xFFBFBFBF);

  /// 边框、分割线（略柔和不刺眼）
  static const Color border = Color(0xFFE5E5E5);
  /// 内部分割
  static const Color divider = Color(0xFFEEEEEE);
  /// 页面基底、次级背景
  static const Color surface = Color(0xFFF5F7FA);
  /// 全局背景
  static const Color background = Color(0xFFFAFBFC);
  /// 卡片、弹窗、输入区
  static const Color card = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────────────────────────────────
  // 渐变用色（页面背景三阶）
  // ─────────────────────────────────────────────────────────────────────────
  static const Color gradientStart = Color(0xFFF0F9F4);
  static const Color gradientAccent = Color(0xFFE8F5EC);
  static const Color gradientEnd = Color(0xFFF8F9FA);

  // ─────────────────────────────────────────────────────────────────────────
  // 商业化 / Home Hero（暖色参考，可与主色并存）
  // ─────────────────────────────────────────────────────────────────────────
  /// Hero 暖色渐变 - 起始（较深暖红）
  static const Color primaryGradientWarmStart = Color(0xFFE85A4A);
  /// Hero 暖色渐变 - 结束（浅暖橙）
  static const Color primaryGradientWarmEnd = Color(0xFFF5A86A);
  /// 暖色背景（Hero 底部过渡）
  static const Color warmBackground = Color(0xFFFFF5EE);
  /// 内容区暖白（非纯白，与暖 Hero 协调）
  static const Color surfaceWarmWhite = Color(0xFFFFFBF7);
  /// 强调红（热门标签、强 CTA）
  static const Color accentRed = Color(0xFFE84855);
  /// 标签绿（活动/成团等）
  static const Color tagGreen = Color(0xFF2E9B54);

  // ─────────────────────────────────────────────────────────────────────────
  // 首页 · 中国卡通商业风分区色（高饱和、节日感）
  // ─────────────────────────────────────────────────────────────────────────
  /// Header 主红（卡通插画区）
  static const Color homeHeaderRed = Color(0xFFE53935);
  /// Header 橙（渐变结束）
  static const Color homeHeaderOrange = Color(0xFFFF7043);
  /// 推荐区 - 浅绿
  static const Color homeSectionGreen = Color(0xFFE8F5E9);
  /// 亲子区 - 浅黄
  static const Color homeSectionYellow = Color(0xFFFFF8E1);
  /// 周边活动区 - 蓝渐变起
  static const Color homeSectionBlueStart = Color(0xFFE3F2FD);
  /// 周边活动区 - 蓝渐变止
  static const Color homeSectionBlueEnd = Color(0xFFBBDEFB);
  /// 搜索胶囊白
  static const Color homeSearchCapsule = Color(0xFFFFFFFF);
  /// 「有趣的一天」绿胶囊
  static const Color homeChipGreen = Color(0xFF43A047);
  /// 热门/角标红
  static const Color homeChipRed = Color(0xFFE53935);

  // ─────────────────────────────────────────────────────────────────────────
  // 兼容旧命名（逐步迁移后可移除）
  // ─────────────────────────────────────────────────────────────────────────
  static const Color backgroundCard = card;
  static const Color textHint = textTertiary;
  static const Color primaryLight2 = Color(0xFFC8E6D3);
  static const Color tagHot = accentWarm;
}
