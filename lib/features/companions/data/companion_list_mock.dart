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
      list.sort((a, b) => b.rating.compareTo(a.rating));
      break;
  }

  return list;
}

/// 热门陪游（前4条，用于首屏横滑）
List<CompanionListItem> getFeaturedCompanions() {
  return getCompanionList(const CompanionListFilters(sort: CompanionSort.recommended)).take(4).toList();
}

/// 推荐陪游（第5–10条，与热门不重复）
List<CompanionListItem> getRecommendedCompanions() {
  final full = getCompanionList(const CompanionListFilters(sort: CompanionSort.recommended));
  return full.skip(4).take(6).toList();
}

/// Mock 陪游列表（测试用）
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
  ),
];
