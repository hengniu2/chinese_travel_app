import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../domain/order_item.dart';
import 'status_badge.dart';

// ─── 订单卡片规范：12dp 圆角、16dp 内边距、轻阴影、清晰层级 ─────────────────────
const double _kCardRadius = 12;
const double _kCardPadding = 16;
const double _kTitleSubtitleGap = 6;
const double _kSubtitlePriceGap = 10;
const double _kButtonHeight = 36;
const double _kButtonRadius = 8;
const double _kButtonPaddingH = 16;

/// 订单卡片：白底、小圆角、类型/状态角标、标题/副标题/日期、价格+圆角按钮
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_kCardRadius.r),
        child: Container(
          padding: EdgeInsets.all(_kCardPadding.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(_kCardRadius.r),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: AppShadow.light,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top row: type badge | status badge
              Row(
                children: [
                  TypeBadge(type: order.type, l10n: l10n),
                  const Spacer(),
                  StatusBadge(status: order.status, l10n: l10n),
                ],
              ),
              SizedBox(height: _kTitleSubtitleGap.h),
              // Title — 16–18sp bold #222
              Text(
                order.title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (order.subtitle != null && order.subtitle!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  order.subtitle!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: _kSubtitlePriceGap.h),
              // Date line — light gray
              Text(
                _dateInfo(l10n),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 12.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: _kSubtitlePriceGap.h),
              // Price row + action button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '¥',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.price,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        order.amount.toStringAsFixed(0),
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.price,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  if (_primaryActionLabel(l10n) != null && onPrimaryAction != null)
                    _ActionButton(
                      order: order,
                      l10n: l10n,
                      onPressed: onPrimaryAction!,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _dateInfo(AppLocalizations? l10n) {
    final dep = l10n?.orderTravelDateLabel ?? 'Departure';
    final checkIn = l10n?.orderCheckIn ?? 'Check-in';
    final checkOut = l10n?.orderCheckOut ?? 'Check-out';
    if (order.travelDate != null) return '$dep ${_formatDate(order.travelDate!)}';
    if (order.checkInDate != null && order.checkOutDate != null) {
      return '$checkIn ${_formatDate(order.checkInDate!)} – $checkOut ${_formatDate(order.checkOutDate!)}';
    }
    if (order.checkInDate != null) return '$checkIn ${_formatDate(order.checkInDate!)}';
    return '';
  }

  String? _primaryActionLabel(AppLocalizations? l10n) {
    switch (order.status) {
      case OrderStatus.pendingPayment:
        return l10n?.orderGoToPay ?? 'Pay';
      case OrderStatus.pendingTrip:
        return l10n?.orderViewDetail ?? 'View detail';
      case OrderStatus.completed:
        return l10n?.orderBookAgain ?? 'Book again';
      case OrderStatus.refund:
        return l10n?.orderViewRefund ?? 'View refund';
    }
  }
}

/// 主操作按钮：Unpaid=填充绿 / Upcoming=描边绿 / Done|Refund=浅描边
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.order,
    required this.l10n,
    required this.onPressed,
  });

  final OrderItem order;
  final AppLocalizations? l10n;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = _label();
    final isFilled = order.status == OrderStatus.pendingPayment;
    final isOutlineGreen = order.status == OrderStatus.pendingTrip;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(_kButtonRadius.r),
        child: Container(
          height: _kButtonHeight.h,
          padding: EdgeInsets.symmetric(horizontal: _kButtonPaddingH.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFilled ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(_kButtonRadius.r),
            border: Border.all(
              color: isOutlineGreen ? AppColors.primary : AppColors.border,
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.label.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isFilled ? Colors.white : (isOutlineGreen ? AppColors.primary : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  String _label() {
    switch (order.status) {
      case OrderStatus.pendingPayment:
        return l10n?.orderGoToPay ?? 'Pay';
      case OrderStatus.pendingTrip:
        return l10n?.orderViewDetail ?? 'View detail';
      case OrderStatus.completed:
        return l10n?.orderBookAgain ?? 'Book again';
      case OrderStatus.refund:
        return l10n?.orderViewRefund ?? 'View refund';
    }
  }
}
