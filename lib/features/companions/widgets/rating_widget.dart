import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';

/// 评分展示：星标 + 分数 + 可选后缀（如评价数、已服务次数）
class RatingWidget extends StatelessWidget {
  const RatingWidget({
    super.key,
    required this.rating,
    this.iconSize,
    this.fontSize,
    this.suffix,
    this.starColor,
    this.showStarsOnly = false,
    this.starCount = 5,
  });

  final double rating;
  final double? iconSize;
  final double? fontSize;
  final String? suffix;
  /// Star color; default accentGold. Use accentWarm for orange star.
  final Color? starColor;
  final bool showStarsOnly;
  final int starCount;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? 14.sp;
    final fs = fontSize ?? 12.sp;
    final color = starColor ?? AppColors.accentGold;

    if (showStarsOnly) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          starCount,
          (i) => Icon(
            i < rating.round().clamp(0, starCount)
                ? Icons.star_rounded
                : Icons.star_border_rounded,
            size: size,
            color: color,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: color),
        SizedBox(width: 4.w),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: fs,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (suffix != null && suffix!.isNotEmpty) ...[
          SizedBox(width: 6.w),
          Text(
            suffix!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
              fontSize: fs - 1,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
