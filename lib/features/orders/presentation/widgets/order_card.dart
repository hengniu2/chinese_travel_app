import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../domain/order_item.dart';

/// 订单卡片
class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onPrimaryAction,
  });

  final OrderItem order;
  final VoidCallback? onTap;
  final VoidCallback? onPrimaryAction;

  static String _formatDate(DateTime d) => '${d.month}月${d.day}日';
  static String _formatDateTime(DateTime d) => '${d.month}-${d.day} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: AppRadius.cardRadius,
            boxShadow: [
              ...AppShadow.card,
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _typeChip(context, l10n),
                        const Spacer(),
                        _statusChip(context, l10n),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      order.title,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (order.subtitle != null && order.subtitle!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        order.subtitle!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 8.h),
                    Text(
                      _dateInfo(l10n),
                      style: AppTextStyles.label.copyWith(color: AppColors.textTertiary),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 12.sp)),
                            Text(
                              order.amount.toStringAsFixed(0),
                              style: AppTextStyles.price.copyWith(fontSize: 18.sp),
                            ),
                          ],
                        ),
                        if (_primaryActionLabel(l10n) != null && onPrimaryAction != null)
                          TextButton(
                            onPressed: onPrimaryAction,
                            child: Text(_primaryActionLabel(l10n)!),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                child: Text(
                  '${l10n?.orderCreateTime ?? '下单时间'} ${_formatDateTime(order.createTime)}',
                  style: AppTextStyles.label.copyWith(color: AppColors.textTertiary, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeChip(BuildContext context, AppLocalizations? l10n) {
    final label = order.type == OrderType.tour ? (l10n?.orderTypeTour ?? '旅行团') : (l10n?.orderTypeHotel ?? '酒店');
    final color = order.type == OrderType.tour ? AppColors.primary : AppColors.info;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.smRadius,
      ),
      child: Text(label, style: AppTextStyles.label.copyWith(color: color, fontSize: 11.sp)),
    );
  }

  Widget _statusChip(BuildContext context, AppLocalizations? l10n) {
    String label;
    Color color;
    switch (order.status) {
      case OrderStatus.pendingPayment:
        label = l10n?.ordersTabUnpaid ?? '待付款';
        color = AppColors.price;
        break;
      case OrderStatus.pendingTrip:
        label = l10n?.ordersTabUpcoming ?? '待出行';
        color = AppColors.primary;
        break;
      case OrderStatus.completed:
        label = l10n?.ordersTabDone ?? '已完成';
        color = AppColors.textSecondary;
        break;
      case OrderStatus.refund:
        label = l10n?.ordersTabRefund ?? '退款';
        color = AppColors.textTertiary;
        break;
    }
    return Text(label, style: AppTextStyles.label.copyWith(color: color, fontWeight: FontWeight.w500));
  }

  String _dateInfo(AppLocalizations? l10n) {
    final dep = l10n?.orderTravelDateLabel ?? '出发日期';
    final checkIn = l10n?.orderCheckIn ?? '入住';
    final checkOut = l10n?.orderCheckOut ?? '退房';
    if (order.travelDate != null) return '$dep ${_formatDate(order.travelDate!)}';
    if (order.checkInDate != null && order.checkOutDate != null) {
      return '$checkIn ${_formatDate(order.checkInDate!)} - $checkOut ${_formatDate(order.checkOutDate!)}';
    }
    if (order.checkInDate != null) return '$checkIn ${_formatDate(order.checkInDate!)}';
    return '';
  }

  String? _primaryActionLabel(AppLocalizations? l10n) {
    switch (order.status) {
      case OrderStatus.pendingPayment:
        return l10n?.orderGoToPay ?? '去支付';
      case OrderStatus.pendingTrip:
        return l10n?.orderViewDetail ?? '查看详情';
      case OrderStatus.completed:
        return l10n?.orderBookAgain ?? '再次预订';
      case OrderStatus.refund:
        return l10n?.orderViewRefund ?? '查看退款';
    }
  }
}
