import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/design_system.dart';
import '../../../../shared/design_system/app_tap_scale.dart';
import '../../../../shared/design_system/app_shadow.dart';
import 'hotel_ui_constants.dart';

/// Premium floating actions: map, compare, chat, home — brand primary, soft elevation.
class HotelFloatingButtons extends StatelessWidget {
  const HotelFloatingButtons({
    super.key,
    this.compareCount = 0,
    this.onMapTap,
    this.onCompareTap,
    this.onChatTap,
    this.onHomeTap,
  });

  /// Number of hotels in compare list (0–3). Shows "对比" button with badge.
  final int compareCount;
  final VoidCallback? onMapTap;
  final VoidCallback? onCompareTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onHomeTap;

  static const double _spacing = 12;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: HotelUIConstants.grid2.w,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FloatingButton(
              icon: Icons.map_rounded,
              semanticLabel: '地图',
              onTap: onMapTap ?? () => context.push('/hotels/map'),
            ),
            SizedBox(height: _spacing),
            _FloatingButton(
              icon: Icons.compare_arrows_rounded,
              semanticLabel: '对比',
              badge: compareCount > 0 ? compareCount.toString() : null,
              onTap: onCompareTap ?? () => context.push('/hotels/compare'),
            ),
            SizedBox(height: _spacing),
            _FloatingButton(
              icon: Icons.chat_bubble_outline_rounded,
              semanticLabel: '客服',
              onTap: onChatTap ?? () => context.push('/messages'),
            ),
            SizedBox(height: _spacing),
            _FloatingButton(
              icon: Icons.home_rounded,
              semanticLabel: '首页',
              onTap: onHomeTap ?? () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingButton extends StatelessWidget {
  const _FloatingButton({
    required this.icon,
    required this.semanticLabel,
    this.badge,
    required this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final String? badge;
  final VoidCallback onTap;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: badge != null ? '$semanticLabel $badge' : semanticLabel,
      child: AppTapScale(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primaryDark, AppColors.primary],
                ),
                shape: BoxShape.circle,
                boxShadow: isDark
                    ? AppShadow.medium
                    : [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                        ...AppShadow.floating,
                      ],
              ),
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
            if (badge != null)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.price,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
