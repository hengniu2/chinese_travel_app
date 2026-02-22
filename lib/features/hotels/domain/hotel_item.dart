/// 酒店标签类型：舒适 / 高端 / 热门
enum HotelTagBadge {
  comfort,  // 舒适
  premium, // 高端
  hot,     // 热门
}

/// 酒店列表项
class HotelItem {
  const HotelItem({
    required this.id,
    required this.name,
    required this.star,
    required this.price,
    this.imageUrl,
    this.address,
    this.tags = const [],
    this.score,
    this.tagBadge,
    this.features = const [],
    this.discountAmount,
    /// 距离（公里），用于对比页
    this.distanceKm,
    /// 取消政策摘要，用于对比页
    this.cancellationSummary,
    /// 纬度（地图展示）
    this.latitude,
    /// 经度（地图展示）
    this.longitude,
  });

  final String id;
  final String name;
  /// 星级（3/4/5 等）
  final int star;
  final double price;
  final String? imageUrl;
  final String? address;
  final List<String> tags;
  /// 用户评分 0-5
  final double? score;
  /// 小标签：舒适 / 高端 / 热门
  final HotelTagBadge? tagBadge;
  /// 设施/服务：免费wifi、免费停车、早餐 等
  final List<String> features;
  /// 已减金额（元），用于显示「已减XX」角标
  final int? discountAmount;
  /// 距离市中心/景点公里数（对比用）
  final double? distanceKm;
  /// 取消政策摘要（对比用）
  final String? cancellationSummary;
  /// 纬度
  final double? latitude;
  /// 经度
  final double? longitude;
}

/// 酒店排序方式
enum HotelSort {
  default_,
  priceAsc,
  priceDesc,
  scoreDesc,
  starDesc,
}

/// 酒店筛选条件
class HotelFilters {
  const HotelFilters({
    this.checkIn,
    this.checkOut,
    this.priceMin,
    this.priceMax,
    this.star,
    this.sort = HotelSort.default_,
  });

  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? priceMin;
  final double? priceMax;
  /// 星级筛选：3/4/5，null 表示不限
  final int? star;
  final HotelSort sort;

  HotelFilters copyWith({
    DateTime? checkIn,
    DateTime? checkOut,
    double? priceMin,
    double? priceMax,
    int? star,
    HotelSort? sort,
  }) {
    return HotelFilters(
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      star: star ?? this.star,
      sort: sort ?? this.sort,
    );
  }
}
