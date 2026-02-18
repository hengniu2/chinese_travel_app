import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../auth/presentation/widgets/auth_agreement_checkbox.dart';
import '../widgets/traveler_form_card.dart';
import '../../data/companion_detail_mock.dart';
import '../../domain/companion_detail.dart';
import '../../domain/companion_order.dart';

/// 陪游下单页（8 步：日期→套餐→备注→随行人员信息×N→协议→提交）
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
  final _remarkController = TextEditingController();
  List<TravelerInfo> _travelers = [TravelerInfo()];
  bool _agreed = false;
  bool _submitting = false;
  String? _error;

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
    _remarkController.dispose();
    super.dispose();
  }

  CompanionPackage get _selectedPackage => _detail.packages[_selectedPackageIndex];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _addTraveler() {
    setState(() => _travelers.add(TravelerInfo()));
  }

  void _removeTraveler(int index) {
    if (_travelers.length <= 1) return;
    setState(() => _travelers.removeAt(index));
  }

  bool _validate() {
    if (_selectedDate == null) {
      setState(() => _error = '请选择出行日期');
      return false;
    }
    for (var i = 0; i < _travelers.length; i++) {
      final t = _travelers[i];
      if (t.name.trim().isEmpty) {
        setState(() => _error = '请填写第${i + 1}位随行人员姓名');
        return false;
      }
      if (t.idCard.trim().length < 15) {
        setState(() => _error = '请填写第${i + 1}位随行人员身份证号');
        return false;
      }
      if (t.phone.trim().length < 11) {
        setState(() => _error = '请填写第${i + 1}位随行人员手机号');
        return false;
      }
    }
    if (!_agreed) {
      setState(() => _error = '请阅读并同意用户协议与隐私政策');
      return false;
    }
    setState(() => _error = null);
    return true;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('订单提交成功')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('填写订单'),
        backgroundColor: AppColors.backgroundCard,
        foregroundColor: AppColors.textPrimary,
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
            _section(1, '选择日期', _buildDateSection()),
            _section(2, '选择套餐', _buildPackageSection()),
            _section(3, '填写备注', _buildRemarkSection()),
            _section(4, '随行人员信息（姓名 / 身份证 / 手机号）', _buildTravelersSection()),
            _section(7, '同意协议', _buildAgreementSection()),
            if (_error != null) ...[
              SizedBox(height: 12.h),
              Text(_error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            ],
            SizedBox(height: 24.h),
            AppButton(
              label: '提交订单',
              loading: _submitting,
              onPressed: _submit,
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _section(int step, String title, Widget child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('$step', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(width: 8.w),
              Text(title, style: AppTextStyles.headlineSmall),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    final dateStr = _selectedDate != null
        ? '${_selectedDate!.month}月${_selectedDate!.day}日 ${_weekday(_selectedDate!.weekday)}'
        : '请选择出行日期';
    return InkWell(
      onTap: _pickDate,
      borderRadius: AppRadius.cardRadius,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: AppRadius.cardRadius,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 22.sp, color: AppColors.primary),
            SizedBox(width: 12.w),
            Text(
              dateStr,
              style: AppTextStyles.bodyMedium.copyWith(
                color: _selectedDate != null ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary, size: 24.sp),
          ],
        ),
      ),
    );
  }

  String _weekday(int w) {
    const map = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return map[w - 1];
  }

  Widget _buildPackageSection() {
    return Column(
      children: List.generate(
        _detail.packages.length,
        (i) {
          final p = _detail.packages[i];
          final selected = i == _selectedPackageIndex;
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: InkWell(
              onTap: () => setState(() => _selectedPackageIndex = i),
              borderRadius: AppRadius.cardRadius,
              child: Container(
                padding: EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: AppRadius.cardRadius,
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_off_rounded,
                      color: selected ? AppColors.primary : AppColors.textTertiary,
                      size: 22.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500)),
                          if (p.desc.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Text(p.desc, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                          ],
                        ],
                      ),
                    ),
                    Text('¥${p.price.toStringAsFixed(0)}${p.unit}', style: AppTextStyles.priceSmall),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRemarkSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: AppRadius.cardRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _remarkController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: '选填，如特殊需求、集合地点等',
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
        ),
        style: AppTextStyles.bodyMedium,
      ),
    );
  }

  Widget _buildTravelersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '一人可为多位随行人员填写信息，请确保与证件一致',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 12.h),
        ...List.generate(
          _travelers.length,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: TravelerFormCard(
              traveler: _travelers[i],
              index: i,
              onChanged: (updated) => setState(() => _travelers[i] = updated),
              onRemove: _travelers.length > 1 ? () => _removeTraveler(i) : null,
              canRemove: _travelers.length > 1,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: _addTraveler,
          icon: Icon(Icons.add_rounded, size: 20.sp, color: AppColors.primary),
          label: Text('添加随行人员', style: TextStyle(color: AppColors.primary, fontSize: 14.sp)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary),
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          ),
        ),
      ],
    );
  }

  Widget _buildAgreementSection() {
    return AuthAgreementCheckbox(
      value: _agreed,
      onChanged: (v) => setState(() => _agreed = v),
      onAgreementTap: () => context.push('/auth/agreement?type=user'),
      onPrivacyTap: () => context.push('/auth/agreement?type=privacy'),
    );
  }
}
