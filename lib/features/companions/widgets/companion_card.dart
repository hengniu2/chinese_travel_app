import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../models/companion_list_item.dart';
import 'rating_widget.dart';
import 'tag_chip.dart';

/// 陪游列表卡片：头像+信息，紧凑无溢出，商业级
class CompanionCard extends StatelessWidget {
  const CompanionCard({
    super.key,
    required this.companion,
    this.onTap,
  });

  final CompanionListItem companion;
  final VoidCallback? onTap;

  static const double _avatarSize = 72;
  static const double _cardRadius = 16;
  static const double _cardPadding = 14;
  static const double _onlineDotSize = 10;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppTapScale(
      onTap: onTap ?? () => context.push('/companions/${companion.id}'),
      child: Container(
        padding: EdgeInsets.all(_cardPadding.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(_cardRadius),
          boxShadow: AppShadow.light,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAvatar(),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row1NameAge(),
                  SizedBox(height: 4.h),
                  _row2CityExperience(l10n),
                  if (companion.tags.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: companion.tags.take(5).map((l) => TagChip(label: l)).toList(),
                    ),
                  ],
                  SizedBox(height: 6.h),
                  _row4RatingService(l10n),
                  if (_hasOptionalInfo()) ...[
                    SizedBox(height: 6.h),
                    _rowOptional(l10n),
                  ],
                  SizedBox(height: 8.h),
                  _row5PriceAndButton(context, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasOptionalInfo() {
    return (companion.languages != null && companion.languages!.isNotEmpty) ||
        companion.isVerified ||
        (companion.responseTime != null && companion.responseTime!.isNotEmpty);
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: _avatarSize.w,
      height: _avatarSize.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: companion.avatarUrl.isNotEmpty
                ? Image.network(
                    companion.avatarUrl,
                    width: _avatarSize.w,
                    height: _avatarSize.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatarPlaceholder(),
                  )
                : _avatarPlaceholder(),
          ),
          if (companion.isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: _onlineDotSize.w,
                height: _onlineDotSize.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.card, width: 1.5.w),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return Container(
      width: _avatarSize.w,
      height: _avatarSize.w,
      color: AppColors.surface,
      child: Icon(
        Icons.person_rounded,
        size: 32.sp,
        color: AppColors.textTertiary,
      ),
    );
  }

  Widget _row1NameAge() {
    final ageText = '${companion.age}岁';
    return Row(
      children: [
        Expanded(
          child: Text(
            companion.name,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          ' · $ageText',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12.sp,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _row2CityExperience(AppLocalizations? l10n) {
    final experience = l10n?.companionExperienceYears(companion.experienceYears) ??
        '${companion.experienceYears}年陪游经验';
    final text = '${companion.city} · $experience';
    return Text(
      text,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textTertiary,
        fontSize: 12.sp,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _row4RatingService(AppLocalizations? l10n) {
    final reviews = l10n?.companionReviewsCount(companion.reviewCount) ??
        '${companion.reviewCount}条评价';
    final service = l10n?.companionServiceCount(companion.completedOrders) ??
        '已服务 ${companion.completedOrders}次';
    return Row(
      children: [
        RatingWidget(rating: companion.rating, iconSize: 14.sp, fontSize: 12.sp),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            '($reviews)   |   $service',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 11.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _rowOptional(AppLocalizations? l10n) {
    final parts = <Widget>[];
    if (companion.languages != null && companion.languages!.isNotEmpty) {
      parts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.language_rounded, size: 12.sp, color: AppColors.textTertiary),
            SizedBox(width: 4.w),
            Text(
              companion.languages!.join('、'),
              style: AppTextStyles.overline.copyWith(fontSize: 10.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }
    if (companion.isVerified) {
      parts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_rounded, size: 12.sp, color: AppColors.accentCool),
            SizedBox(width: 4.w),
            Text(
              l10n?.companionVerified ?? '已认证',
              style: AppTextStyles.overline.copyWith(fontSize: 10.sp),
            ),
          ],
        ),
      );
    }
    if (companion.responseTime != null && companion.responseTime!.isNotEmpty) {
      parts.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule_rounded, size: 12.sp, color: AppColors.textTertiary),
            SizedBox(width: 4.w),
            Text(
              companion.responseTime!,
              style: AppTextStyles.overline.copyWith(fontSize: 10.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    }
    return Wrap(
      spacing: 10.w,
      runSpacing: 4.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: parts,
    );
  }

  Widget _row5PriceAndButton(BuildContext context, AppLocalizations? l10n) {
    final perDay = l10n?.companionPricePerDay ?? '/ 天';
    final bookLabel = l10n?.companionBookNow ?? '立即预约';
    return Row(
      children: [
        Expanded(
          child: Text(
            '¥${companion.pricePerDay.toStringAsFixed(0)}$perDay',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
              color: AppColors.price,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppGradients.brand,
            ),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            boxShadow: AppShadow.light,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap ?? () => context.push('/companions/${companion.id}'),
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                child: Text(
                  bookLabel,
                  style: AppTextStyles.buttonSecondary.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.iconOutlineOnLight,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
