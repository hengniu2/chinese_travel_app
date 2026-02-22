import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/hotel_theme.dart';

/// Skeleton matching [HotelCard] layout.
class HotelCardSkeleton extends StatelessWidget {
  const HotelCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE8EAED);
    final highlightColor =
        isDark ? const Color(0xFF3C3C3C) : const Color(0xFFF1F3F4);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1600),
      child: Container(
        padding: EdgeInsets.all(HotelTheme.grid2.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(HotelTheme.cardRadius),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 112.w,
              height: 106.h,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius:
                    BorderRadius.circular(HotelTheme.imageRadius),
              ),
            ),
            SizedBox(width: HotelTheme.grid2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Container(
                    height: 14.h,
                    width: 140.w,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: HotelTheme.grid2.h),
                  Container(
                    height: 12.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: HotelTheme.grid1.h),
                  Row(
                    children: [
                      _chip(baseColor, 56.w),
                      SizedBox(width: HotelTheme.grid1.w),
                      _chip(baseColor, 48.w),
                      SizedBox(width: HotelTheme.grid1.w),
                      _chip(baseColor, 52.w),
                    ],
                  ),
                  SizedBox(height: HotelTheme.grid2.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 20.h,
                        width: 72.w,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 36.h,
                        width: 72.w,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius:
                              BorderRadius.circular(HotelTheme.buttonRadius),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(Color color, double width) {
    return Container(
      height: 20.h,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(HotelTheme.chipRadius),
      ),
    );
  }
}
