/// 订单状态（列表筛选用）
enum OrderStatus {
  /// 待付款
  pendingPayment,
  /// 待出行
  pendingTrip,
  /// 已完成
  completed,
  /// 退款
  refund,
}

/// 订单类型
enum OrderType {
  tour,
  hotel,
}

/// 订单列表项
class OrderItem {
  const OrderItem({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    required this.amount,
    required this.createTime,
    this.subtitle,
    this.imageUrl,
    this.travelDate,
    this.checkInDate,
    this.checkOutDate,
  });

  final String id;
  final OrderType type;
  final String title;
  final String? subtitle;
  final OrderStatus status;
  final double amount;
  final DateTime createTime;
  final String? imageUrl;
  /// 出行/出发日期（旅行团）
  final DateTime? travelDate;
  /// 入住日期（酒店）
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
}
