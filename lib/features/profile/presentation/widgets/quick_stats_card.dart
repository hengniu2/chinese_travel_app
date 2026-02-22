import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/profile_ui_state.dart';

const double _kCardRadius = 24;
const double _kPadding = 16;
const double _kOverlap = 20;

/// 浮动统计卡片：与头部重叠，软白底+阴影，圆角 24，过去尔图标+数字+标签，点击微弹
class QuickStatsCard extends StatelessWidget {
  const QuickStatsCard({
    super.key,
    required this.state,
    this.onOrders,
    this.showPlaceholder,
  });

  final ProfileUiState state;
  final VoidCallback? onOrders;
  final void Function(String name)? showPlaceholder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Transform.translate(
      offset: Offset(0, -_kOverlap.h),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: _kPadding.h, horizontal: _kPadding.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(_kCardRadius.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 4),
              blurRadius: 16,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 8),
              blurRadius: 24,
            ),
          ],
        ),
        child: Row(
          children: [
            _StatItem(
              icon: Icons.receipt_long_rounded,
              iconColor: AppColors.accentCool,
              label: l10n?.profileMyOrders ?? '我的订单',
              value: '${state.ordersCount ?? 0}',
              onTap: () {
                if (onOrders != null) {
                  onOrders!();
                } else {
                  context.push('/orders');
                }
              },
            ),
            _Divider(),
            _StatItem(
              icon: Icons.favorite_rounded,
              iconColor: const Color(0xFFE57373),
              label: l10n?.profileFavorites ?? '收藏',
              value: '${state.favoritesCount ?? 0}',
              onTap: () => showPlaceholder?.call(l10n?.profileFavorites ?? '收藏'),
            ),
            _Divider(),
            _StatItem(
              icon: Icons.confirmation_number_outlined,
              iconColor: AppColors.accentWarm,
              label: l10n?.profileCoupons ?? '优惠券',
              value: '${state.couponsCount ?? 0}',
              onTap: () => showPlaceholder?.call(l10n?.profileCoupons ?? '优惠券'),
            ),
            _Divider(),
            _StatItem(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.accentGold,
              label: l10n?.profileWallet ?? '钱包',
              value: (state.walletBalance ?? 0) > 0 ? '¥${(state.walletBalance ?? 0).toStringAsFixed(0)}' : '0',
              onTap: () => showPlaceholder?.call(l10n?.profileWallet ?? '钱包'),
            ),
            _Divider(),
            _StatItem(
              icon: Icons.stars_rounded,
              iconColor: AppColors.primary,
              label: l10n?.profilePoints ?? '积分',
              value: '${state.travelPoints ?? 0}',
              onTap: () => showPlaceholder?.call(l10n?.profilePoints ?? '积分'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppTapScale(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(icon, size: 24.sp, color: iconColor),
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 17.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40.h,
      color: AppColors.divider.withValues(alpha: 0.8),
    );
  }
}
