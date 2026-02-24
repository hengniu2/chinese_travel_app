import 'package:flutter/material.dart';

import '../models/companion_list_item.dart';

/// 陪游列表筛选
class CompanionListFilters {
  const CompanionListFilters({
    this.city,
    this.tag,
    this.sort = CompanionSort.recommended,
  });

  final String? city;
  final String? tag;
  final CompanionSort sort;

  CompanionListFilters copyWith({
    String? city,
    String? tag,
    CompanionSort? sort,
  }) {
    return CompanionListFilters(
      city: city ?? this.city,
      tag: tag ?? this.tag,
      sort: sort ?? this.sort,
    );
  }
}

enum CompanionSort {
  recommended,
  rating,
  priceAsc,
  priceDesc,
}

/// 全部陪游列表（内存 mock，支持筛选与排序）
List<CompanionListItem> getCompanionList(CompanionListFilters filters) {
  final raw = companionMockList;

  var list = raw.where((c) {
    if (filters.city != null && filters.city!.isNotEmpty && c.city != filters.city) return false;
    if (filters.tag != null && filters.tag!.isNotEmpty) {
      if (!c.tags.any((t) => t == filters.tag)) return false;
    }
    return true;
  }).toList();

  switch (filters.sort) {
    case CompanionSort.rating:
      list.sort((a, b) => b.rating.compareTo(a.rating));
      break;
    case CompanionSort.priceAsc:
      list.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
      break;
    case CompanionSort.priceDesc:
      list.sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
      break;
    case CompanionSort.recommended:
    default:
      list.sort((a, b) => _hotScore(b).compareTo(_hotScore(a)));
      break;
  }

  return list;
}

/// 热度综合分：评分 + 订单量 + 评价数
double _hotScore(CompanionListItem c) {
  return c.rating * 20 + c.completedOrders * 0.5 + c.reviewCount * 0.3;
}

/// 推荐置顶（广告位，1–2条）
List<CompanionListItem> getSponsoredCompanions() {
  return companionMockList.where((c) => c.isSponsored).take(2).toList();
}

/// 热门陪游（前4条，用于首屏横滑，排除已置顶）
List<CompanionListItem> getFeaturedCompanions() {
  final full = getCompanionList(const CompanionListFilters(sort: CompanionSort.recommended));
  return full.where((c) => !c.isSponsored).take(4).toList();
}

/// 推荐陪游（第5–10条，与热门不重复）
List<CompanionListItem> getRecommendedCompanions() {
  final full = getCompanionList(const CompanionListFilters(sort: CompanionSort.recommended));
  return full.where((c) => !c.isSponsored).skip(4).take(6).toList();
}

/// 智能推荐参数：基于位置、点击、评分偏好
class SmartRecommendationParams {
  const SmartRecommendationParams({
    this.location,
    this.clickedIds = const [],
    this.preferHighRating = false,
  });

  final String? location;
  final List<String> clickedIds;
  final bool preferHighRating;
}

/// 为你推荐：基于位置、浏览点击、评分偏好的个性化推荐
List<CompanionListItem> getSmartRecommendations(SmartRecommendationParams params) {
  final all = companionMockList.where((c) => !c.isSponsored).toList();
  if (all.isEmpty) return [];

  // 收集已点击陪游的标签（用于相似度）
  final clickedTags = <String>{};
  for (final id in params.clickedIds) {
    for (final c in companionMockList) {
      if (c.id == id) {
        clickedTags.addAll(c.tags);
        break;
      }
    }
  }

  double score(CompanionListItem c) {
    var s = _hotScore(c) * 0.1;
    if (params.location != null && c.city == params.location) s += 15;
    final sharedTags = c.tags.where((t) => clickedTags.contains(t)).length;
    s += sharedTags * 4;
    if (params.preferHighRating && c.rating >= 4.8) s += 8;
    if (c.isTrending) s += 3;
    return s;
  }

  all.sort((a, b) => score(b).compareTo(score(a)));
  return all.take(6).toList();
}

/// 相似陪游（同城市，排除当前，用于详情页）
List<CompanionListItem> getSimilarCompanions(String excludeId, String? city) {
  var list = companionMockList.where((c) => c.id != excludeId && !c.isSponsored).toList();
  if (city != null && city.isNotEmpty) {
    list = list.where((c) => c.city == city).toList();
  }
  if (list.isEmpty) list = companionMockList.where((c) => c.id != excludeId).take(4).toList();
  return list.take(4).toList();
}

/// Mock 陪游列表（测试用，含排名与徽章）
final List<CompanionListItem> companionMockList = [
  CompanionListItem(
    id: '1',
    name: '林小游',
    age: 28,
    city: '杭州',
    experienceYears: 3,
    rating: 4.9,
    reviewCount: 128,
    completedOrders: 356,
    pricePerDay: 298,
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    tags: ['摄影跟拍', '人文讲解', '路线规划', '方言沟通', '美食推荐'],
    languages: ['中文', '英语'],
    responseTime: '平均回复 5分钟内',
    isOnline: true,
    isVerified: true,
    cityRank: 1,
    rankBadges: [CompanionRankBadge.top1Percent, CompanionRankBadge.cityPreferred, CompanionRankBadge.verified],
    achievementIcons: [Icons.emoji_events_rounded, Icons.star_rounded],
    isSponsored: true,
    discountTag: CompanionDiscountTag.todaySpecial,
    pricePer3h: 128,
    hasGroupDiscount: true,
    level: 4,
    levelProgress: 0.72,
    favoritesCount: 89,
    viewCount: 1250,
    isTrending: true,
    spotsLeftToday: 2,
    responseTimeMinutes: 5,
  ),
  CompanionListItem(
    id: '2',
    name: '陈漫行',
    age: 32,
    city: '北京',
    experienceYears: 5,
    rating: 4.8,
    reviewCount: 96,
    completedOrders: 520,
    pricePerDay: 368,
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
    tags: ['历史文化', '故宫讲解', '胡同游', '摄影跟拍'],
    languages: ['中文', '日语'],
    responseTime: '平均回复 10分钟内',
    isOnline: true,
    isVerified: true,
    cityRank: 2,
    rankBadges: [CompanionRankBadge.top1Percent, CompanionRankBadge.highPopularity, CompanionRankBadge.verified],
    achievementIcons: [Icons.workspace_premium_rounded, Icons.star_rounded],
    isSponsored: true,
    discountTag: CompanionDiscountTag.limitedTime,
    pricePer3h: 168,
    level: 5,
    levelProgress: 0.0,
    favoritesCount: 156,
    viewCount: 2100,
    isTrending: false,
    spotsLeftToday: 1,
    responseTimeMinutes: 10,
  ),
  CompanionListItem(
    id: '3',
    name: '苏江南',
    age: 26,
    city: '苏州',
    experienceYears: 2,
    rating: 4.7,
    reviewCount: 64,
    completedOrders: 89,
    pricePerDay: 268,
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    tags: ['园林讲解', '昆曲文化', '美食推荐', '古镇导览'],
    languages: null,
    responseTime: null,
    isOnline: false,
    isVerified: false,
    cityRank: 3,
    rankBadges: [CompanionRankBadge.cityPreferred],
    achievementIcons: [Icons.star_rounded],
    pricePer3h: 98,
    discountTag: CompanionDiscountTag.limitedTime,
    level: 2,
    levelProgress: 0.45,
    favoritesCount: 32,
    viewCount: 480,
    isTrending: true,
    spotsLeftToday: 3,
    responseTimeMinutes: 15,
  ),
  CompanionListItem(
    id: '4',
    name: '王西安',
    age: 30,
    city: '西安',
    experienceYears: 4,
    rating: 4.9,
    reviewCount: 82,
    completedOrders: 412,
    pricePerDay: 328,
    avatarUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
    tags: ['兵马俑讲解', '美食推荐', '夜景跟拍', '方言沟通'],
    languages: ['中文'],
    responseTime: '平均回复 5分钟内',
    isOnline: true,
    isVerified: true,
    cityRank: 1,
    rankBadges: [CompanionRankBadge.top1Percent, CompanionRankBadge.highPopularity, CompanionRankBadge.verified],
    achievementIcons: [Icons.emoji_events_rounded, Icons.workspace_premium_rounded],
    pricePer3h: 148,
    hasGroupDiscount: true,
    level: 4,
    levelProgress: 0.88,
    favoritesCount: 112,
    viewCount: 1680,
    isTrending: false,
    spotsLeftToday: 2,
    responseTimeMinutes: 5,
  ),
  CompanionListItem(
    id: '5',
    name: '李蓉城',
    age: 27,
    city: '成都',
    experienceYears: 1,
    rating: 4.6,
    reviewCount: 51,
    completedOrders: 42,
    pricePerDay: 248,
    avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=200',
    tags: ['美食推荐', '熊猫基地', '川剧文化', '路线规划'],
    languages: null,
    responseTime: null,
    isOnline: true,
    isVerified: false,
    cityRank: null,
    rankBadges: [CompanionRankBadge.highPopularity],
    achievementIcons: [],
    level: 1,
    levelProgress: 0.6,
    favoritesCount: 18,
    viewCount: 220,
    isTrending: true,
    spotsLeftToday: 4,
    responseTimeMinutes: 20,
  ),
  CompanionListItem(
    id: '6',
    name: '张小沪',
    age: 29,
    city: '上海',
    experienceYears: 4,
    rating: 4.8,
    reviewCount: 73,
    completedOrders: 288,
    pricePerDay: 358,
    avatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=200',
    tags: ['外滩夜景', '弄堂文化', '摄影跟拍', '美食推荐'],
    languages: ['中文', '英语', '粤语'],
    responseTime: '平均回复 5分钟内',
    isOnline: true,
    isVerified: true,
    cityRank: 3,
    rankBadges: [CompanionRankBadge.cityPreferred, CompanionRankBadge.verified],
    achievementIcons: [Icons.star_rounded],
    pricePer3h: 158,
    discountTag: CompanionDiscountTag.todaySpecial,
    level: 3,
    levelProgress: 0.2,
    favoritesCount: 67,
    viewCount: 920,
    isTrending: false,
    spotsLeftToday: 2,
    responseTimeMinutes: 5,
  ),
];
