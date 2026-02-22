import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';

const double _kCardRadius = 24;
const double _kTileIconSize = 48;

/// 出行服务：大圆角图标+粗标题+副标题+箭头，首行 AI 规划师 高亮（光晕边框）
class TravelServicesSection extends StatelessWidget {
  const TravelServicesSection({
    super.key,
    required this.onPlaceholder,
    this.onOrders,
  });

  final void Function(String name) onPlaceholder;
  final VoidCallback? onOrders;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            l10n?.profileSectionTravel ?? '出行服务',
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
              _TravelServiceTile(
                icon: Icons.smart_toy_rounded,
                iconColor: AppColors.primary,
                label: l10n?.profileTravelPlanner ?? '旅行规划师',
                subtitle: l10n?.profileTravelPlannerSubtitle ?? '智能规划你的行程',
                highlight: true,
                onTap: () => onPlaceholder(l10n?.profileTravelPlanner ?? '旅行规划师'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _TravelServiceTile(
                icon: Icons.map_rounded,
                iconColor: AppColors.accentCool,
                label: l10n?.profileTourPackages ?? '跟团游',
                subtitle: null,
                onTap: () {
                  if (onOrders != null) {
                    onOrders!();
                  } else {
                    context.push('/orders');
                  }
                },
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _TravelServiceTile(
                icon: Icons.hotel_rounded,
                iconColor: AppColors.accentGold,
                label: l10n?.profileHotels ?? '酒店',
                subtitle: null,
                onTap: () => onPlaceholder(l10n?.profileHotels ?? '酒店'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _TravelServiceTile(
                icon: Icons.flight_rounded,
                iconColor: AppColors.accentWarm,
                label: l10n?.profileFlights ?? '机票',
                subtitle: null,
                onTap: () => onPlaceholder(l10n?.profileFlights ?? '机票'),
              ),
              Divider(height: 1, indent: 16.w + _kTileIconSize.w + 12.w, endIndent: 16.w, color: AppColors.divider),
              _TravelServiceTile(
                icon: Icons.health_and_safety_outlined,
                iconColor: AppColors.success,
                label: l10n?.profileInsurance ?? '保险',
                subtitle: null,
                onTap: () => onPlaceholder(l10n?.profileInsurance ?? '保险'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TravelServiceTile extends StatelessWidget {
  const _TravelServiceTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.highlight = false,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final bool highlight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppTapScale(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: highlight
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(_kCardRadius.r),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.35), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              )
            : null,
        child: Row(
          children: [
            Container(
              width: _kTileIconSize.w,
              height: _kTileIconSize.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, size: 26.sp, color: iconColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 22.sp, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
