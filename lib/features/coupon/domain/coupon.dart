/// Commercial coupon types for hotel/OTA booking.
enum CouponType {
  /// 满减券 — 满200减30
  threshold,
  /// 无门槛券 — 立减10元
  noThreshold,
  /// 折扣券 — 9折优惠
  discount,
  /// 限时闪促券 — 倒计时
  flash,
}

/// Single coupon: id, type, discount rules, expiry, claim/use state.
class Coupon {
  const Coupon({
    required this.id,
    required this.type,
    this.discountAmount = 0,
    this.discountRate,
    this.minSpend = 0,
    required this.expiryDate,
    this.isClaimed = false,
    this.isUsed = false,
    this.flashEndTime,
    this.title,
  })  : assert(discountAmount >= 0),
        assert(minSpend >= 0),
        assert(
          discountRate == null || (discountRate > 0 && discountRate <= 1),
          'discountRate should be in (0, 1] e.g. 0.9 for 9折',
        );

  final String id;
  final CouponType type;
  /// Face value in CNY (e.g. 30 = 减30). Used for threshold, noThreshold, flash.
  final double discountAmount;
  /// Discount rate in (0, 1] (e.g. 0.9 = 9折). Used for discount type only.
  final double? discountRate;
  /// Min order amount in CNY to use (e.g. 200 = 满200可用). 0 = no threshold.
  final double minSpend;
  final DateTime expiryDate;
  final bool isClaimed;
  final bool isUsed;
  /// For flash type: end time for countdown.
  final DateTime? flashEndTime;
  final String? title;

  bool get isExpired => DateTime.now().isAfter(expiryDate);

  /// Whether this coupon is still valid (not expired, not used).
  bool get isAvailable => !isExpired && !isUsed;

  /// Human-readable discount label (e.g. "满200减30", "立减10元", "9折").
  String discountLabel() {
    switch (type) {
      case CouponType.threshold:
        return '满${minSpend.toStringAsFixed(0)}减${discountAmount.toStringAsFixed(0)}';
      case CouponType.noThreshold:
        return '立减${discountAmount.toStringAsFixed(0)}元';
      case CouponType.discount:
        final rate = (discountRate ?? 0) * 10;
        return '${rate.toStringAsFixed(rate.truncateToDouble() == rate ? 0 : 1)}折';
      case CouponType.flash:
        return '减${discountAmount.toStringAsFixed(0)}';
    }
  }

  /// Big display value for card (e.g. "30", "10", "9折").
  String displayValue() {
    switch (type) {
      case CouponType.threshold:
      case CouponType.noThreshold:
      case CouponType.flash:
        return discountAmount.toStringAsFixed(0);
      case CouponType.discount:
        final rate = discountRate ?? 0;
        return '${(rate * 10).toStringAsFixed(rate * 10 == (rate * 10).truncate() ? 0 : 1)}折';
    }
  }

  /// Whether orderAmount satisfies minSpend.
  bool satisfiesMinSpend(double orderAmount) =>
      orderAmount >= minSpend;

  /// Compute discount in CNY for given order amount. Returns 0 if not applicable.
  double computeDiscount(double orderAmount) {
    if (!isAvailable || !satisfiesMinSpend(orderAmount)) return 0;
    switch (type) {
      case CouponType.threshold:
      case CouponType.noThreshold:
      case CouponType.flash:
        return discountAmount > orderAmount ? orderAmount : discountAmount;
      case CouponType.discount:
        final rate = discountRate ?? 0;
        return orderAmount * (1 - rate);
    }
  }

  /// Usage condition text (e.g. "满200可用", "无门槛", "有效期至 2025-03-01").
  String conditionText() {
    if (minSpend <= 0) return '无门槛';
    return '满${minSpend.toStringAsFixed(0)}可用';
  }
}
