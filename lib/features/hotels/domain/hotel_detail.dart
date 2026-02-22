/// 房型库存状态
enum RoomStockStatus {
  /// 可订
  available,
  /// 紧张（余量少）
  limited,
  /// 售罄
  soldOut,
}

/// 房型价格方案（无早餐 / 免费取消 / 不可取消 等）
class RoomPricePlan {
  const RoomPricePlan({
    required this.label,
    this.price,
  });

  final String label;
  final double? price;
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
  /// 剩余间数（紧张时显示）
  final int? remainingCount;
  final String? breakfast;
  /// 房型图片
  final String? imageUrl;
  /// 一行摘要：20平米 | 双床 | 可住2人
  final String? featuresSummary;
  /// 可展开的价格方案：无早餐、免费取消、不可取消等
  final List<RoomPricePlan> pricePlans;
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
    this.imageUrls = const [],
    this.score,
    this.tags = const [],
    this.tagBadge,
    this.policyCheckInOut,
    this.policyReception,
  });

  final String id;
  final String name;
  final int star;
  final String address;
  final String? imageUrl;
  /// 轮播图列表（优先于 imageUrl）
  final List<String> imageUrls;
  final double? score;
  final List<String> tags;
  /// 标签：舒适 / 高端 / 热门
  final String? tagBadge;
  final List<RoomType> rooms;
  final String cancellationPolicy;
  /// 入离时间说明
  final String? policyCheckInOut;
  /// 接待政策说明
  final String? policyReception;
  final List<String> facilities;
  final List<HotelReview> reviews;
}
