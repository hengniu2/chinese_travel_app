/// Membership tier: Basic, Silver, Gold, VIP.
enum MembershipTier {
  basic,
  silver,
  gold,
  vip,
}

/// Config for each tier: discount, early booking, exclusive packages, priority support.
class TierConfig {
  const TierConfig({
    required this.tier,
    required this.discountRate,
    this.earlyBookingDays = 0,
    this.exclusivePackages = false,
    this.prioritySupport = false,
    required this.spendThreshold,
  });

  final MembershipTier tier;
  /// Discount rate 0..1 (e.g. 0.05 = 5% off).
  final double discountRate;
  /// Days before public for early booking.
  final int earlyBookingDays;
  final bool exclusivePackages;
  final bool prioritySupport;
  /// Total spent (¥) to reach this tier. Basic = 0.
  final double spendThreshold;

  static const List<TierConfig> all = [
    TierConfig(tier: MembershipTier.basic, discountRate: 0, spendThreshold: 0),
    TierConfig(tier: MembershipTier.silver, discountRate: 0.03, earlyBookingDays: 3, spendThreshold: 3000),
    TierConfig(tier: MembershipTier.gold, discountRate: 0.06, earlyBookingDays: 7, exclusivePackages: true, spendThreshold: 10000),
    TierConfig(tier: MembershipTier.vip, discountRate: 0.10, earlyBookingDays: 14, exclusivePackages: true, prioritySupport: true, spendThreshold: 30000),
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

/// User membership profile: tier, points, totalSpent, expiry. Used for retention & repeat purchase.
class UserMembershipProfile {
  const UserMembershipProfile({
    this.tier = MembershipTier.basic,
    this.points = 0,
    this.totalSpent = 0.0,
    this.tierExpiryDate,
  });

  final MembershipTier tier;
  final int points;
  /// Total spent in ¥ (lifetime or rolling); used for auto-upgrade.
  final double totalSpent;
  /// When current tier expires (e.g. annual review). Null = no expiry.
  final DateTime? tierExpiryDate;

  TierConfig get config => TierConfig.get(tier);

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
