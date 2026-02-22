/// Coupon status for list tabs.
enum CouponStatus {
  available,
  used,
  expired,
}

/// Single coupon model (mock-friendly).
class CouponModel {
  const CouponModel({
    required this.id,
    required this.amount,
    required this.minOrderAmount,
    required this.validUntil,
    required this.status,
    this.usedAt,
    this.title,
  });

  final String id;
  /// Face value in CNY (e.g. 50 = ¥50)
  final int amount;
  /// Min order amount to use (e.g. 200 = 满200可用)
  final int minOrderAmount;
  final DateTime validUntil;
  final CouponStatus status;
  final DateTime? usedAt;
  final String? title;

  bool get isAvailable => status == CouponStatus.available;
  bool get isUsed => status == CouponStatus.used;
  bool get isExpired => status == CouponStatus.expired;
}
