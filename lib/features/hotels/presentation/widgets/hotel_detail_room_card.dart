import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/design_system/app_tap_scale.dart';
import '../../../../shared/design_system/app_shadow.dart';
import '../../domain/hotel_detail.dart';
import 'hotel_ui_constants.dart';

/// Premium room card: image, title, features, price, book CTA, expandable plans.
class HotelDetailRoomCard extends StatefulWidget {
  const HotelDetailRoomCard({
    super.key,
    required this.room,
    required this.hotelId,
    required this.roomIndex,
  });

  final RoomType room;
  final String hotelId;
  final int roomIndex;

  @override
  State<HotelDetailRoomCard> createState() => _HotelDetailRoomCardState();
}

class _HotelDetailRoomCardState extends State<HotelDetailRoomCard> {
  bool _plansExpanded = false;

  @override
  Widget build(BuildContext context) {
    final room = widget.room;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(HotelUIConstants.cardRadius),
        boxShadow: isDark ? null : AppShadow.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(HotelUIConstants.grid2.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(room, theme),
                SizedBox(width: HotelUIConstants.grid2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: AppTextStyles.headlineSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (room.featuresSummary != null && room.featuresSummary!.isNotEmpty) ...[
                        SizedBox(height: 8.h),
                        Text(
                          room.featuresSummary!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '¥',
                            style: AppTextStyles.priceSmall.copyWith(fontSize: 14.sp),
                          ),
                          Text(
                            room.price.toStringAsFixed(0),
                            style: AppTextStyles.priceLarge.copyWith(fontSize: 20.sp),
                          ),
                          Text(
                            ' /晚',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      if (room.stockStatus != RoomStockStatus.soldOut)
                        AppTapScale(
                          onTap: () => context.push(
                            '/hotels/${widget.hotelId}/order?roomIndex=${widget.roomIndex}',
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: HotelUIConstants.grid2.w,
                              vertical: HotelUIConstants.grid1.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.primaryDark, AppColors.primary],
                              ),
                              borderRadius: BorderRadius.circular(HotelUIConstants.buttonRadius),
                              boxShadow: theme.brightness == Brightness.dark
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        offset: const Offset(0, 2),
                                        blurRadius: 6,
                                      ),
                                    ],
                            ),
                            child: Text(
                              '订',
                              style: AppTextStyles.label.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '售罄',
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (room.pricePlans.isNotEmpty)
            _ExpandablePlans(
              expanded: _plansExpanded,
              plans: room.pricePlans,
              onToggle: () => setState(() => _plansExpanded = !_plansExpanded),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(RoomType room, ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(HotelUIConstants.imageRadius),
      child: Container(
        width: 100.w,
        height: 96.h,
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        child: room.imageUrl != null && room.imageUrl!.isNotEmpty
            ? Image.network(
                room.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(theme),
              )
            : _placeholder(theme),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Center(
      child: Icon(
        Icons.bed_rounded,
        size: 36.sp,
        color: theme.colorScheme.primary.withValues(alpha: 0.5),
      ),
    );
  }
}

class _ExpandablePlans extends StatelessWidget {
  const _ExpandablePlans({
    required this.expanded,
    required this.plans,
    required this.onToggle,
  });

  final bool expanded;
  final List<RoomPricePlan> plans;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: AppColors.surface.withValues(alpha: 0.6),
          child: InkWell(
            onTap: onToggle,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    expanded ? '收起价格方案' : '展开价格方案',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOut,
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: expanded
              ? Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: plans.map((p) {
                      final isRefundable = p.label.contains('免费取消') || p.label.contains('限时免费取消');
                      final isNonRefundable = p.label.contains('不可取消');
                      final labelColor = isRefundable
                          ? AppColors.primary
                          : isNonRefundable
                              ? AppColors.textTertiary
                              : AppColors.textSecondary;
                      return Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              p.label,
                              style: AppTextStyles.bodySmall.copyWith(color: labelColor, fontWeight: isRefundable || isNonRefundable ? FontWeight.w500 : null),
                            ),
                            if (p.price != null)
                              Text(
                                '¥${p.price!.toStringAsFixed(0)}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.price,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
