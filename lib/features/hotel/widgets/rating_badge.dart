import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/design_system/design_system.dart';

/// Score pill (e.g. "4.8 分").
class HotelRatingBadge extends StatelessWidget {
  const HotelRatingBadge({
    super.key,
    required this.score,
    this.suffix = ' 分',
  });

  final double score;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        '${score.toStringAsFixed(1)}$suffix',
        style: AppTextStyles.overline.copyWith(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
