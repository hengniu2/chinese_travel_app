import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/coupon_model.dart';
import 'profile_sub_page.dart';

/// Mock coupon list for each tab.
List<CouponModel> _mockAvailableCoupons() {
  final now = DateTime.now();
  return [
    CouponModel(
      id: '1',
      amount: 50,
      minOrderAmount: 200,
      validUntil: now.add(const Duration(days: 30)),
      status: CouponStatus.available,
      title: '新用户专享',
    ),
    CouponModel(
      id: '2',
      amount: 20,
      minOrderAmount: 100,
      validUntil: now.add(const Duration(days: 5)),
      status: CouponStatus.available,
      title: '出行满减',
    ),
    CouponModel(
      id: '3',
      amount: 100,
      minOrderAmount: 500,
      validUntil: now.add(const Duration(days: 60)),
      status: CouponStatus.available,
      title: '会员专享',
    ),
  ];
}

List<CouponModel> _mockUsedCoupons() {
  final now = DateTime.now();
  return [
    CouponModel(
      id: 'u1',
      amount: 30,
      minOrderAmount: 150,
      validUntil: now.add(const Duration(days: 30)),
      status: CouponStatus.used,
      usedAt: now.subtract(const Duration(days: 2)),
    ),
  ];
}

List<CouponModel> _mockExpiredCoupons() {
  final now = DateTime.now();
  return [
    CouponModel(
      id: 'e1',
      amount: 10,
      minOrderAmount: 80,
      validUntil: now.subtract(const Duration(days: 3)),
      status: CouponStatus.expired,
    ),
  ];
}

class ProfileCouponsPage extends StatelessWidget {
  const ProfileCouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.profileCoupons ?? '优惠券';
    return ProfileSubPage(
      title: title,
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.card,
              child: TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: l10n?.profileCouponTabAvailable ?? '可使用'),
                  Tab(text: l10n?.profileCouponTabUsed ?? '已使用'),
                  Tab(text: l10n?.profileCouponTabExpired ?? '已过期'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _CouponList(coupons: _mockAvailableCoupons(), l10n: l10n),
                  _CouponList(coupons: _mockUsedCoupons(), l10n: l10n),
                  _CouponList(coupons: _mockExpiredCoupons(), l10n: l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponList extends StatelessWidget {
  const _CouponList({
    required this.coupons,
    required this.l10n,
  });

  final List<CouponModel> coupons;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 64.sp,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text(
              l10n?.profileCouponEmpty ?? '暂无优惠券',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: coupons.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _CouponCard(coupon: coupons[index], l10n: l10n);
      },
    );
  }
}

class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.l10n,
  });

  final CouponModel coupon;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final isDisabled = coupon.isUsed || coupon.isExpired;
    final dateStr = DateFormat('yyyy-MM-dd').format(coupon.validUntil);
    final conditionStr = l10n?.profileCouponCondition('${coupon.minOrderAmount}') ?? '满${coupon.minOrderAmount}可用';
    final validStr = l10n?.profileCouponValidUntil(dateStr) ?? '有效期至 $dateStr';

    return Container(
      height: 100.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            // Left: amount (red/orange band in Chinese style)
            Container(
              width: 110.w,
              color: isDisabled ? AppColors.textTertiary : AppColors.price,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¥',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: isDisabled ? Colors.white70 : Colors.white,
                    ),
                  ),
                  Text(
                    '${coupon.amount}',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: isDisabled ? Colors.white70 : Colors.white,
                      height: 1.1,
                    ),
                  ),
                  if (coupon.title != null && coupon.title!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        coupon.title!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: isDisabled ? Colors.white70 : Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Right: condition + validity + button
            Expanded(
              child: Container(
                color: AppColors.card,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      conditionStr,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDisabled ? AppColors.textTertiary : AppColors.textPrimary,
                        fontSize: 15.sp,
                      ),
                    ),
                    Text(
                      validStr,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 12.sp,
                      ),
                    ),
                    if (coupon.isAvailable)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16.r),
                          child: InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n?.profileCouponUse ?? '去使用'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                              child: Text(
                                l10n?.profileCouponUse ?? '去使用',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    else if (coupon.isUsed)
                      Text(
                        l10n?.profileCouponTabUsed ?? '已使用',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 12.sp,
                        ),
                      )
                    else
                      Text(
                        l10n?.profileCouponTabExpired ?? '已过期',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 12.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
