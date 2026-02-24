import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/membership_models.dart';

const int pointsPerYuan = 1;
const int pointsPerYuanDiscount = 10;
const double maxRedeemPercentOfOrder = 0.2;

int computePointsDiscount(int pointsToUse, int userPoints, double orderTotalYuan) {
  if (pointsToUse <= 0 || userPoints <= 0) return 0;
  final maxByPoints = (pointsToUse.clamp(0, userPoints) / pointsPerYuanDiscount).floor();
  final maxByOrder = (orderTotalYuan * maxRedeemPercentOfOrder).floor();
  return maxByPoints.clamp(0, maxByOrder);
}

/// VIP discount in ¥ for a given order subtotal (before coupon). Applied automatically at booking.
double computeVipDiscount(UserMembershipProfile profile, double orderSubtotalYuan) {
  if (profile.config.discountRate <= 0) return 0;
  return (orderSubtotalYuan * profile.config.discountRate).roundToDouble();
}

final userMembershipProfileProvider =
    StateNotifierProvider<MembershipProfileNotifier, UserMembershipProfile>(
  (ref) => MembershipProfileNotifier(),
);

class MembershipProfileNotifier extends StateNotifier<UserMembershipProfile> {
  MembershipProfileNotifier()
      : super(const UserMembershipProfile(
          tier: MembershipTier.gold,
          points: 1280,
          totalSpent: 5200,
          tierExpiryDate: null,
        ));

  void onPurchaseCompleted(double amountYuan, {int bonusPoints = 0}) {
    final pointsEarned = (amountYuan * pointsPerYuan).floor() + bonusPoints;
    var newTotalSpent = state.totalSpent + amountYuan;
    var newPoints = state.points + pointsEarned;
    var newTier = state.tier;
    for (final config in TierConfig.all) {
      if (newTotalSpent >= config.spendThreshold &&
          _tierIndex(config.tier) > _tierIndex(newTier)) {
        newTier = config.tier;
      }
    }
    state = state.copyWith(
      points: newPoints,
      totalSpent: newTotalSpent,
      tier: newTier,
    );
  }

  int usePointsForDiscount(int pointsToUse, double orderTotalYuan) {
    if (pointsToUse <= 0 || state.points <= 0) return 0;
    final redeemYuan = computePointsDiscount(
      pointsToUse,
      state.points,
      orderTotalYuan,
    );
    if (redeemYuan <= 0) return 0;
    final pointsUsed = (redeemYuan * pointsPerYuanDiscount).round();
    state = state.copyWith(points: state.points - pointsUsed);
    return redeemYuan;
  }

  int _tierIndex(MembershipTier t) => MembershipTier.values.indexOf(t);
}

double progressToNextTier(UserMembershipProfile profile) {
  final next = TierConfig.nextTier(profile.tier);
  if (next == null) return 1.0;
  final current = TierConfig.get(profile.tier);
  final range = next.spendThreshold - current.spendThreshold;
  if (range <= 0) return 1.0;
  final progress = (profile.totalSpent - current.spendThreshold) / range;
  return progress.clamp(0.0, 1.0);
}
