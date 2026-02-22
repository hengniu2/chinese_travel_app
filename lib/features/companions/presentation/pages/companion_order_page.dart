import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../data/companion_detail_mock.dart';
import '../../domain/companion_detail.dart';

/// 预约陪游 — 结构：AppBar + 可滚动区块 + 底部固定确认按钮
class CompanionOrderPage extends StatefulWidget {
  const CompanionOrderPage({super.key, required this.companionId, this.packageIndex});

  final String companionId;
  final int? packageIndex;

  @override
  State<CompanionOrderPage> createState() => _CompanionOrderPageState();
}

class _CompanionOrderPageState extends State<CompanionOrderPage> {
  late CompanionDetail _detail;
  DateTime? _selectedDate;
  int _selectedPackageIndex = 0;
  final List<bool> _extraSelected = [false, false, false];
  static const List<String> _extraLabels = ['接机/送机', '专业摄影', '多语言讲解'];
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _detail = getCompanionDetail(widget.companionId);
    if (widget.packageIndex != null && widget.packageIndex! < _detail.packages.length) {
      _selectedPackageIndex = widget.packageIndex!;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  CompanionPackage get _selectedPackage => _detail.packages[_selectedPackageIndex];

  double get _extrasPrice {
    double sum = 0;
    // placeholder prices for extras
    const prices = [50.0, 80.0, 30.0];
    for (var i = 0; i < _extraSelected.length && i < prices.length; i++) {
      if (_extraSelected[i]) sum += prices[i];
    }
    return sum;
  }

  double get _totalPrice => _selectedPackage.price + _extrasPrice;

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
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
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

  /// 1. Selected companion summary card
  Widget _buildCompanionSummary() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: AppColors.surface,
            backgroundImage: _detail.avatar.isNotEmpty ? NetworkImage(_detail.avatar) : null,
            child: _detail.avatar.isEmpty ? Icon(Icons.person_rounded, color: AppColors.textTertiary) : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _detail.name,
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${_detail.city} · ${_detail.age}岁',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 2. Date selector
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

  /// 3. Duration selector (packages)
  Widget _buildDurationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('服务时长'),
        SizedBox(height: 10.h),
        ...List.generate(
          _detail.packages.length,
          (i) {
            final p = _detail.packages[i];
            final selected = i == _selectedPackageIndex;
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: InkWell(
                onTap: () => setState(() => _selectedPackageIndex = i),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.card,
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              p.name,
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (p.desc.isNotEmpty) ...[
                              SizedBox(height: 2.h),
                              Text(
                                p.desc,
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        '¥${p.price.toStringAsFixed(0)}${p.unit}',
                        style: AppTextStyles.bodyMedium.copyWith(
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
            );
          },
        ),
      ],
    );
  }

  /// 4. Extra services selector
  Widget _buildExtraServicesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('增值服务'),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: List.generate(
            _extraLabels.length,
            (i) => FilterChip(
              selected: _extraSelected[i],
              onSelected: (v) => setState(() => _extraSelected[i] = v),
              label: Text(_extraLabels[i], style: AppTextStyles.bodySmall),
              selectedColor: AppColors.primaryPale,
              checkmarkColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  /// 5. Notes input
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

  /// 6. Price summary
  Widget _buildPriceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle('费用明细'),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _priceRow('陪游服务', _selectedPackage.price),
              if (_extrasPrice > 0) ...[
                SizedBox(height: 8.h),
                _priceRow('增值服务', _extrasPrice),
              ],
              Divider(height: 20.h, color: AppColors.divider),
              _priceRow('合计', _totalPrice, isTotal: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)
              : AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '¥${amount.toStringAsFixed(0)}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// 7. Confirm button (in scroll)
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

  /// Sticky bottom confirm button
  Widget _buildStickyConfirmButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
        child: SizedBox(
          height: 48.h,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('确认预约 · ¥${_totalPrice.toStringAsFixed(0)}'),
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
    // TODO: validate (e.g. date selected) and navigate to success or show error
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('预约成功')));
    context.pop();
  }
}
