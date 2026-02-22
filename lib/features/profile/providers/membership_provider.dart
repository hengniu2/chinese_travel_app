import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/membership_models.dart';

/// Points: 1 point per ¥1 spent. Bonus on promotions can be applied when adding points.
const int pointsPerYuan = 1;

/// Redeem: 100 points = ¥10 discount (10:1).
const int pointsPerYuanDiscount = 10;

/// Max share of order total that can be paid with points (e.g. 20%).
const double maxRedeemPercentOfOrder = 0.2;

/// Compute discount in ¥ if user redeems [pointsToUse], without deducting. Cap by [orderTotalYuan] and points.
int computePointsDiscount(int pointsToUse, int userPoints, double orderTotalYuan) {
  if (pointsToUse <= 0 || userPoints <= 0) return 0;
  final maxByPoints = (pointsToUse.clamp(0, userPoints) / pointsPerYuanDiscount).floor();
  final maxByOrder = (orderTotalYuan * maxRedeemPercentOfOrder).floor();
  return maxByPoints.clamp(0, maxByOrder);
}

/// User membership profile (tier, points, totalSpent, expiry). Mock for now; replace with API.
final userMembershipProfileProvider =
    StateNotifierProvider<MembershipProfileNotifier, UserMembershipProfile>(
  (ref) => MembershipProfileNotifier(),
);

class MembershipProfileNotifier extends StateNotifier<UserMembershipProfile> {
  MembershipProfileNotifier()
      : super(const UserMembershipProfile(
          tier: MembershipTier.silver,
          points: 1280,
          totalSpent: 5200,
        ));

  /// After a purchase: add points (1 per ¥1 + optional bonus), add to totalSpent, check auto-upgrade.
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

  /// Deduct points and return discount in ¥ (call on payment success).
  int usePointsForDiscount(int pointsToUse, double orderTotalYuan) {
    if (pointsToUse <= 0 || state.points <= 0) return 0;
    final redeemYuan = computePointsDiscount(
      pointsToUse,
      state.points,
      orderTotalYuan,
    );
    if (redeemYuan <= 0) return 0;
    final pointsUsed = redeemYuan * pointsPerYuanDiscount;
    state = state.copyWith(points: state.points - pointsUsed);
    return redeemYuan;
  }

  int _tierIndex(MembershipTier t) {
    return MembershipTier.values.indexOf(t);
  }
}

/// Progress to next tier: current totalSpent vs next threshold (0..1).
double progressToNextTier(UserMembershipProfile profile) {
  final next = TierConfig.nextTier(profile.tier);
  if (next == null) return 1.0;
  final current = TierConfig.get(profile.tier);
  final range = next.spendThreshold - current.spendThreshold;
  if (range <= 0) return 1.0;
  final progress = (profile.totalSpent - current.spendThreshold) / range;
  return progress.clamp(0.0, 1.0);
}
