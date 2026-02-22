import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_shadow.dart';
import '../data/hotel_model.dart';
import '../theme/hotel_theme.dart';

/// Detail info card: name, tags, score, address, map CTA.
class HotelDetailInfoCard extends StatelessWidget {
  const HotelDetailInfoCard({
    super.key,
    required this.detail,
    this.onMapTap,
  });

  final HotelDetail detail;
  final VoidCallback? onMapTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: HotelTheme.grid2.w),
      padding: EdgeInsets.all(HotelTheme.grid3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius:
            BorderRadius.circular(HotelTheme.cardRadius + 4),
        boxShadow: isDark ? null : AppShadow.cardElevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  detail.name,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (detail.tagBadge != null &&
                  detail.tagBadge!.isNotEmpty) ...[
                SizedBox(width: 8.w),
                _TagBadge(label: detail.tagBadge!),
              ],
              if (detail.score != null) ...[
                SizedBox(width: 8.w),
                _RatingPill(score: detail.score!),
              ],
            ],
          ),
          if (detail.tags.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: detail.tags
                  .take(5)
                  .map((t) => _FeatureTag(label: t))
                  .toList(),
            ),
          ],
          SizedBox(height: 14.h),
          _LocationRow(address: detail.address, onMapTap: onMapTap),
        ],
      ),
    );
  }
}

class _TagBadge extends StatelessWidget {
  const _TagBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.overline.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        '${score.toStringAsFixed(1)}分',
        style: AppTextStyles.overline.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

class _FeatureTag extends StatelessWidget {
  const _FeatureTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primaryPale,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({
    required this.address,
    this.onMapTap,
  });

  final String address;
  final VoidCallback? onMapTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_rounded, size: 18.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            address,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (onMapTap != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onMapTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined,
                        size: 18.sp, color: AppColors.primary),
                    SizedBox(width: 4.w),
                    Text(
                      '地图',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
