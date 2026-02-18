/// 房型库存状态
enum RoomStockStatus {
  /// 可订
  available,
  /// 紧张（余量少）
  limited,
  /// 售罄
  soldOut,
}

/// 房型
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
  });

  final String id;
  final String name;
  final double price;
  final RoomStockStatus stockStatus;
  final String? bedInfo;
  final String? area;
  /// 剩余间数（紧张时显示）
  final int? remainingCount;
  final String? breakfast;
}

/// 酒店评价
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

/// 酒店详情
class HotelDetail {
  const HotelDetail({
    required this.id,
    required this.name,
    required this.star,
    required this.address,
    required this.rooms,
    required this.cancellationPolicy,
    required this.facilities,
    required this.reviews,
    this.imageUrl,
    this.score,
    this.tags = const [],
  });

  final String id;
  final String name;
  final int star;
  final String address;
  final String? imageUrl;
  final double? score;
  final List<String> tags;
  final List<RoomType> rooms;
  final String cancellationPolicy;
  final List<String> facilities;
  final List<HotelReview> reviews;
}
