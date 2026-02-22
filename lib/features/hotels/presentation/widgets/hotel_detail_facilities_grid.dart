import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import 'hotel_ui_constants.dart';

/// 酒店设施网格：图标 + 文案（wifi、早餐、停车、健身房等）
class HotelDetailFacilitiesGrid extends StatelessWidget {
  const HotelDetailFacilitiesGrid({
    super.key,
    required this.facilities,
    this.iconsMap,
  });

  final List<String> facilities;

  /// 可选：设施名 -> 图标 映射，未给则用默认图标
  final Map<String, IconData>? iconsMap;

  static const Map<String, IconData> _defaultIcons = {
    '免费WiFi': Icons.wifi_rounded,
    'wifi': Icons.wifi_rounded,
    'WiFi': Icons.wifi_rounded,
    '早餐': Icons.restaurant_rounded,
    '餐厅': Icons.restaurant_rounded,
    '停车场': Icons.local_parking_rounded,
    '停车': Icons.local_parking_rounded,
    '健身房': Icons.fitness_center_rounded,
    '游泳池': Icons.pool_rounded,
    '温泉': Icons.spa_rounded,
    '酒吧': Icons.local_bar_rounded,
    '接站服务': Icons.directions_car_rounded,
    '行李寄存': Icons.luggage_rounded,
    '24小时前台': Icons.support_agent_rounded,
    '观景台': Icons.visibility_rounded,
  };

  IconData _iconFor(String name) {
    if (iconsMap != null && iconsMap!.containsKey(name)) return iconsMap![name]!;
    return _defaultIcons[name] ?? Icons.check_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    if (facilities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            '酒店设施',
            style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final crossAxisCount = width > 600 ? 4 : (width > 400 ? 3 : 2);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: HotelUIConstants.grid2.h,
                crossAxisSpacing: HotelUIConstants.grid2.w,
                childAspectRatio: 0.85,
              ),
          itemCount: facilities.length,
          itemBuilder: (_, i) {
            final name = facilities[i];
            return _FacilityChip(
              icon: _iconFor(name),
              label: name,
            );
          },
        );
          },
        ),
      ],
    );
  }
}

class _FacilityChip extends StatelessWidget {
  const _FacilityChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(HotelUIConstants.chipRadius),
          ),
          child: Icon(icon, size: 24.sp, color: theme.colorScheme.primary),
        ),
        SizedBox(height: HotelUIConstants.grid1.h),
        Text(
          label,
          style: AppTextStyles.overline.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11.sp,
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
