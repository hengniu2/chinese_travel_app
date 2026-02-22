import '../domain/coupon.dart';

/// Fetches claimable coupons, user's coupons, and performs claim/use.
abstract class CouponRepository {
  /// Coupons available to claim (not yet claimed).
  Future<List<Coupon>> getClaimableCoupons();

  /// User's claimed coupons (available + used + expired).
  Future<List<Coupon>> getMyCoupons();

  /// Claim a coupon by id. Returns updated coupon or throws.
  Future<Coupon> claimCoupon(String couponId);

  /// Mark coupon as used (e.g. after payment).
  Future<void> markCouponUsed(String couponId);
}
