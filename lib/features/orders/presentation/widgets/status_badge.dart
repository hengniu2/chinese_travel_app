import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/app_radius.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../domain/order_item.dart';

/// 订单状态角标：待付款(红)、待出行(绿)、已完成/退款(灰)
/// 8dp 圆角，16dp 水平内边距，与设计语言一致
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.l10n,
  });

  final OrderStatus status;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final l10n = this.l10n ?? AppLocalizations.of(context);
    final label = _label(l10n);
    final color = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.smallRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.overline.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  String _label(AppLocalizations? l10n) {
    switch (status) {
      case OrderStatus.pendingPayment:
        return l10n?.ordersTabUnpaid ?? '待付款';
      case OrderStatus.pendingTrip:
        return l10n?.ordersTabUpcoming ?? '待出行';
      case OrderStatus.completed:
        return l10n?.ordersTabDone ?? '已完成';
      case OrderStatus.refund:
        return l10n?.ordersTabRefund ?? '退款';
    }
  }

  Color _color() {
    switch (status) {
      case OrderStatus.pendingPayment:
        return AppColors.price;
      case OrderStatus.pendingTrip:
        return AppColors.primary;
      case OrderStatus.completed:
      case OrderStatus.refund:
        return AppColors.textSecondary;
    }
  }
}

/// 订单类型角标：Tour 浅绿 / Hotel 浅蓝，小圆角 pill
class TypeBadge extends StatelessWidget {
  const TypeBadge({
    super.key,
    required this.type,
    this.l10n,
  });

  final OrderType type;
  final AppLocalizations? l10n;

  @override
  Widget build(BuildContext context) {
    final l10n = this.l10n ?? AppLocalizations.of(context);
    final label = type == OrderType.tour
        ? (l10n?.orderTypeTour ?? 'Tour')
        : (l10n?.orderTypeHotel ?? 'Hotel');
    final color = type == OrderType.tour ? AppColors.primary : AppColors.accentCool;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.smallRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.overline.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
