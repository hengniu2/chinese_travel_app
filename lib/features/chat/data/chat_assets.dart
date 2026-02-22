// 消息/聊天页 · 小红书/马蜂窝风 暖色中国风（仅本模块使用）
// 头图、色板、圆角等与首页区分，避免灰扁风格。

import 'package:flutter/material.dart';

/// 消息列表页顶部头图
const String kChatHeaderImageAsset = 'assets/header_chat_messages.png';

// ─── 暖色中国风色板（小红书+马蜂窝+可爱插画）────────────────────────────────────
class ChatListColors {
  ChatListColors._();

  static const Color primary = Color(0xFFCBEB22);       // 与主应用一致 RGB(203,235,34)
  static const Color secondary = Color(0xFFD4EE4D);     // 主色浅
  static const Color accent = Color(0xFF5EC2A6);        // 薄荷绿
  static const Color backgroundStart = Color(0xFFFFF5F0); // 浅桃
  static const Color backgroundEnd = Color(0xFFFFFBF5);   // 软奶油
  static const Color headerGradientStart = Color(0xFF7EDDD0); // 薄荷绿
  static const Color headerGradientEnd = Color(0xFFB8EDE8);   // 浅青
  static const Color card = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textPreview = Color(0xFF9E9E9E);
  static const Color unreadBadgeStart = Color(0xFFFF6B6B);
  static const Color unreadBadgeEnd = Color(0xFFFF8C42);
}

/// 消息列表页圆角与间距
const double kChatCardRadius = 18;
const double kChatSearchPillRadius = 16;
const double kChatHeaderHeight = 142; // 约减少 30%（原 200）
