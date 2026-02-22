/// Canonical hotel model for list & detail, API-ready.
class Hotel {
  const Hotel({
    required this.id,
    required this.name,
    required this.rating,
    required this.price,
    this.images = const [],
    this.tags = const [],
    this.location = '',
    this.facilities = const [],
    this.rooms = const [],
    this.star,
    this.tagBadge,
    this.discountAmount,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String name;
  /// 0-5 or display score (e.g. 4.8)
  final double rating;
  /// Starting price (lowest room price)
  final double price;
  final List<String> images;
  final List<String> tags;
  /// Address or area name
  final String location;
  final List<String> facilities;
  final List<Room> rooms;
  /// Star rating 3/4/5 (optional)
  final int? star;
  /// 舒适 / 高端 / 热门
  final String? tagBadge;
  /// Discount amount in yuan for "已减XX"
  final int? discountAmount;
  final double? latitude;
  final double? longitude;
}

/// Canonical room model, API-ready.
class Room {
  const Room({
    required this.id,
    required this.name,
    this.size,
    this.bedType,
    this.capacity = 2,
    required this.price,
    this.cancellationPolicy = '',
    this.breakfastIncluded = false,
    this.isRefundable = true,
    this.imageUrl,
  });

  final String id;
  final String name;
  /// e.g. "20平米"
  final String? size;
  /// e.g. "双床", "大床"
  final String? bedType;
  final int capacity;
  final double price;
  /// Free-text or "限时免费取消" / "不可取消"
  final String cancellationPolicy;
  final bool breakfastIncluded;
  final bool isRefundable;
  final String? imageUrl;
}
