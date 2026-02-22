import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/coupon_card.dart';
import '../../domain/coupon.dart';

/// Builds [CouponCardData] from [Coupon] and l10n. Use for claim list or booking selection.
CouponCardData couponCardDataFromCoupon(
  Coupon coupon, {
  AppLocalizations? l10n,
  bool forClaim = true,
  VoidCallback? onClaim,
  VoidCallback? onSelect,
}) {
  final dateStr = DateFormat('yyyy-MM-dd').format(coupon.expiryDate);
  final validStr = l10n?.couponValidUntil(dateStr) ?? '有效期至 $dateStr';
  String? flashRemaining;
  if (coupon.type == CouponType.flash && coupon.flashEndTime != null) {
    final end = coupon.flashEndTime!;
    final diff = end.difference(DateTime.now());
    if (diff.isNegative) {
      flashRemaining = null;
    } else {
      final h = diff.inHours;
      final m = diff.inMinutes % 60;
      flashRemaining = l10n?.couponFlashRemaining('${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}') ?? '剩余 ${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    }
  }
  final isRate = coupon.type == CouponType.discount;
  return CouponCardData(
    discountDisplay: coupon.displayValue(),
    isRate: isRate,
    conditionText: coupon.conditionText(),
    expiryText: validStr,
    buttonLabel: forClaim
        ? (l10n?.couponClaimNow ?? '立即领取')
        : (l10n?.profileCouponUse ?? '去使用'),
    onButtonTap: forClaim ? onClaim : onSelect,
    isDisabled: !coupon.isAvailable || (forClaim ? coupon.isClaimed : false),
    title: coupon.title,
    flashRemaining: flashRemaining,
  );
}
