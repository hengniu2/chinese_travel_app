// Room and detail-related models — API-ready, used by repository and UI.

/// Canonical room model for list/detail (API payload).
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
  final String? size;
  final String? bedType;
  final int capacity;
  final double price;
  final String cancellationPolicy;
  final bool breakfastIncluded;
  final bool isRefundable;
  final String? imageUrl;
}

/// Room stock status for detail UI.
enum RoomStockStatus {
  available,
  limited,
  soldOut,
}

/// Price plan option (no breakfast / free cancel / non-refundable).
class RoomPricePlan {
  const RoomPricePlan({
    required this.label,
    this.price,
  });

  final String label;
  final double? price;
}

/// Room type for detail page (derived from Room or API).
class RoomType {
  const RoomType({
    required this.id,
    required this.name,
    required this.price,
    required this.stockStatus,
    this.bedInfo,
    this.area,
    this.remainingCount,
    this.breakfast,
    this.imageUrl,
    this.featuresSummary,
    this.pricePlans = const [],
  });

  final String id;
  final String name;
  final double price;
  final RoomStockStatus stockStatus;
  final String? bedInfo;
  final String? area;
  final int? remainingCount;
  final String? breakfast;
  final String? imageUrl;
  final String? featuresSummary;
  final List<RoomPricePlan> pricePlans;
}

/// Hotel review for detail page.
class HotelReview {
  const HotelReview({
    required this.userName,
    required this.rating,
    required this.content,
    required this.date,
    this.roomName,
  });

  final String userName;
  final double rating;
  final String content;
  final String date;
  final String? roomName;
}
