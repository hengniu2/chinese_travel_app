import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/tour_item.dart';

/// 旅行团卡片（马蜂窝风：16:9 图、价格强调、标签优化、圆角 16、轻阴影、层级清晰）
class TourCard extends StatelessWidget {
  const TourCard({
    super.key,
    required this.tour,
    this.onTap,
  });

  final TourItem tour;
  final VoidCallback? onTap;

  static const double _cardRadius = 16;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_cardRadius),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(_cardRadius),
            boxShadow: AppShadow.card,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImage(context),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetaRow(),
                    SizedBox(height: 8.h),
                    Text(
                      tour.title,
                      style: AppTextStyles.headlineSmall.copyWith(
                        height: 1.35,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (tour.subtitle.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        tour.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (tour.tags.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      _buildTags(),
                    ],
                    if (tour.confirmLabel != null && tour.confirmLabel!.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      _buildConfirmLabel(),
                    ],
                    SizedBox(height: 12.h),
                    _buildPriceRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryPale,
                  AppColors.primaryLight.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 48.sp,
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
            ),
          ),
          // 底部渐变遮罩，保证文字可读
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                ),
              ),
            ),
          ),
          Positioned(
            left: 10.w,
            bottom: 10.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${tour.days}天${tour.hotelNights ?? tour.days - 1}晚',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10.w,
            top: 10.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_rounded, size: 12.sp, color: Colors.white),
                  SizedBox(width: 4.w),
                  Text(
                    '${tour.city}出发',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.textTertiary),
        SizedBox(width: 4.w),
        Text(
          '${tour.city}出发',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(width: 12.w),
        Text(
          '·',
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
        SizedBox(width: 8.w),
        Text(
          tour.type,
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 6.h,
      children: tour.tags.map((t) => _tagChip(t)).toList(),
    );
  }

  Widget _tagChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primaryPale,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildConfirmLabel() {
    return Row(
      children: [
        Icon(Icons.verified_rounded, size: 14.sp, color: AppColors.primary),
        SizedBox(width: 4.w),
        Text(
          tour.confirmLabel!,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '¥',
          style: AppTextStyles.priceLarge.copyWith(fontSize: 14.sp),
        ),
        Text(
          tour.price.toStringAsFixed(0),
          style: AppTextStyles.priceLarge.copyWith(fontSize: 22.sp),
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            '起/人',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }
}
