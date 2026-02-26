import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../theme/profile_theme.dart';

const double _kCardRadius = 16;

/// 样本风格：两张快捷卡片 · 我的朋友 / 优惠券
class ProfileQuickCardsSection extends StatelessWidget {
  const ProfileQuickCardsSection({
    super.key,
    this.onMyFriends,
    this.onCoupons,
  });

  final VoidCallback? onMyFriends;
  final VoidCallback? onCoupons;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: AppTapScale(
              onTap: onMyFriends,
              child: _QuickCard(
                icon: Icons.people_rounded,
                iconColor: const Color(0xFFFF9800),
                label: l10n?.profileMyFriends ?? '我的朋友',
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: AppTapScale(
              onTap: onCoupons,
              child: _QuickCard(
                icon: Icons.confirmation_number_outlined,
                iconColor: AppColors.accentGold,
                label: l10n?.profileCoupons ?? '优惠券',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  const _QuickCard({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(_kCardRadius.r),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, 2),
            blurRadius: 10,
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
          Container(
            width: 44.w,
            height: 44.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: iconColor.withValues(alpha: 0.4), width: 1),
            ),
            child: Icon(icon, size: 26.sp, color: iconColor),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: ProfileTheme.label,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
