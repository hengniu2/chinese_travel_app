import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';

const double _kCardRadius = 20;
const double _kTileIconSize = 44;

/// 4️⃣ 我的服务：分卡片（出行服务 / 我的资产 / 社交与成长），ListTile 风格
class MyServicesSection extends StatelessWidget {
  const MyServicesSection({
    super.key,
    required this.onPlaceholder,
    this.onTravelPlanner,
    this.onOrders,
    this.onHotels,
    this.onFlights,
  });

  final void Function(String name) onPlaceholder;
  final VoidCallback? onTravelPlanner;
  final VoidCallback? onOrders;
  final VoidCallback? onHotels;
  final VoidCallback? onFlights;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n?.profileSectionTravelServices ?? 'Travel Services'),
        SizedBox(height: 8.h),
        _ServiceCard(
          items: [
            _ServiceTile(
              icon: Icons.travel_explore_rounded,
              iconColor: AppColors.primary,
              label: l10n?.profileTravelPlanner ?? 'Travel Planner',
              onTap: () {
                if (onTravelPlanner != null) {
                  onTravelPlanner!();
                } else {
                  onPlaceholder(l10n?.profileTravelPlanner ?? 'Travel Planner');
                }
              },
            ),
            _ServiceTile(
              icon: Icons.map_rounded,
              iconColor: AppColors.accentCool,
              label: l10n?.profileTourPackages ?? 'Tour Packages',
              onTap: () {
                if (onOrders != null) {
                  onOrders!();
                } else {
                  context.push('/orders');
                }
              },
            ),
            _ServiceTile(
              icon: Icons.hotel_rounded,
              iconColor: AppColors.accentGold,
              label: l10n?.profileHotels ?? 'Hotels',
              onTap: () {
                if (onHotels != null) {
                  onHotels!();
                } else {
                  onPlaceholder(l10n?.profileHotels ?? 'Hotels');
                }
              },
            ),
            _ServiceTile(
              icon: Icons.flight_rounded,
              iconColor: AppColors.accentWarm,
              label: l10n?.profileFlights ?? 'Flights',
              onTap: () {
                if (onFlights != null) {
                  onFlights!();
                } else {
                  onPlaceholder(l10n?.profileFlights ?? 'Flights');
                }
              },
            ),
            _ServiceTile(icon: Icons.health_and_safety_outlined, iconColor: AppColors.success, label: l10n?.profileInsurance ?? 'Insurance', onTap: () => onPlaceholder(l10n?.profileInsurance ?? 'Insurance')),
          ],
        ),
        SizedBox(height: 16.h),
        _sectionTitle(l10n?.profileSectionMyAssets ?? 'My Assets'),
        SizedBox(height: 8.h),
        _ServiceCard(
          items: [
            _ServiceTile(icon: Icons.account_balance_wallet_outlined, iconColor: AppColors.accentGold, label: l10n?.profileWallet ?? 'Wallet', onTap: () => context.push('/profile/wallet')),
            _ServiceTile(icon: Icons.confirmation_number_outlined, iconColor: AppColors.accentWarm, label: l10n?.profileCoupons ?? 'Coupons', onTap: () => onPlaceholder(l10n?.profileCoupons ?? 'Coupons')),
            _ServiceTile(icon: Icons.stars_rounded, iconColor: AppColors.primary, label: l10n?.profilePoints ?? 'Points', onTap: () => onPlaceholder(l10n?.profilePoints ?? 'Points')),
            _ServiceTile(icon: Icons.receipt_long_outlined, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileInvoice ?? 'Invoice', onTap: () => onPlaceholder(l10n?.profileInvoice ?? 'Invoice')),
            _ServiceTile(icon: Icons.card_giftcard_rounded, iconColor: AppColors.homeChipRed, label: l10n?.profileRewards ?? 'Rewards', onTap: () => onPlaceholder(l10n?.profileRewards ?? 'Rewards')),
          ],
        ),
        SizedBox(height: 16.h),
        _sectionTitle(l10n?.profileSectionSocialGrowth ?? 'Social & Growth'),
        SizedBox(height: 8.h),
        _ServiceCard(
          items: [
            _ServiceTile(icon: Icons.person_add_rounded, iconColor: AppColors.primary, label: l10n?.profileInviteFriends ?? 'Invite Friends', onTap: () => onPlaceholder(l10n?.profileInviteFriends ?? 'Invite Friends')),
            _ServiceTile(icon: Icons.workspace_premium_rounded, iconColor: AppColors.accentGold, label: l10n?.profileBecomePlanner ?? 'Become Planner', onTap: () => onPlaceholder(l10n?.profileBecomePlanner ?? 'Become Planner')),
            _ServiceTile(icon: Icons.share_rounded, iconColor: AppColors.accentCool, label: l10n?.profileReferralCenter ?? 'Referral Center', onTap: () => onPlaceholder(l10n?.profileReferralCenter ?? 'Referral Center')),
          ],
        ),
      ],
    );
  }
}

Widget _sectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: Text(
      title,
      style: AppTextStyles.headlineSmall.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontSize: 16.sp,
      ),
    ),
  );
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.items});

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(_kCardRadius.r),
        boxShadow: AppShadow.light,
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
            items[i],
          ],
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
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
