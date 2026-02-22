import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/companion_list_item.dart';

/// 热门陪游横滑卡片：小头像居中 + 姓名、评分、价格，紧凑无溢出
class CompanionFeaturedCard extends StatelessWidget {
  const CompanionFeaturedCard({
    super.key,
    required this.companion,
    this.width,
    this.onTap,
  });

  final CompanionListItem companion;
  final double? width;
  final VoidCallback? onTap;

  static const double _avatarSize = 56;
  static const double _cardRadius = 12;
  static const double _defaultWidth = 100;

  @override
  Widget build(BuildContext context) {
    final w = width ?? _defaultWidth.w;
    return AppTapScale(
      onTap: onTap ?? () => context.push('/companions/${companion.id}'),
      child: Container(
        width: w,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: companion.avatarUrl.isNotEmpty
                  ? Image.network(
                      companion.avatarUrl,
                      width: _avatarSize.w,
                      height: _avatarSize.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            SizedBox(height: 8.h),
            Text(
              companion.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: 12.sp, color: AppColors.accentGold),
                SizedBox(width: 2.w),
                Text(
                  companion.rating.toStringAsFixed(1),
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              '¥${companion.pricePerDay.toStringAsFixed(0)}/天',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
                color: AppColors.price,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: _avatarSize.w,
      height: _avatarSize.w,
      color: AppColors.surface,
      child: Icon(
        Icons.person_rounded,
        size: 28.sp,
        color: AppColors.textTertiary,
      ),
    );
  }
}
