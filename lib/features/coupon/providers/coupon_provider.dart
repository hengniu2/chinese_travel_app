import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/coupon_repository.dart';
import '../data/coupon_repository_mock.dart';
import '../domain/coupon.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Repository
// ─────────────────────────────────────────────────────────────────────────────

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  return CouponRepositoryMock();
});

// ─────────────────────────────────────────────────────────────────────────────
// Claimable coupons (pool to claim)
// ─────────────────────────────────────────────────────────────────────────────

final claimableCouponsProvider = FutureProvider<List<Coupon>>((ref) async {
  final repo = ref.watch(couponRepositoryProvider);
  return repo.getClaimableCoupons();
});

// ─────────────────────────────────────────────────────────────────────────────
// My coupons (claimed, for use in booking)
// ─────────────────────────────────────────────────────────────────────────────

final myCouponsProvider = FutureProvider<List<Coupon>>((ref) async {
  final repo = ref.watch(couponRepositoryProvider);
  return repo.getMyCoupons();
});

/// Available only: not used, not expired.
final myAvailableCouponsProvider = FutureProvider<List<Coupon>>((ref) async {
  final list = await ref.watch(myCouponsProvider.future);
  return list.where((c) => c.isAvailable).toList();
});

// ─────────────────────────────────────────────────────────────────────────────
// Booking: selected coupon (scoped to current order flow)
// ─────────────────────────────────────────────────────────────────────────────

final selectedCouponForBookingProvider = StateProvider<Coupon?>((ref) => null);

/// Clear selection (e.g. when leaving order page).
void clearSelectedCoupon(Ref ref) {
  ref.read(selectedCouponForBookingProvider.notifier).state = null;
}

// ─────────────────────────────────────────────────────────────────────────────
// Apply logic & expiry validation
// ─────────────────────────────────────────────────────────────────────────────

/// Coupons that can be applied for given order amount (satisfy minSpend, not expired, not used).
List<Coupon> applicableCoupons(List<Coupon> available, double orderAmount) {
  return available
      .where((c) => c.isAvailable && c.satisfiesMinSpend(orderAmount))
      .toList();
}

/// Best coupon for order amount (max discount). Returns null if none applicable.
Coupon? getBestCoupon(List<Coupon> available, double orderAmount) {
  final applicable = applicableCoupons(available, orderAmount);
  if (applicable.isEmpty) return null;
  Coupon? best;
  double maxDiscount = 0;
  for (final c in applicable) {
    final d = c.computeDiscount(orderAmount);
    if (d > maxDiscount) {
      maxDiscount = d;
      best = c;
    }
  }
  return best;
}

/// Discount amount for selected coupon at order amount. 0 if none selected or not applicable.
double discountForSelectedCoupon(Coupon? selected, double orderAmount) {
  if (selected == null || !selected.isAvailable) return 0;
  return selected.computeDiscount(orderAmount);
}

/// Final amount after coupon. orderAmount - discount.
double finalAmountAfterCoupon(double orderAmount, Coupon? selected) {
  final discount = discountForSelectedCoupon(selected, orderAmount);
  return (orderAmount - discount).clamp(0.0, double.infinity);
}
