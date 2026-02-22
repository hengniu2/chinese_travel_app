import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/design_system/design_system.dart';
import '../theme/hotel_theme.dart';

/// Small feature/facility chip (e.g. "免费WiFi", "早餐").
class HotelFeatureChip extends StatelessWidget {
  const HotelFeatureChip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: HotelTheme.grid1.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surface.withValues(alpha: 0.5)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(HotelTheme.chipRadius),
        border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.4), width: 0.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.overline.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
