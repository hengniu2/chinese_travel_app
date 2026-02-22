import '../domain/coupon.dart';
import 'coupon_repository.dart';

/// In-memory mock: claimable pool + user's claimed list.
class CouponRepositoryMock implements CouponRepository {
  CouponRepositoryMock() {
    _claimable = _buildClaimable();
    _myCoupons = _buildPreClaimed();
  }

  static List<Coupon> _buildPreClaimed() {
    final now = DateTime.now();
    return [
      Coupon(
        id: 'claim_1',
        type: CouponType.threshold,
        discountAmount: 30,
        minSpend: 200,
        expiryDate: now.add(const Duration(days: 30)),
        isClaimed: true,
        title: '新用户专享',
      ),
      Coupon(
        id: 'claim_3',
        type: CouponType.noThreshold,
        discountAmount: 10,
        minSpend: 0,
        expiryDate: now.add(const Duration(days: 7)),
        isClaimed: true,
        title: '无门槛立减',
      ),
    ];
  }

  late List<Coupon> _claimable;
  late List<Coupon> _myCoupons;

  static List<Coupon> _buildClaimable() {
    final now = DateTime.now();
    return [
      Coupon(
        id: 'claim_1',
        type: CouponType.threshold,
        discountAmount: 30,
        minSpend: 200,
        expiryDate: now.add(const Duration(days: 30)),
        title: '新用户专享',
      ),
      Coupon(
        id: 'claim_2',
        type: CouponType.threshold,
        discountAmount: 80,
        minSpend: 500,
        expiryDate: now.add(const Duration(days: 14)),
        title: '会员满减',
      ),
      Coupon(
        id: 'claim_3',
        type: CouponType.noThreshold,
        discountAmount: 10,
        minSpend: 0,
        expiryDate: now.add(const Duration(days: 7)),
        title: '无门槛立减',
      ),
      Coupon(
        id: 'claim_4',
        type: CouponType.discount,
        discountRate: 0.9,
        minSpend: 100,
        expiryDate: now.add(const Duration(days: 21)),
        title: '9折优惠',
      ),
      Coupon(
        id: 'claim_5',
        type: CouponType.flash,
        discountAmount: 50,
        minSpend: 300,
        expiryDate: now.add(const Duration(days: 2)),
        flashEndTime: now.add(const Duration(hours: 23)),
        title: '限时闪促',
      ),
    ];
  }

  @override
  Future<List<Coupon>> getClaimableCoupons() async {
    final claimedIds = _myCoupons.map((c) => c.id).toSet();
    return _claimable
        .where((c) => !claimedIds.contains(c.id))
        .where((c) => !c.isExpired)
        .toList();
  }

  @override
  Future<List<Coupon>> getMyCoupons() async => List.from(_myCoupons);

  @override
  Future<Coupon> claimCoupon(String couponId) async {
    final list = _claimable.where((x) => x.id == couponId).toList();
    if (list.isEmpty) throw Exception('Coupon not found: $couponId');
    final c = list.first;
    final claimed = Coupon(
      id: c.id,
      type: c.type,
      discountAmount: c.discountAmount,
      discountRate: c.discountRate,
      minSpend: c.minSpend,
      expiryDate: c.expiryDate,
      isClaimed: true,
      isUsed: false,
      flashEndTime: c.flashEndTime,
      title: c.title,
    );
    _myCoupons.add(claimed);
    return claimed;
  }

  @override
  Future<void> markCouponUsed(String couponId) async {
    final i = _myCoupons.indexWhere((c) => c.id == couponId);
    if (i < 0) return;
    final c = _myCoupons[i];
    _myCoupons[i] = Coupon(
      id: c.id,
      type: c.type,
      discountAmount: c.discountAmount,
      discountRate: c.discountRate,
      minSpend: c.minSpend,
      expiryDate: c.expiryDate,
      isClaimed: c.isClaimed,
      isUsed: true,
      flashEndTime: c.flashEndTime,
      title: c.title,
    );
  }
}
