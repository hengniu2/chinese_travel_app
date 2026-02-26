import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/profile_ui_state.dart';
import '../theme/profile_theme.dart';

const double _kCardRadius = 24;
const double _kIconSize = 52;

/// 3️⃣ 订单状态区：标题「我的订单」+ 4 列图标（待付款/待出行/已完成/退款），带角标
class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({
    super.key,
    required this.state,
    this.onOrders,
  });

  final ProfileUiState state;
  final VoidCallback? onOrders;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            l10n?.profileMyOrders ?? 'My Orders',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: ProfileTheme.sectionTitle,
              fontSize: 17.sp,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(_kCardRadius.r),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 2),
                blurRadius: 12,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _OrderGridItem(
                  icon: Icons.receipt_long_rounded,
                  iconColor: AppColors.primary,
                  label: l10n?.profileAllOrders ?? l10n?.ordersTabAll ?? 'All',
                  count: 0,
                  onTap: () => context.push('/orders'),
                ),
              ),
              Expanded(
                child: _OrderGridItem(
                  icon: Icons.payment_rounded,
                  iconColor: AppColors.price,
                  label: l10n?.ordersTabUnpaid ?? 'Unpaid',
                  count: state.pendingPaymentCount ?? 0,
                  onTap: () => context.push('/orders?tab=unpaid'),
                ),
              ),
              Expanded(
                child: _OrderGridItem(
                  icon: Icons.luggage_rounded,
                  iconColor: AppColors.primary,
                  label: l10n?.ordersTabUpcoming ?? 'Upcoming',
                  count: state.upcomingCount ?? 0,
                  onTap: () => context.push('/orders?tab=upcoming'),
                ),
              ),
              Expanded(
                child: _OrderGridItem(
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: AppColors.iconOutlineOnLight,
                  label: l10n?.ordersTabDone ?? 'Done',
                  count: state.completedCount ?? 0,
                  onTap: () => context.push('/orders?tab=done'),
                ),
              ),
              Expanded(
                child: _OrderGridItem(
                  icon: Icons.replay_rounded,
                  iconColor: AppColors.accentWarm,
                  label: l10n?.ordersTabRefund ?? 'Refund',
                  count: state.refundCount ?? 0,
                  onTap: () => context.push('/orders?tab=refund'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OrderGridItem extends StatelessWidget {
  const _OrderGridItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: _kIconSize.w,
                height: _kIconSize.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: iconColor.withValues(alpha: 0.35), width: 1),
                ),
                child: Icon(icon, size: 26.sp, color: iconColor),
              ),
              if (count > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.price,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: ProfileTheme.label,
              fontWeight: FontWeight.w500,
              fontSize: 12.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
