import 'order_item.dart';

/// 出行人/入住人信息（订单详情用）
class OrderTraveler {
  const OrderTraveler({
    required this.name,
    required this.idCard,
    required this.phone,
  });

  final String name;
  final String idCard;
  final String phone;
}

/// 订单详情
class OrderDetail {
  const OrderDetail({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    required this.amount,
    required this.createTime,
    required this.travelers,
    required this.paymentStatus,
    this.subtitle,
    this.travelDate,
    this.checkInDate,
    this.checkOutDate,
    this.payTime,
    this.orderNo,
  });

  final String id;
  final OrderType type;
  final String title;
  final String? subtitle;
  final OrderStatus status;
  final double amount;
  final DateTime createTime;
  final List<OrderTraveler> travelers;
  /// 是否已支付
  final bool paymentStatus;
  final DateTime? payTime;
  final String? orderNo;
  final DateTime? travelDate;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
}
