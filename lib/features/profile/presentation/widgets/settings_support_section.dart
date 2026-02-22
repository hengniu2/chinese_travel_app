import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../../auth/providers/auth_provider.dart';

const double _kCardRadius = 24;
const double _kTileIconSize = 44;

/// 6️⃣ 设置与帮助：消息 / 帮助 / 反馈 / 关于 / 清除缓存 / 退出，简洁列表
class SettingsSupportSection extends StatelessWidget {
  const SettingsSupportSection({
    super.key,
    required this.onPlaceholder,
    required this.onSettings,
    required this.onLogout,
    required this.ref,
  });

  final void Function(String name) onPlaceholder;
  final VoidCallback onSettings;
  final VoidCallback onLogout;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = ref.watch(authProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            l10n?.profileSectionMoreSettings ?? '更多与设置',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 16.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(_kCardRadius.r),
            boxShadow: AppShadow.light,
          ),
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: AppColors.accentCool,
                label: l10n?.profileMessages ?? 'Messages',
                onTap: () => context.push('/messages'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _SettingsTile(
                icon: Icons.help_outline_rounded,
                iconColor: AppColors.iconOutlineOnLight,
                label: l10n?.profileHelpCenter ?? 'Help Center',
                onTap: () => onPlaceholder(l10n?.profileHelpCenter ?? 'Help Center'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _SettingsTile(
                icon: Icons.feedback_outlined,
                iconColor: AppColors.accentWarm,
                label: l10n?.profileFeedback ?? 'Feedback',
                onTap: () => onPlaceholder(l10n?.profileFeedback ?? 'Feedback'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: AppColors.iconOutlineOnLight,
                label: l10n?.profileAboutUs ?? 'About Us',
                onTap: () => onPlaceholder(l10n?.profileAboutUs ?? 'About Us'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _SettingsTile(
                icon: Icons.cleaning_services_rounded,
                iconColor: AppColors.iconOutlineOnLight,
                label: l10n?.profileClearCache ?? 'Clear Cache',
                onTap: () => onPlaceholder(l10n?.profileClearCache ?? 'Clear Cache'),
              ),
              if (auth.isAuthenticated) ...[
                Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  iconColor: AppColors.price,
                  label: l10n?.profileLogout ?? 'Log out',
                  onTap: onLogout,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: _kTileIconSize.w,
              height: _kTileIconSize.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 24.sp, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 22.sp, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
