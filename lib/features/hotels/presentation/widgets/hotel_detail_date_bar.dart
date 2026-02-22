import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/design_system/app_shadow.dart';
import 'hotel_ui_constants.dart';

/// Premium date bar: check-in — nights — check-out, tappable.
class HotelDetailDateBar extends StatelessWidget {
  const HotelDetailDateBar({
    super.key,
    required this.checkIn,
    required this.checkOut,
    this.onTap,
  });

  final DateTime checkIn;
  final DateTime checkOut;
  final VoidCallback? onTap;

  int get _nights => checkOut.difference(checkIn).inDays;

  String _formatDate(DateTime d) => '${d.month.toString().padLeft(2, '0')}月${d.day.toString().padLeft(2, '0')}日';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: '入住 ${_formatDate(checkIn)} 离店 ${_formatDate(checkOut)} 共$_nights晚',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(HotelUIConstants.imageRadius),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w, vertical: HotelUIConstants.grid2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(HotelUIConstants.imageRadius),
              border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
              boxShadow: AppShadow.light,
            ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatDate(checkIn)} 入住',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: HotelUIConstants.grid2.w, vertical: HotelUIConstants.grid1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  '共$_nights晚',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
              ),
              Text(
                '${_formatDate(checkOut)} 离店',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
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
