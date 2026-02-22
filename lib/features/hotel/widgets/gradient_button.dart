import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_tap_scale.dart';
import '../theme/hotel_theme.dart';

/// Primary CTA with gradient background.
class HotelGradientButton extends StatelessWidget {
  const HotelGradientButton({
    super.key,
    required this.label,
    this.onTap,
    this.minHeight,
  });

  final String label;
  final VoidCallback? onTap;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: label,
      child: AppTapScale(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: HotelTheme.grid2.w,
            vertical: HotelTheme.grid1.h,
          ),
          constraints: BoxConstraints(
              minHeight: minHeight ?? HotelTheme.minTouchTarget - 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark,
                AppColors.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(HotelTheme.buttonRadius),
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
