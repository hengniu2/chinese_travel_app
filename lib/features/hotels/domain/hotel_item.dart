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
