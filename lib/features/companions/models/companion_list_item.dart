import 'package:flutter/material.dart';

/// 陪游排名徽章：Top 1% / 城市优选 / 高人气 / 认证陪游
enum CompanionRankBadge {
  top1Percent,
  cityPreferred,
  highPopularity,
  verified,
}

/// 限时优惠标签
enum CompanionDiscountTag {
  limitedTime,
  todaySpecial,
}

/// 陪游列表项（发现页 / 卡片用）
class CompanionListItem {
  const CompanionListItem({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.completedOrders,
    required this.pricePerDay,
    required this.avatarUrl,
    required this.tags,
    this.languages,
    this.responseTime,
    required this.isOnline,
    required this.isVerified,
    this.cityRank,
    this.rankBadges = const [],
    this.achievementIcons = const [],
    this.isSponsored = false,
    this.discountTag,
    this.pricePer3h,
    this.hasGroupDiscount = false,
    this.level = 1,
    this.levelProgress = 0.0,
    this.favoritesCount = 0,
    this.viewCount = 0,
    this.isTrending = false,
    this.spotsLeftToday,
    this.responseTimeMinutes,
  });

  final String id;
  final String name;
  final int age;
  final String city;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int completedOrders;
  final double pricePerDay;
  final String avatarUrl;
  final List<String> tags;
  final List<String>? languages;
  final String? responseTime;
  final bool isOnline;
  final bool isVerified;
  final int? cityRank;
  final List<CompanionRankBadge> rankBadges;
  final List<IconData> achievementIcons;
  /// 推荐置顶（广告位）
  final bool isSponsored;
  /// 限时优惠 / 今日特价
  final CompanionDiscountTag? discountTag;
  /// 3小时套餐价
  final double? pricePer3h;
  /// 拼单优惠
  final bool hasGroupDiscount;
  /// 陪游等级 LV1–LV5
  final int level;
  /// 等级进度 0.0–1.0（下一级）
  final double levelProgress;
  /// 收藏数
  final int favoritesCount;
  /// 浏览量
  final int viewCount;
  /// 人气飙升（动态 trending）
  final bool isTrending;
  /// 今日剩余名额（urgency）
  final int? spotsLeftToday;
  /// 平均回复分钟数（快回复徽章）
  final int? responseTimeMinutes;
}
