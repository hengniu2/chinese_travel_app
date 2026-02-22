import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';

const double _kCardRadius = 16;
const double _kIconSize = 48;

/// 样本风格：我的工具 · 3 列网格，部分带「新」角标；点击跳转对应子页
class ProfileToolsGridSection extends StatelessWidget {
  const ProfileToolsGridSection({
    super.key,
    required this.onNavigateTo,
    this.onOrders,
  });

  final void Function(String path) onNavigateTo;
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
            l10n?.profileSectionMyTools ?? '我的工具',
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
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
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
              Row(
                children: [
                  _GridItem(icon: Icons.smart_toy_rounded, iconColor: AppColors.sectionCompanion, label: l10n?.profileTravelPlanner ?? '旅行规划师', showNew: false, onTap: () => onNavigateTo('/planner/planner')),
                  _GridItem(icon: Icons.hotel_rounded, iconColor: AppColors.accentGold, label: l10n?.profileHotelOrders ?? l10n?.profileHotels ?? '酒店', showNew: true, onTap: () => onNavigateTo('/profile/hotels')),
                  _GridItem(icon: Icons.flight_rounded, iconColor: AppColors.accentCool, label: l10n?.profileFlightOrders ?? l10n?.profileFlights ?? '机票', showNew: true, onTap: () => onNavigateTo('/profile/flights')),
                  _GridItem(icon: Icons.receipt_long_outlined, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileIssueInvoice ?? '开发票', showNew: false, onTap: () => onNavigateTo('/profile/invoice')),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  _GridItem(icon: Icons.person_add_rounded, iconColor: AppColors.primary, label: l10n?.profileInviteFriends ?? '邀请好友', showNew: false, onTap: () => onNavigateTo('/profile/invite-friends')),
                  _GridItem(icon: Icons.menu_book_rounded, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileCourseOrders ?? '课程订单', showNew: false, onTap: () => onNavigateTo('/profile/course-orders')),
                  _GridItem(icon: Icons.flight_rounded, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileFlightOrders ?? '机票订单', showNew: false, onTap: () => onNavigateTo('/profile/flight-orders')),
                  _GridItem(icon: Icons.hotel_rounded, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileHotelOrders ?? '酒店订单', showNew: false, onTap: () => onNavigateTo('/profile/hotel-orders')),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  _GridItem(icon: Icons.card_giftcard_rounded, iconColor: AppColors.accentWarm, label: l10n?.profileMyPrizes ?? '我的奖品', showNew: false, onTap: () => onNavigateTo('/profile/prizes')),
                  _GridItem(icon: Icons.person_rounded, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileReferrer ?? '引荐人', showNew: false, onTap: () => onNavigateTo('/profile/referrer')),
                  _GridItem(icon: Icons.feedback_outlined, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileFeedback ?? '意见反馈', showNew: false, onTap: () => onNavigateTo('/profile/feedback')),
                  _GridItem(icon: Icons.checklist_rounded, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileTravelCollection ?? '出行收集', showNew: false, onTap: () => onNavigateTo('/profile/travel-collection')),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  _GridItem(icon: Icons.workspace_premium_rounded, iconColor: const Color(0xFF7C3AED), label: l10n?.membershipCenterTitle ?? '会员中心', showNew: true, onTap: () => onNavigateTo('/profile/membership')),
                  _GridItem(icon: Icons.bar_chart_rounded, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileDataStats ?? '数据统计', showNew: false, onTap: () => onNavigateTo('/profile/data-stats')),
                  _GridItem(icon: Icons.cleaning_services_rounded, iconColor: AppColors.iconOutlineOnLight, label: l10n?.profileClearCache ?? '清除缓存', showNew: false, onTap: () => onNavigateTo('/profile/clear-cache')),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GridItem extends StatelessWidget {
  const _GridItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.showNew,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final bool showNew;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Expanded(
      child: AppTapScale(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: _kIconSize.w,
                  height: _kIconSize.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, size: 26.sp, color: iconColor),
                ),
                if (showNew)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppColors.price,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        l10n?.profileBadgeNew ?? '新',
                        style: TextStyle(fontSize: 9.sp, color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
