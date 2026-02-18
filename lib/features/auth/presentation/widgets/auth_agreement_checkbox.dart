import 'package:flutter/material.dart';

import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_text_styles.dart';

/// 同意协议复选框
class AuthAgreementCheckbox extends StatelessWidget {
  const AuthAgreementCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onAgreementTap,
    this.onPrivacyTap,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onAgreementTap;
  final VoidCallback? onPrivacyTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  '我已阅读并同意 ',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: onAgreementTap,
                  child: Text(
                    '《用户协议》',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  ' 和 ',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: onPrivacyTap,
                  child: Text(
                    '《隐私政策》',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
