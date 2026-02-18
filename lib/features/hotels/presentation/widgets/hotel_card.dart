import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../domain/hotel_item.dart';

/// 酒店列表卡片
class HotelCard extends StatelessWidget {
  const HotelCard({
    super.key,
    required this.hotel,
    this.onTap,
  });

  final HotelItem hotel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: AppRadius.cardRadius,
            boxShadow: [
              ...AppShadow.card,
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          ...List.generate(hotel.star, (_) => Icon(Icons.star_rounded, size: 14.sp, color: AppColors.warning)),
                          if (hotel.score != null) ...[
                            SizedBox(width: 6.w),
                            Text('${hotel.score}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                            Text('分', style: AppTextStyles.label.copyWith(color: AppColors.textTertiary)),
                          ],
                        ],
                      ),
                      if (hotel.address != null && hotel.address!.isNotEmpty) ...[
                        SizedBox(height: 6.h),
                        Text(
                          hotel.address!,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (hotel.tags.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 4.h,
                          children: hotel.tags.map((t) => _tag(t)).toList(),
                        ),
                      ],
                      SizedBox(height: 10.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('¥', style: AppTextStyles.priceSmall.copyWith(fontSize: 12.sp)),
                          Text(
                            hotel.price.toStringAsFixed(0),
                            style: AppTextStyles.price.copyWith(fontSize: 18.sp),
                          ),
                          Text(' 起', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 12.sp)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 120.w,
      height: 110.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryLight2, AppColors.primaryLight],
        ),
      ),
      child: Center(
        child: Icon(Icons.hotel_rounded, size: 36.sp, color: AppColors.primary.withValues(alpha: 0.5)),
      ),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.label.copyWith(fontSize: 10.sp, color: AppColors.textSecondary),
      ),
    );
  }
}
