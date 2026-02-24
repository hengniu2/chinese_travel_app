import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../data/companion_detail_mock.dart';
import '../models/companion_detail.dart';
import '../models/companion_order.dart';
import '../widgets/price_summary_card.dart';

/// 预约陪游 — 结构：AppBar + 可滚动区块 + 底部固定确认按钮
class CompanionBookingPage extends StatefulWidget {
  const CompanionBookingPage({super.key, required this.companionId, this.packageIndex});

  final String companionId;
  final int? packageIndex;

  @override
  State<CompanionBookingPage> createState() => _CompanionBookingPageState();
}

class _CompanionBookingPageState extends State<CompanionBookingPage> {
  late CompanionDetail _detail;
  DateTime? _selectedDate;
  int _selectedPackageIndex = 0;
  int _selectedDurationIndex = 0; // 0=4h, 1=8h, 2=全天
  final List<bool> _extraSelected = [false, false, false];
  static const List<String> _durationLabels = ['4小时', '8小时', '全天'];
  static const List<String> _extraLabels = ['摄影服务', '接机服务', '夜间加时'];
  static const List<double> _extraPrices = [100, 150, 200];
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detail = getCompanionDetail(widget.companionId);
    if (widget.packageIndex != null && widget.packageIndex! < _detail.packages.length) {
      _selectedPackageIndex = widget.packageIndex!;
      _selectedDurationIndex = widget.packageIndex!.clamp(0, 2);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  double get _basePricePerDay {
    if (_detail.packages.isEmpty) return 0;
    final i = _detail.packages.length > 1 ? 1 : 0;
    return _detail.packages[i].price;
  }

  double get _durationMultiplier {
    switch (_selectedDurationIndex) {
      case 0: return 0.6;
      case 1: return 1.0;
      case 2: return 1.5;
      default: return 1.0;
    }
  }

  double get _serviceFee => _basePricePerDay * _durationMultiplier;

  double get _extrasPrice {
    double sum = 0;
    for (var i = 0; i < _extraSelected.length && i < _extraPrices.length; i++) {
      if (_extraSelected[i]) sum += _extraPrices[i];
    }
    return sum;
  }

  static const double _platformFeeRate = 0.03;
  double get _platformFee {
    final subtotal = _serviceFee + _extrasPrice;
    return subtotal * _platformFeeRate;
  }

  double get _totalPrice => _serviceFee + _extrasPrice + _platformFee;

  static const double _stickyBarHeight = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('预约陪游'),
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
                24.h + _stickyBarHeight + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCompanionSummary(),
                  _sectionGap(),
                  _buildDateSelector(),
                  _sectionGap(),
                  _buildDurationSelector(),
                  _sectionGap(),
                  _buildExtraServicesSelector(),
                  _sectionGap(),
                  _buildNotesInput(),
                  _sectionGap(),
                  _buildPriceSummary(),
                  _sectionGap(),
                  _buildConfirmButtonInScroll(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          _buildStickyConfirmButton(),
        ],
      ),
    );
  }

  Widget _sectionGap() => SizedBox(height: 20.h);

  Widget _buildCompanionSummary() {
    final rating = _detail.rating ??
        (_detail.reviews.isEmpty ? 0.0 : _detail.reviews.map((e) => e.rating).reduce((a, b) => a + b) / _detail.reviews.length);
    final pricePerDay = _basePricePerDay;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.surface,
            backgroundImage: _detail.avatar.isNotEmpty ? NetworkImage(_detail.avatar) : null,
            child: _detail.avatar.isEmpty ? Icon(Icons.person_rounded, color: AppColors.textTertiary, size: 28.sp) : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
          Text(
            '¥${pricePerDay.toStringAsFixed(0)}/天',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final today = DateTime.now();
    const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('选择日期'),
        SizedBox(height: 10.h),
        SizedBox(
          height: 64.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, i) {
              final d = today.add(Duration(days: i));
              final selected = _selectedDate != null &&
                  _selectedDate!.year == d.year &&
                  _selectedDate!.month == d.month &&
                  _selectedDate!.day == d.day;
              return GestureDetector(
                onTap: () => setState(() => _selectedDate = d),
                child: Container(
                  width: 56.w,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.card,
                    borderRadius: BorderRadius.circular(10),
                    border: selected ? null : Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekdays[d.weekday - 1],
                        style: AppTextStyles.overline.copyWith(
                          color: selected ? Colors.white : AppColors.textSecondary,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${d.day}',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: selected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('服务时长'),
        SizedBox(height: 10.h),
        Row(
          children: [
            for (var i = 0; i < _durationLabels.length; i++) ...[
              if (i > 0) SizedBox(width: 10.w),
              Expanded(
                child: _DurationPill(
                  label: _durationLabels[i],
                  selected: i == _selectedDurationIndex,
                  onTap: () => setState(() {
                    _selectedDurationIndex = i;
                    _selectedPackageIndex = i.clamp(0, _detail.packages.length - 1);
                  }),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildExtraServicesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('增值服务'),
        SizedBox(height: 10.h),
        ...List.generate(
          _extraLabels.length,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: InkWell(
              onTap: () => setState(() => _extraSelected[i] = !_extraSelected[i]),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: Checkbox(
                      value: _extraSelected[i],
                      onChanged: (v) => setState(() => _extraSelected[i] = v ?? false),
                      activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      _extraLabels[i],
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '+${_extraPrices[i].toInt()}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('备注'),
        SizedBox(height: 10.h),
        TextField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '选填，如集合地点、特殊需求等',
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildPriceSummary() {
    return PriceSummaryCard(
      title: '费用明细',
      rows: [
        PriceSummaryRow(label: '服务费', amount: _serviceFee),
        PriceSummaryRow(label: '附加费用', amount: _extrasPrice),
        PriceSummaryRow(label: '平台服务费', amount: _platformFee),
        PriceSummaryRow(label: '总计', amount: _totalPrice, isTotal: true),
      ],
    );
  }

  Widget _buildConfirmButtonInScroll() {
    return SizedBox(
      height: 48.h,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text('确认预约'),
      ),
    );
  }

  Widget _buildStickyConfirmButton() {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      height: _stickyBarHeight + bottomPadding,
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
          height: _stickyBarHeight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¥${_totalPrice.toStringAsFixed(0)}',
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '总计',
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                SizedBox(
                  height: 48.h,
                  width: 160.w,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _submit,
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
                          '提交预约',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: AppTextStyles.titleSmall.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _submit() {
    if (widget.companionId.isEmpty) return;
    final payload = CompanionOrderConfirmPayload(
      companionId: widget.companionId,
      selectedDate: _selectedDate,
      durationIndex: _selectedDurationIndex,
      durationLabel: _durationLabels[_selectedDurationIndex.clamp(0, _durationLabels.length - 1)],
      extraLabels: List.from(_extraLabels),
      extraSelected: List.from(_extraSelected),
      extraPrices: List.from(_extraPrices),
      serviceFee: _serviceFee,
      extrasPrice: _extrasPrice,
      platformFee: _platformFee,
      totalPrice: _totalPrice,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );
    context.push('/companions/${widget.companionId}/order/confirm', extra: payload);
  }
}

class _DurationPill extends StatelessWidget {
  const _DurationPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
