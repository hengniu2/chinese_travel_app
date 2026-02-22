import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_shadow.dart';
import '../../../shared/design_system/app_tap_scale.dart';
import '../data/hotel_model.dart';
import '../theme/hotel_theme.dart';
import 'feature_chip.dart';
import 'gradient_button.dart';
import 'rating_badge.dart';

/// Hotel list card: image, name, tag, score, features, price, CTA.
class HotelCard extends StatelessWidget {
  const HotelCard({
    super.key,
    required this.hotel,
    this.viewDetailLabel = '查看详情',
    this.onTap,
  });

  final HotelItem hotel;
  final String viewDetailLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: '${hotel.name}，${hotel.price.toStringAsFixed(0)}元起',
      child: AppTapScale(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(HotelTheme.cardRadius),
            boxShadow: isDark ? null : AppShadow.cardElevated,
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(HotelTheme.grid2.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(context),
                SizedBox(width: HotelTheme.grid2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTopRow(context),
                      SizedBox(height: HotelTheme.grid1.h),
                      if (hotel.address != null &&
                          hotel.address!.isNotEmpty)
                        Text(
                          hotel.address!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (hotel.features.isNotEmpty) ...[
                        SizedBox(height: HotelTheme.grid1.h),
                        Wrap(
                          spacing: HotelTheme.grid1.w,
                          runSpacing: HotelTheme.grid1.h,
                          children: hotel.features
                              .take(3)
                              .map((f) => HotelFeatureChip(label: f))
                              .toList(),
                        ),
                      ],
                      SizedBox(height: HotelTheme.grid2.h),
                      _buildBottomRow(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(HotelTheme.imageRadius),
      child: Container(
        width: 112.w,
        height: 106.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.12),
              theme.colorScheme.primary.withValues(alpha: 0.06),
            ],
          ),
        ),
        child: hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: hotel.imageUrl!,
                fit: BoxFit.cover,
                width: 112.w,
                height: 106.h,
                errorWidget: (_, __, ___) => _placeholderImage(context),
              )
            : _placeholderImage(context),
      ),
    );
  }

  Widget _placeholderImage(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Icon(Icons.hotel_rounded,
          size: 40.sp,
          color: theme.colorScheme.primary.withValues(alpha: 0.5)),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            hotel.name,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: theme.colorScheme.onSurface,
              height: 1.35,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (hotel.tagBadge != null) ...[
          SizedBox(width: HotelTheme.grid1.w),
          _tagBadge(hotel.tagBadge!),
        ],
        if (hotel.score != null) ...[
          SizedBox(width: HotelTheme.grid1.w),
          HotelRatingBadge(score: hotel.score!),
        ],
      ],
    );
  }

  static String _tagBadgeLabel(HotelTagBadge badge) {
    switch (badge) {
      case HotelTagBadge.comfort:
        return '舒适';
      case HotelTagBadge.premium:
        return '高端';
      case HotelTagBadge.hot:
        return '热门';
    }
  }

  Widget _tagBadge(HotelTagBadge badge) {
    final label = _tagBadgeLabel(badge);
    late final Color bg;
    late final Color fg;
    switch (badge) {
      case HotelTagBadge.comfort:
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1976D2);
        break;
      case HotelTagBadge.premium:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
      case HotelTagBadge.hot:
        bg = const Color(0xFFFFEBEE);
        fg = AppColors.accentRed;
        break;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.overline.copyWith(
          color: fg,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '¥',
                    style: AppTextStyles.priceSmall.copyWith(fontSize: 14.sp),
                  ),
                  Text(
                    hotel.price.toStringAsFixed(0),
                    style:
                        AppTextStyles.priceLarge.copyWith(fontSize: 20.sp),
                  ),
                  Text(
                    ' 起',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
              if (hotel.discountAmount != null &&
                  hotel.discountAmount! > 0) ...[
                SizedBox(height: 4.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.price.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '已减${hotel.discountAmount}',
                    style: AppTextStyles.overline.copyWith(
                      color: AppColors.price,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        HotelGradientButton(
          label: viewDetailLabel,
          onTap: onTap,
        ),
      ],
    );
  }
}
