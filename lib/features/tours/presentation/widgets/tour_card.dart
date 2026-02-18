import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/tour_item.dart';

/// 旅行团卡片（高级样式）
class TourCard extends StatelessWidget {
  const TourCard({
    super.key,
    required this.tour,
    this.onTap,
  });

  final TourItem tour;
  final VoidCallback? onTap;

  static String _formatDate(DateTime d) => '${d.month}月${d.day}日';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: AppRadius.cardRadius,
            boxShadow: [
              ...AppShadow.card,
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImage(context),
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCityTag(),
                    SizedBox(height: 8.h),
                    Text(
                      tour.title,
                      style: AppTextStyles.headlineSmall.copyWith(height: 1.35),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (tour.subtitle.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        tour.subtitle,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 10.h),
                    _buildTags(),
                    if (tour.confirmLabel != null && tour.confirmLabel!.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(Icons.verified_rounded, size: 14.sp, color: AppColors.primary),
                          SizedBox(width: 4.w),
                          Text(
                            tour.confirmLabel!,
                            style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 11.sp),
                          ),
                        ],
                      ),
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
    return Stack(
      children: [
        Container(
          height: 140.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryLight2, AppColors.primaryLight],
            ),
          ),
          child: Center(
            child: Icon(Icons.image_outlined, size: 48.sp, color: AppColors.primary.withValues(alpha: 0.5)),
          ),
        ),
        Positioned(
          left: 10.w,
          bottom: 10.h,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: AppRadius.smRadius,
            ),
            child: Text(
              '${tour.days}天${(tour.hotelNights ?? tour.days - 1)}晚',
              style: TextStyle(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCityTag() {
    return Row(
      children: [
        Icon(Icons.location_on_outlined, size: 14.sp, color: AppColors.textTertiary),
        SizedBox(width: 4.w),
        Text(
          '${tour.city}出发',
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary, fontSize: 11.sp),
        ),
      ],
    );
  }

  Widget _buildTags() {
    if (tour.tags.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8.w,
      runSpacing: 4.h,
      children: tour.tags.map((t) => _smallTag(t)).toList(),
    );
  }

  Widget _smallTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(fontSize: 10.sp, color: AppColors.textSecondary),
      ),
    );
  }

  Widget _buildPriceRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '¥',
          style: AppTextStyles.priceSmall.copyWith(fontSize: 12.sp),
        ),
        Text(
          tour.price.toStringAsFixed(0),
          style: AppTextStyles.price.copyWith(fontSize: 20.sp),
        ),
        Text(
          '起',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 12.sp),
        ),
      ],
    );
  }
}
