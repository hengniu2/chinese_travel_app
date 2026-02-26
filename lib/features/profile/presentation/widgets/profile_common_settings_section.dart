import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../theme/profile_theme.dart';

const double _kCardRadius = 16;
const double _kIconSize = 44;

/// 样本风格：常用设置 · 单行 4 项（常用出行人 / 实名认证 / 收货地址 / 设置）
class ProfileCommonSettingsSection extends StatelessWidget {
  const ProfileCommonSettingsSection({
    super.key,
    required this.onNavigateTo,
    required this.onSettings,
  });

  final void Function(String path) onNavigateTo;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            l10n?.profileSectionCommonSettings ?? '常用设置',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: ProfileTheme.sectionTitle,
              fontSize: 17.sp,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(_kCardRadius.r),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 2),
                blurRadius: 12,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _SettingItem(
                  icon: Icons.person_outline_rounded,
                  label: l10n?.profileFrequentTravelers ?? '常用出行人',
                  onTap: () => onNavigateTo('/profile/frequent-travelers'),
                ),
              ),
              Expanded(
                child: _SettingItem(
                  icon: Icons.verified_user_outlined,
                  label: l10n?.realNameVerifyTitle ?? '实名认证',
                  onTap: () => context.push('/verify-name'),
                ),
              ),
              Expanded(
                child: _SettingItem(
                  icon: Icons.location_on_outlined,
                  label: l10n?.profileShippingAddress ?? '收货地址',
                  onTap: () => onNavigateTo('/profile/addresses'),
                ),
              ),
              Expanded(
                child: _SettingItem(
                  icon: Icons.settings_outlined,
                  label: l10n?.profileSettings ?? '设置',
                  onTap: onSettings,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _kIconSize.w,
            height: _kIconSize.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1),
            ),
            child: Icon(icon, size: 24.sp, color: AppColors.primaryDark),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: ProfileTheme.label,
              fontWeight: FontWeight.w500,
              fontSize: 11.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
