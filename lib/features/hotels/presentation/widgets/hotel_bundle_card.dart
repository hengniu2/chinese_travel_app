import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/design_system/design_system.dart';
import '../../domain/hotel_bundle.dart';
import 'hotel_ui_constants.dart';

/// 超值套餐推荐卡片：黄渐变高亮、原价/套餐价、节省金额、立即打包预订
class HotelBundleCard extends StatelessWidget {
  const HotelBundleCard({
    super.key,
    required this.bundle,
    required this.onBookBundle,
  });

  final HotelTicketBundle bundle;
  final VoidCallback onBookBundle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HotelUIConstants.cardRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppGradients.bundleHighlight,
          stops: AppGradients.bundleHighlightStops,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(HotelUIConstants.cardRadius),
        child: Padding(
          padding: EdgeInsets.all(HotelUIConstants.grid2.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                bundle.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (bundle.subtitle != null && bundle.subtitle!.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  bundle.subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              SizedBox(height: HotelUIConstants.grid2.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '¥${bundle.bundlePrice.toStringAsFixed(0)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.price,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '¥${bundle.originalPrice.toStringAsFixed(0)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textTertiary,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                AppLocalizations.of(context)?.hotelBundleSavings(bundle.discount.toStringAsFixed(0)) ?? bundle.savingsLabel(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: HotelUIConstants.grid2.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onBookBundle,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.iconOutlineOnLight,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(HotelUIConstants.buttonRadius),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)?.hotelBundleCta ?? '立即打包预订',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
