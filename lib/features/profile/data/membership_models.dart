/// VIP tiers: 普通会员, 黄金会员, 钻石会员
enum MembershipTier {
  normal,
  gold,
  diamond,
}

/// Config per tier: discount, free breakfast, late checkout, exclusive coupons, expiry.
class TierConfig {
  const TierConfig({
    required this.tier,
    required this.discountRate,
    this.freeBreakfast = false,
    this.lateCheckout = false,
    this.exclusiveCoupons = false,
    this.prioritySupport = false,
    required this.spendThreshold,
  });

  final MembershipTier tier;
  /// Extra discount 0..1 (e.g. 0.05 = 5% off). Applied automatically at booking.
  final double discountRate;
  final bool freeBreakfast;
  final bool lateCheckout;
  final bool exclusiveCoupons;
  final bool prioritySupport;
  final double spendThreshold;

  static const List<TierConfig> all = [
    TierConfig(tier: MembershipTier.normal, discountRate: 0, spendThreshold: 0),
    TierConfig(tier: MembershipTier.gold, discountRate: 0.05, freeBreakfast: true, lateCheckout: true, exclusiveCoupons: true, spendThreshold: 3000),
    TierConfig(tier: MembershipTier.diamond, discountRate: 0.10, freeBreakfast: true, lateCheckout: true, exclusiveCoupons: true, prioritySupport: true, spendThreshold: 15000),
  ];

  static TierConfig get(MembershipTier tier) {
    return all.firstWhere((t) => t.tier == tier, orElse: () => all.first);
  }

  static TierConfig? nextTier(MembershipTier current) {
    final idx = all.indexWhere((t) => t.tier == current);
    if (idx < 0 || idx >= all.length - 1) return null;
    return all[idx + 1];
  }
}

/// User membership: tier, points, benefits (from tier), expiry.
class UserMembershipProfile {
  const UserMembershipProfile({
    this.tier = MembershipTier.normal,
    this.points = 0,
    this.totalSpent = 0.0,
    this.tierExpiryDate,
  });

  final MembershipTier tier;
  final int points;
  final double totalSpent;
  final DateTime? tierExpiryDate;

  TierConfig get config => TierConfig.get(tier);

  bool get isVip => tier == MembershipTier.gold || tier == MembershipTier.diamond;

  UserMembershipProfile copyWith({
    MembershipTier? tier,
    int? points,
    double? totalSpent,
    DateTime? tierExpiryDate,
  }) {
    return UserMembershipProfile(
      tier: tier ?? this.tier,
      points: points ?? this.points,
      totalSpent: totalSpent ?? this.totalSpent,
      tierExpiryDate: tierExpiryDate ?? this.tierExpiryDate,
    );
  }
}
