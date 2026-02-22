import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/design_system/app_tap_scale.dart';
import '../../../../shared/design_system/app_shadow.dart';
import 'hotel_ui_constants.dart';

/// Premium floating booking bar: glass-style surface, primary CTA, 8px grid.
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
            HotelUIConstants.grid2.w,
            HotelUIConstants.grid2.h,
            HotelUIConstants.grid2.w,
            HotelUIConstants.grid2.h + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: isDark ? 0.92 : 0.98),
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
                SizedBox(width: HotelUIConstants.grid3.w),
                Expanded(
                  child: Semantics(
                    button: true,
                    label: buttonLabel,
                    child: AppTapScale(
                      onTap: onTap ?? (hotelId != null ? () => context.push('/hotels/$hotelId/order') : null),
                      pressedScale: 0.96,
                      child: Container(
                        height: HotelUIConstants.minTouchTarget + 4,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primaryDark, AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(HotelUIConstants.buttonRadius + 2),
                          boxShadow: isDark
                              ? null
                              : [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                    offset: const Offset(0, 4),
                                    blurRadius: 12,
                                  ),
                                ],
                        ),
                        child: Text(
                          buttonLabel,
                          style: AppTextStyles.button.copyWith(
                            color: Colors.white,
                            fontSize: 16.sp,
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
