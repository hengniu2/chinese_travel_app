import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_tap_scale.dart';
import '../../../shared/design_system/app_shadow.dart';
import '../theme/hotel_theme.dart';

/// Bottom booking bar: price + gradient CTA.
class HotelDetailBookingBar extends StatelessWidget {
  const HotelDetailBookingBar({
    super.key,
    required this.lowestPrice,
    this.hotelId,
    this.buttonLabel = '查看房型',
    this.onTap,
  });

  final double lowestPrice;
  final String? hotelId;
  final String buttonLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            HotelTheme.grid2.w,
            HotelTheme.grid2.h,
            HotelTheme.grid2.w,
            HotelTheme.grid2.h + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface
                .withValues(alpha: isDark ? 0.92 : 0.98),
            boxShadow: AppShadow.heavy,
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¥${lowestPrice.toStringAsFixed(0)}',
                      style: AppTextStyles.priceLarge.copyWith(fontSize: 22.sp),
                    ),
                    Text(
                      '起',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: HotelTheme.grid3.w),
                Expanded(
                  child: Semantics(
                    button: true,
                    label: buttonLabel,
                    child: AppTapScale(
                      onTap: onTap ??
                          (hotelId != null
                              ? () => context.push('/hotels/$hotelId/order')
                              : null),
                      child: Container(
                        height: HotelTheme.minTouchTarget + 4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primaryDark,
                              AppColors.primary,
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(HotelTheme.buttonRadius),
                        ),
                        child: Text(
                          buttonLabel,
                          style: AppTextStyles.label.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
