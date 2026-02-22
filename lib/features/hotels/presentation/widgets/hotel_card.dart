import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/hotel_item.dart';
import 'hotel_ui_constants.dart';

/// Premium hotel list card: 8px grid, elevation, typography hierarchy, tap feedback.
/// Responsive: works in 1-col list (phone) and 2-col grid (tablet).
class HotelCard extends StatelessWidget {
  const HotelCard({
    super.key,
    required this.hotel,
    this.viewDetailLabel = '查看详情',
    this.onTap,
    /// Optional cache dimensions for list image (reduces memory; use ~2x logical size).
    this.imageCacheWidth,
    this.imageCacheHeight,
    /// Compare: show "加入对比" or "已对比" and handle tap.
    this.isInCompare = false,
    this.canAddToCompare = false,
    this.onCompareTap,
  });

  final HotelItem hotel;
  final String viewDetailLabel;
  final VoidCallback? onTap;
  final int? imageCacheWidth;
  final int? imageCacheHeight;
  final bool isInCompare;
  final bool canAddToCompare;
  final VoidCallback? onCompareTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      label: '${hotel.name}，${hotel.price.toStringAsFixed(0)}元起',
      child: AppTapScale(
        onTap: onTap,
        pressedScale: 0.96,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(HotelUIConstants.cardRadius),
            boxShadow: isDark
                ? null
                : AppShadow.cardElevated,
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(HotelUIConstants.grid2.w),
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(context),
              SizedBox(width: HotelUIConstants.grid2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTopRow(context),
                    SizedBox(height: HotelUIConstants.grid1.h),
                    if (hotel.address != null && hotel.address!.isNotEmpty)
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
                      SizedBox(height: HotelUIConstants.grid1.h),
                      Wrap(
                        spacing: HotelUIConstants.grid1.w,
                        runSpacing: HotelUIConstants.grid1.h,
                        children: hotel.features.take(3).map((f) => _featureChip(context, f)).toList(),
                      ),
                    ],
                    if (onCompareTap != null && (isInCompare || canAddToCompare)) ...[
                      SizedBox(height: HotelUIConstants.grid1.h),
                      _buildCompareChip(context),
                    ],
                    SizedBox(height: HotelUIConstants.grid2.h),
                    _buildBottomRow(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildImage(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(HotelUIConstants.imageRadius),
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
                memCacheWidth: imageCacheWidth,
                memCacheHeight: imageCacheHeight,
                errorWidget: (_, __, ___) => _placeholderImage(context),
              )
            : _placeholderImage(context),
      ),
    );
  }

  Widget _placeholderImage(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Icon(Icons.hotel_rounded, size: 40.sp, color: theme.colorScheme.primary.withValues(alpha: 0.5)),
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
          SizedBox(width: HotelUIConstants.grid1.w),
          _tagBadge(hotel.tagBadge!),
        ],
        if (hotel.score != null) ...[
          SizedBox(width: HotelUIConstants.grid1.w),
          _ratingPill(),
        ],
      ],
    );
  }

  String _tagBadgeLabel(HotelTagBadge badge) {
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
    Color bg;
    Color fg;
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

  Widget _ratingPill() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        '${hotel.score!.toStringAsFixed(1)} 分',
        style: AppTextStyles.overline.copyWith(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _featureChip(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid1.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? theme.colorScheme.surface.withValues(alpha: 0.5) : AppColors.surface,
        borderRadius: BorderRadius.circular(HotelUIConstants.chipRadius),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.4), width: 0.5),
      ),
      child: Text(
        text,
        style: AppTextStyles.overline.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Widget _buildCompareChip(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onCompareTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isInCompare
                ? AppColors.primaryPale
                : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(HotelUIConstants.chipRadius),
            border: Border.all(
              color: isInCompare ? AppColors.primary : theme.colorScheme.outline.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isInCompare ? Icons.check_circle_rounded : Icons.compare_arrows_rounded,
                size: 14.sp,
                color: isInCompare ? AppColors.primary : theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 4.w),
              Text(
                isInCompare ? '已对比' : '加入对比',
                style: AppTextStyles.overline.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: isInCompare ? AppColors.primary : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
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
                    style: AppTextStyles.priceLarge.copyWith(fontSize: 20.sp),
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
              if (hotel.discountAmount != null && hotel.discountAmount! > 0) ...[
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
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
        _ViewDetailButton(
          label: viewDetailLabel,
          onPressed: onTap,
        ),
      ],
    );
  }
}

class _ViewDetailButton extends StatelessWidget {
  const _ViewDetailButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: label,
      child: AppTapScale(
        onTap: onPressed,
        pressedScale: 0.96,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: HotelUIConstants.grid2.w,
            vertical: HotelUIConstants.grid1.h,
          ),
          constraints: BoxConstraints(minHeight: HotelUIConstants.minTouchTarget - 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark,
                AppColors.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(HotelUIConstants.buttonRadius),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
