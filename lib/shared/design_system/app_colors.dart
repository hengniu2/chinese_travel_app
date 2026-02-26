import 'package:flutter/material.dart';

/// 设计语言 · 颜色系统（中国主流商业旅行风）
/// 主色 / 辅助色 / 功能色 / 灰阶 / 渐变 · 黄调为主但比例克制，搭配多色以成层次
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────────────────────────────────
  // 主色（Primary）- RGB(203, 235, 34) #CBEB22，全应用统一（图标填充、导航选中、按钮）
  // ─────────────────────────────────────────────────────────────────────────
  /// 主色 - 主按钮、选中态、底部导航选中、图标填充/body（亮色）
  static const Color primary = Color(0xFFCBEB22);
  /// 主色浅 - 渐变结束、悬浮、亮部
  static const Color primaryLight = Color(0xFFD4EE4D);
  /// 主色深 - 按下态、深色背景上的主色、渐变深端
  static const Color primaryDark = Color(0xFFB0D01E);
  /// 主色极浅 - 选中态背景（nav 指示、选中 chip）、弱强调底
  static const Color primaryPale = Color(0xFFF5FCE0);
  /// 浅底图标/导航：线条/边框用深色（白底或亮底上的轮廓）
  static const Color iconOutlineOnLight = Color(0xFF1A1A1A);

  // ─────────────────────────────────────────────────────────────────────────
  // 辅助色（Accent）— 按含义区分，避免全用黄
  // ─────────────────────────────────────────────────────────────────────────
  /// 暖辅助 / 强调橙 - 促销、热门、线路/路线类图标、节日
  static const Color accentWarm = Color(0xFFFF8A00);
  /// 冷辅助 - 信息、链接、部分分类图标
  static const Color accentCool = Color(0xFF1890FF);
  /// 金色辅助 - 评分、星级、酒店/亲子类图标、权益
  static const Color accentGold = Color(0xFFFAAD14);
  /// 链接/次要 CTA（查看全部、更多）— 暖珊瑚，非黄
  static const Color linkCta = Color(0xFFD84315);
  /// 陪游/结伴区图标 — 暖琥珀，与主黄区分
  static const Color sectionCompanion = Color(0xFFB8860B);
  /// 种草/内容区图标 — 柔和绿，与主黄区分
  static const Color sectionSeed = Color(0xFF558B2F);

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
  /// 主标题、正文主色
  static const Color textPrimary = Color(0xFF2B2B2B);
  /// 副标题、次要信息
  static const Color textSecondary = Color(0xFF666666);
  /// 辅助说明、占位符（#737373，白底约 4.6:1）
  static const Color textTertiary = Color(0xFF737373);
  /// 禁用、不可点击
  static const Color textDisabled = Color(0xFFBFBFBF);

  /// 边框、分割线（略柔和不刺眼）
  static const Color border = Color(0xFFE5E5E5);
  /// 内部分割
  static const Color divider = Color(0xFFEEEEEE);
  /// 页面基底、次级背景
  static const Color surface = Color(0xFFF5F5F5);
  /// 全局背景（微主色 tint，与 primary 协调）
  static const Color background = Color(0xFFFAFCF5);
  /// 卡片、弹窗、输入区
  static const Color card = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────────────────────────────────────
  // 渐变用色（页面背景 - 微主色 tint）
  // ─────────────────────────────────────────────────────────────────────────
  static const Color gradientStart = Color(0xFFFAFCF5);
  static const Color gradientAccent = Color(0xFFF7FCE8);
  static const Color gradientEnd = Color(0xFFFBFDF6);

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
  /// 标签主色（活动/成团/线路类）- 暖橙，与 primary 区分
  static const Color tagGreen = Color(0xFFFF8A00);

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
  // 陪游页 · 分区背景色（与首页分区风格一致，不同区块不同背景/边框）
  // ─────────────────────────────────────────────────────────────────────────
  /// 陪游页整体基底（浅薄荷，与首页陪游区一致）
  static const Color companionPageBackground = Color(0xFFE0F2F1);
  /// 推荐置顶区 - 浅金
  static const Color companionSectionGold = Color(0xFFFFF8E7);
  /// 热门陪游区 - 浅暖橙
  static const Color companionSectionWarm = Color(0xFFFFF5EB);
  /// 为你推荐区 - 浅紫
  static const Color companionSectionLavender = Color(0xFFF3E5F5);
  /// 推荐陪游区 - 浅绿（与主色协调）
  static const Color companionSectionGreen = Color(0xFFE8F5E9);
  /// 全部陪游区 - 浅蓝
  static const Color companionSectionBlue = Color(0xFFE3F2FD);
  /// 陪游区亮色背景（深色卡片用）
  static const Color companionSectionBright = Color(0xFFFFFBF7);
  /// 陪游横向卡片表面（略深于背景，柔和对比）
  static const Color companionSlideSurface = Color(0xFFF0EDE8);

  // ─────────────────────────────────────────────────────────────────────────
  // 深色模式（Dark mode）- 深灰底 + 暖黄强调，无刺眼霓虹
  // ─────────────────────────────────────────────────────────────────────────
  /// 深色模式 - 背景
  static const Color darkBackground = Color(0xFF121212);
  /// 深色模式 - 卡片 / 表面
  static const Color darkCard = Color(0xFF1E1E1E);
  /// 深色模式 - 主文字
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  /// 深色模式 - 次要文字
  static const Color darkTextSecondary = Color(0xFFBBBBBB);
  /// 深色模式 - 暖黄强调（柔和，非霓虹）
  static const Color darkPrimary = Color(0xFFFFC107);
  /// 深色模式 - 暖黄上的文字（深色以保证对比）
  static const Color darkOnPrimary = Color(0xFF1A1A1A);
  /// 深色模式 - 边框 / 分割
  static const Color darkBorder = Color(0xFF2C2C2C);

  // ─────────────────────────────────────────────────────────────────────────
  // 登录/注册 · 主按钮与链接（深绿保证白字对比度，更鲜明）
  // ─────────────────────────────────────────────────────────────────────────
  /// 登录/注册主按钮背景 - 鲜明深绿，白字清晰
  static const Color authPrimary = Color(0xFF2E7D32);
  /// 登录/注册主按钮按下/深色态
  static const Color authPrimaryDark = Color(0xFF1B5E20);
  /// 登录/注册区链接、验证码按钮等 - 与主按钮一致
  static const Color authLink = Color(0xFF388E3C);

  // ─────────────────────────────────────────────────────────────────────────
  // 兼容旧命名（逐步迁移后可移除）
  // ─────────────────────────────────────────────────────────────────────────
  static const Color backgroundCard = card;
  static const Color textHint = textTertiary;
  static const Color primaryLight2 = Color(0xFFE0F5A8);
  static const Color tagHot = accentWarm;
}
