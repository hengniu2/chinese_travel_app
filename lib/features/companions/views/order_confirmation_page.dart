import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../data/companion_detail_mock.dart';
import '../models/companion_detail.dart';
import '../models/companion_order.dart';
import '../widgets/price_summary_card.dart';

/// 订单确认 — 陪游信息、日期时长、增值服务、费用明细、支付方式、确认支付
class CompanionOrderConfirmPage extends StatefulWidget {
  const CompanionOrderConfirmPage({super.key, required this.payload});

  final CompanionOrderConfirmPayload payload;

  @override
  State<CompanionOrderConfirmPage> createState() => _CompanionOrderConfirmPageState();
}

class _CompanionOrderConfirmPageState extends State<CompanionOrderConfirmPage> {
  late CompanionDetail _detail;
  int _selectedPaymentIndex = 0;

  static const List<String> _paymentLabels = ['微信支付', '支付宝', '银行卡'];
  static const List<IconData> _paymentIcons = [
    Icons.chat_bubble_outline_rounded,
    Icons.account_balance_wallet_outlined,
    Icons.credit_card_rounded,
  ];

  static const double _barHeight = 72;

  @override
  void initState() {
    super.initState();
    _detail = getCompanionDetail(widget.payload.companionId);
  }

  String get _dateText {
    final d = widget.payload.selectedDate;
    if (d == null) return '—';
    const w = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return '${d.month}月${d.day}日 ${w[d.weekday - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('订单确认'),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                16.w,
                16.h,
                16.w,
                24.h + _barHeight + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCompanionSection(),
                  _sectionGap(),
                  _buildDateDurationSection(),
                  _sectionGap(),
                  _buildExtrasSection(),
                  _sectionGap(),
                  _buildPriceSection(),
                  _sectionGap(),
                  _buildPaymentSection(),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _sectionGap() => SizedBox(height: 16.h);

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text,
        style: AppTextStyles.titleSmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _buildCompanionSection() {
    final rating = _detail.rating ??
        (_detail.reviews.isEmpty ? 0.0 : _detail.reviews.map((e) => e.rating).reduce((a, b) => a + b) / _detail.reviews.length);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('陪游信息'),
        _card(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28.r,
                  backgroundColor: AppColors.surface,
                  backgroundImage: _detail.avatar.isNotEmpty ? NetworkImage(_detail.avatar) : null,
                  child: _detail.avatar.isEmpty ? Icon(Icons.person_rounded, color: AppColors.textTertiary, size: 28.sp) : null,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _detail.name,
                        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _detail.city,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 14.sp, color: AppColors.accentGold),
                          SizedBox(width: 4.w),
                          Text(
                            rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateDurationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('预约信息'),
        _card(
          children: [
            _infoRow('预约日期', _dateText),
            SizedBox(height: 8.h),
            _infoRow('服务时长', widget.payload.durationLabel),
          ],
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72.w,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildExtrasSection() {
    final selected = <String>[];
    for (var i = 0; i < widget.payload.extraSelected.length && i < widget.payload.extraLabels.length; i++) {
      if (widget.payload.extraSelected[i]) {
        selected.add('${widget.payload.extraLabels[i]} +¥${widget.payload.extraPrices[i].toInt()}');
      }
    }
    final text = selected.isEmpty ? '无' : selected.join('、');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('增值服务'),
        _card(
          children: [
            Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    final p = widget.payload;
    return PriceSummaryCard(
      title: '费用明细',
      rows: [
        PriceSummaryRow(label: '服务费', amount: p.serviceFee),
        PriceSummaryRow(label: '附加费用', amount: p.extrasPrice),
        PriceSummaryRow(label: '平台服务费', amount: p.platformFee),
        PriceSummaryRow(label: '总计', amount: p.totalPrice, isTotal: true),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('支付方式'),
        ...List.generate(
          _paymentLabels.length,
          (i) {
            final selected = i == _selectedPaymentIndex;
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: InkWell(
                onTap: () => setState(() => _selectedPaymentIndex = i),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                      width: selected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected ? Icons.radio_button_checked : Icons.radio_button_off_rounded,
                        size: 22.sp,
                        color: selected ? AppColors.primary : AppColors.textTertiary,
                      ),
                      SizedBox(width: 12.w),
                      Icon(_paymentIcons[i], size: 22.sp, color: selected ? AppColors.primary : AppColors.textSecondary),
                      SizedBox(width: 12.w),
                      Text(
                        _paymentLabels[i],
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48.h,
          width: double.infinity,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _confirmPay,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: AppGradients.brand,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  '确认支付',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmPay() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('支付成功')));
    context.pop();
    context.pop();
  }
}
