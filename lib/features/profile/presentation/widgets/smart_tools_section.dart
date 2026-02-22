import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';

const double _kCardRadius = 20;
const double _kTileIconSize = 44;

/// 5️⃣ 智能工具：高亮卡片，AI 规划师 / 行程 / 花费 / 票据 / 紧急联系人
class SmartToolsSection extends StatelessWidget {
  const SmartToolsSection({
    super.key,
    required this.onPlaceholder,
    this.onTravelPlanner,
  });

  final void Function(String name) onPlaceholder;
  final VoidCallback? onTravelPlanner;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            l10n?.profileSectionSmartTools ?? 'Smart Tools',
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
            boxShadow: AppShadow.medium,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 1),
          ),
          child: Column(
            children: [
              _SmartToolTile(
                icon: Icons.smart_toy_rounded,
                iconColor: AppColors.primary,
                label: l10n?.profileTravelPlanner ?? 'Travel Planner',
                highlight: true,
                onTap: () {
                if (onTravelPlanner != null) {
                  onTravelPlanner!();
                } else {
                  onPlaceholder(l10n?.profileTravelPlanner ?? 'Travel Planner');
                }
              },
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _SmartToolTile(
                icon: Icons.route_rounded,
                iconColor: AppColors.accentCool,
                label: l10n?.profileItinerary ?? 'Itinerary',
                onTap: () => onPlaceholder(l10n?.profileItinerary ?? 'Itinerary'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _SmartToolTile(
                icon: Icons.bar_chart_rounded,
                iconColor: AppColors.accentGold,
                label: l10n?.profileExpenseStats ?? 'Expense Statistics',
                onTap: () => onPlaceholder(l10n?.profileExpenseStats ?? 'Expense Statistics'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _SmartToolTile(
                icon: Icons.confirmation_number_outlined,
                iconColor: AppColors.accentWarm,
                label: l10n?.profileDownloadedTickets ?? 'Downloaded Tickets',
                onTap: () => onPlaceholder(l10n?.profileDownloadedTickets ?? 'Downloaded Tickets'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _SmartToolTile(
                icon: Icons.emergency_rounded,
                iconColor: AppColors.price,
                label: l10n?.profileEmergencyContact ?? 'Emergency Contact',
                onTap: () => onPlaceholder(l10n?.profileEmergencyContact ?? 'Emergency Contact'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmartToolTile extends StatelessWidget {
  const _SmartToolTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: highlight
            ? BoxDecoration(
                color: AppColors.primaryPale.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(_kCardRadius.r),
              )
            : null,
        child: Row(
          children: [
            Container(
              width: _kTileIconSize.w,
              height: _kTileIconSize.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
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
                  fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
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
