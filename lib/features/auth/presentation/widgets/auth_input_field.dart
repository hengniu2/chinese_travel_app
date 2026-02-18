import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_radius.dart';
import '../../../../shared/design_system/app_spacing.dart';
import '../../../../shared/design_system/app_text_styles.dart';

/// 认证页通用输入框（手机号/密码/验证码）
class AuthInputField extends StatelessWidget {
  const AuthInputField({
    super.key,
    this.controller,
    this.hint = '',
    this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String hint;
  final String? label;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final int? maxLength;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null && label!.isNotEmpty) ...[
          Text(label!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          SizedBox(height: AppSpacing.sm),
        ],
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.cardRadius,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              if (prefixIcon != null) ...[
                prefixIcon!,
                SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  inputFormatters: inputFormatters,
                  validator: validator,
                  onChanged: onChanged,
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    counterText: '',
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
