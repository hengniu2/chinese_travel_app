import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/order_repository_provider.dart';
import '../../domain/order_detail.dart';
import '../../domain/order_item.dart';

/// 订单详情页：订单信息、出行人信息、支付状态、退款按钮、联系客服（API 数据）
class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(orderDetailProvider(id));
    return asyncDetail.when(
      data: (detail) {
        if (detail == null) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)?.orderDetailTitle ?? '订单详情')),
            body: Center(child: Text(AppLocalizations.of(context)?.orderNoOrders ?? 'Order not found')),
          );
        }
        return _OrderDetailBody(detail: detail);
      },
      loading: () => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)?.orderDetailTitle ?? '订单详情')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)?.orderDetailTitle ?? '订单详情')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.toString(), style: AppTextStyles.bodySmall.copyWith(color: AppColors.error), textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              TextButton(onPressed: () => ref.refresh(orderDetailProvider(id)), child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({required this.detail});

  final OrderDetail detail;

  static String _formatDate(DateTime d) => '${d.month}月${d.day}日';
  static String _formatDateTime(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n?.orderDetailTitle ?? '订单详情'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOrderInfo(context),
            SizedBox(height: 16.h),
            _buildTravelers(context),
            SizedBox(height: 16.h),
            _buildPaymentStatus(context),
            SizedBox(height: 24.h),
            if (_canRefund) _buildRefundButton(context),
            if (_canRefund) SizedBox(height: 12.h),
            _buildContactService(context),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  bool get _canRefund =>
      detail.status == OrderStatus.pendingPayment ||
      detail.status == OrderStatus.pendingTrip;

  Widget _buildOrderInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final typeStr = detail.type == OrderType.tour ? (l10n?.orderTypeTour ?? '旅行团') : (l10n?.orderTypeHotel ?? '酒店');
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n?.orderInfo ?? '订单信息', style: AppTextStyles.headlineSmall),
          SizedBox(height: 12.h),
          _infoRow(l10n?.orderNo ?? '订单编号', detail.orderNo ?? detail.id),
          _infoRow(l10n?.orderType ?? '订单类型', typeStr),
          _infoRow(l10n?.orderProduct ?? '商品', detail.title),
          if (detail.subtitle != null && detail.subtitle!.isNotEmpty)
            _infoRow(l10n?.orderSpec ?? '规格', detail.subtitle!),
          if (detail.travelDate != null)
            _infoRow(l10n?.orderTravelDate ?? '出发日期', _formatDate(detail.travelDate!)),
          if (detail.checkInDate != null && detail.checkOutDate != null)
            _infoRow(l10n?.orderCheckIn ?? '入住', '${_formatDate(detail.checkInDate!)} - ${_formatDate(detail.checkOutDate!)}'),
          _infoRow(l10n?.orderCreateTime ?? '下单时间', _formatDateTime(detail.createTime)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n?.orderAmount ?? '订单金额', style: AppTextStyles.bodyMedium),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 14.sp)),
                  Text(detail.amount.toStringAsFixed(0), style: AppTextStyles.price.copyWith(fontSize: 18.sp)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80.w, child: Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildTravelers(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n?.orderTravelers ?? '出行人信息', style: AppTextStyles.headlineSmall),
          SizedBox(height: 12.h),
          ...detail.travelers.asMap().entries.map((e) {
            final i = e.key;
            final t = e.value;
            return Padding(
              padding: EdgeInsets.only(bottom: i < detail.travelers.length - 1 ? 12.h : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${i + 1}. ${t.name}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 4.h),
                  Text('身份证 ${t.idCard}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  Text('手机 ${t.phone}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n?.orderPaymentStatus ?? '支付状态', style: AppTextStyles.headlineSmall),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                detail.paymentStatus ? Icons.check_circle_rounded : Icons.schedule_rounded,
                size: 22.sp,
                color: detail.paymentStatus ? AppColors.success : AppColors.warning,
              ),
              SizedBox(width: 10.w),
              Text(
                detail.paymentStatus ? (l10n?.orderPaid ?? '已支付') : (l10n?.orderUnpaid ?? '待支付'),
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                  color: detail.paymentStatus ? AppColors.success : AppColors.warning,
                ),
              ),
            ],
          ),
          if (detail.paymentStatus && detail.payTime != null) ...[
            SizedBox(height: 8.h),
            Text('支付时间 ${_formatDateTime(detail.payTime!)}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          ],
        ],
      ),
    );
  }

  Widget _buildRefundButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppButton(
      label: l10n?.orderRefund ?? '申请退款',
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.orderRefundSubmitted ?? '已提交退款申请')));
      },
      variant: AppButtonVariant.secondary,
    );
  }

  Widget _buildContactService(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppCard(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.orderContactOpening ?? '即将打开客服')));
      },
      child: Row(
        children: [
          Icon(Icons.headset_mic_rounded, color: AppColors.primary, size: 28.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n?.orderContactService ?? '联系客服', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                SizedBox(height: 2.h),
                Text(l10n?.orderContactServiceHint ?? '订单问题可咨询在线客服', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
        ],
      ),
    );
  }
}
