import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../auth/presentation/widgets/auth_input_field.dart';
import '../models/companion_order.dart';

/// 单条出行人/入住人信息卡（姓名、身份证、手机号）
class TravelerFormCard extends StatefulWidget {
  const TravelerFormCard({
    super.key,
    required this.traveler,
    required this.index,
    required this.onChanged,
    this.onRemove,
    this.canRemove = true,
    this.labelPrefix = '出行人',
    this.nameError,
    this.idCardError,
    this.phoneError,
  });

  final TravelerInfo traveler;
  final int index;
  final ValueChanged<TravelerInfo> onChanged;
  final VoidCallback? onRemove;
  final bool canRemove;
  final String labelPrefix;
  final String? nameError;
  final String? idCardError;
  final String? phoneError;

  @override
  State<TravelerFormCard> createState() => _TravelerFormCardState();
}

class _TravelerFormCardState extends State<TravelerFormCard> {
  late TextEditingController _nameController;
  late TextEditingController _idController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.traveler.name);
    _idController = TextEditingController(text: widget.traveler.idCard);
    _phoneController = TextEditingController(text: widget.traveler.phone);
    _nameController.addListener(_notify);
    _idController.addListener(_notify);
    _phoneController.addListener(_notify);
  }

  @override
  void didUpdateWidget(TravelerFormCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.traveler != widget.traveler &&
        widget.traveler.name == _nameController.text &&
        widget.traveler.idCard == _idController.text &&
        widget.traveler.phone == _phoneController.text) {}
  }

  void _notify() {
    widget.onChanged(TravelerInfo(
      name: _nameController.text,
      idCard: _idController.text,
      phone: _phoneController.text,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadow.card,
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPale,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${widget.index + 1}',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    '${widget.labelPrefix} ${widget.index + 1}',
                    style: AppTextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
              if (widget.canRemove && widget.onRemove != null)
                IconButton(
                  icon: Icon(Icons.delete_outline_rounded, size: 22.sp, color: AppColors.error),
                  onPressed: widget.onRemove,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.w),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          AuthInputField(
            controller: _nameController,
            label: l10n?.travelerFormName ?? '姓名',
            hint: l10n?.realNameVerifyNameHint ?? '请输入真实姓名',
            onChanged: (_) {},
          ),
          if (widget.nameError != null && widget.nameError!.isNotEmpty) _errorText(widget.nameError!),
          SizedBox(height: 14.h),
          _buildIdCardField(l10n),
          if (widget.idCardError != null && widget.idCardError!.isNotEmpty) _errorText(widget.idCardError!),
          SizedBox(height: 14.h),
          AuthInputField(
            controller: _phoneController,
            label: l10n?.travelerFormPhone ?? '手机号',
            hint: '请输入11位手机号',
            keyboardType: TextInputType.phone,
            maxLength: 11,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) {},
          ),
          if (widget.phoneError != null && widget.phoneError!.isNotEmpty) _errorText(widget.phoneError!),
        ],
      ),
    );
  }

  Widget _errorText(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 14.sp, color: AppColors.error),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCardField(AppLocalizations? l10n) {
    final hasError = widget.idCardError != null && widget.idCardError!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n?.travelerFormIdCard ?? '身份证号',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasError ? AppColors.error : AppColors.border,
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _idController,
                  keyboardType: TextInputType.visiblePassword,
                  maxLength: 18,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9Xx]')),
                  ],
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontFamily: 'monospace',
                    letterSpacing: 1.2,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n?.realNameVerifyIdCardHint ?? '请输入18位身份证号',
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                      fontFamily: 'monospace',
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    counterText: '',
                  ),
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _idController,
                builder: (_, value, __) => Text(
                  '${value.text.length}/18',
                  style: AppTextStyles.caption.copyWith(
                    color: value.text.length >= 18 ? AppColors.primary : AppColors.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
