/// 个人中心 UI 状态（订单数、收藏、优惠券、钱包、积分、会员等级、消息角标等）
/// Numeric fields are nullable to avoid "Null is not a subtype of int" when state is built from async/JSON.
class ProfileUiState {
  const ProfileUiState({
    this.ordersCount = 0,
    this.favoritesCount = 0,
    this.couponsCount = 0,
    this.couponExpiringCount = 0,
    this.walletBalance = 0.0,
    this.travelPoints = 0,
    this.membershipLevel = ProfileMembershipLevel.tourist,
    this.pendingPaymentCount = 0,
    this.upcomingCount = 0,
    this.completedCount = 0,
    this.refundCount = 0,
    this.messageUnreadCount = 0,
    this.isVerified = false,
  });

  final int? ordersCount;
  final int? favoritesCount;
  final int? couponsCount;
  final int? couponExpiringCount;
  final double? walletBalance;
  final int? travelPoints;
  final ProfileMembershipLevel membershipLevel;
  final int? pendingPaymentCount;
  final int? upcomingCount;
  final int? completedCount;
  final int? refundCount;
  final int? messageUnreadCount;
  final bool isVerified;

  ProfileUiState copyWith({
    int? ordersCount,
    int? favoritesCount,
    int? couponsCount,
    int? couponExpiringCount,
    double? walletBalance,
    int? travelPoints,
    ProfileMembershipLevel? membershipLevel,
    int? pendingPaymentCount,
    int? upcomingCount,
    int? completedCount,
    int? refundCount,
    int? messageUnreadCount,
    bool? isVerified,
  }) {
    return ProfileUiState(
      ordersCount: ordersCount ?? this.ordersCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      couponsCount: couponsCount ?? this.couponsCount,
      couponExpiringCount: couponExpiringCount ?? this.couponExpiringCount,
      walletBalance: walletBalance ?? this.walletBalance,
      travelPoints: travelPoints ?? this.travelPoints,
      membershipLevel: membershipLevel ?? this.membershipLevel,
      pendingPaymentCount: pendingPaymentCount ?? this.pendingPaymentCount,
      upcomingCount: upcomingCount ?? this.upcomingCount,
      completedCount: completedCount ?? this.completedCount,
      refundCount: refundCount ?? this.refundCount,
      messageUnreadCount: messageUnreadCount ?? this.messageUnreadCount,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}

enum ProfileMembershipLevel {
  tourist,
  member,
  gold,
}
