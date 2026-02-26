import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../data/profile_ui_state.dart';

const double _kCardRadius = 24;
const double _kTileIconSize = 44;

/// 我的资产：钱包(余额)、优惠券(即将过期)、积分、发票
class ProfileAssetsSection extends StatelessWidget {
  const ProfileAssetsSection({
    super.key,
    required this.state,
    required this.onPlaceholder,
  });

  final ProfileUiState state;
  final void Function(String name) onPlaceholder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            l10n?.profileSectionAssets ?? '我的资产',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              fontSize: 17.sp,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(_kCardRadius.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 2),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            children: [
              _AssetTile(
                icon: Icons.account_balance_wallet_outlined,
                iconColor: AppColors.accentGold,
                label: l10n?.profileWallet ?? '钱包',
                trailing: (state.walletBalance ?? 0) > 0 ? '¥${(state.walletBalance ?? 0).toStringAsFixed(2)}' : null,
                onTap: () => context.push('/profile/wallet'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _AssetTile(
                icon: Icons.confirmation_number_outlined,
                iconColor: AppColors.accentWarm,
                label: l10n?.profileCoupons ?? '优惠券',
                trailing: (state.couponExpiringCount ?? 0) > 0
                    ? '${l10n?.profileCouponExpiring ?? '即将过期'} ${state.couponExpiringCount ?? 0}'
                    : null,
                onTap: () => onPlaceholder(l10n?.profileCoupons ?? '优惠券'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _AssetTile(
                icon: Icons.stars_rounded,
                iconColor: AppColors.primary,
                label: l10n?.profilePoints ?? '积分',
                trailing: (state.travelPoints ?? 0) > 0 ? '${state.travelPoints ?? 0}' : null,
                onTap: () => onPlaceholder(l10n?.profilePoints ?? '积分'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _AssetTile(
                icon: Icons.receipt_long_outlined,
                iconColor: AppColors.iconOutlineOnLight,
                label: l10n?.profileInvoice ?? '发票',
                onTap: () => onPlaceholder(l10n?.profileInvoice ?? '发票'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? trailing;
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
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14.r),
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
            if (trailing != null)
              Text(
                trailing!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 13.sp,
                ),
              ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right_rounded, size: 22.sp, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
