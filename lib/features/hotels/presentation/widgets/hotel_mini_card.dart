import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/hotel_item.dart';
import 'hotel_ui_constants.dart';

/// Compact hotel card for map bottom sheet. Yellow left border when [isActive].
class HotelMiniCard extends StatelessWidget {
  const HotelMiniCard({
    super.key,
    required this.hotel,
    required this.isActive,
    this.onTap,
  });

  final HotelItem hotel;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(HotelUIConstants.cardRadius),
      child: InkWell(
        onTap: onTap ?? () => context.push('/hotels/${hotel.id}'),
        borderRadius: BorderRadius.circular(HotelUIConstants.cardRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HotelUIConstants.cardRadius),
            border: Border(
              left: BorderSide(
                color: isActive ? AppColors.primary : Colors.transparent,
                width: 4,
              ),
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          padding: EdgeInsets.all(HotelUIConstants.grid2.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(HotelUIConstants.imageRadius),
                child: hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: hotel.imageUrl!,
                        width: 72.w,
                        height: 72.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          alignment: Alignment.center,
                          child: Icon(Icons.hotel_rounded, color: theme.colorScheme.primary),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: theme.colorScheme.surfaceContainerHighest,
                          alignment: Alignment.center,
                          child: Icon(Icons.hotel_rounded, color: theme.colorScheme.primary),
                        ),
                      )
                    : Container(
                        width: 72.w,
                        height: 72.w,
                        color: theme.colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(Icons.hotel_rounded, color: theme.colorScheme.primary),
                      ),
              ),
              SizedBox(width: HotelUIConstants.grid2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hotel.name,
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hotel.score != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        '${hotel.score!.toStringAsFixed(1)}分',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    SizedBox(height: 6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '¥',
                          style: AppTextStyles.priceSmall.copyWith(fontSize: 12.sp),
                        ),
                        Text(
                          hotel.price.toStringAsFixed(0),
                          style: AppTextStyles.priceLarge.copyWith(fontSize: 18.sp),
                        ),
                        Text(
                          ' 起',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 12.sp,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
