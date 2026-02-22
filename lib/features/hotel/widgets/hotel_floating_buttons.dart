import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/design_system/app_tap_scale.dart';
import '../../../shared/design_system/app_shadow.dart';
import '../theme/hotel_theme.dart';

/// Floating actions: chat, home.
class HotelFloatingButtons extends StatelessWidget {
  const HotelFloatingButtons({
    super.key,
    this.onChatTap,
    this.onHomeTap,
  });

  final VoidCallback? onChatTap;
  final VoidCallback? onHomeTap;

  static const double _spacing = 12;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: HotelTheme.grid2.w,
      top: 0,
      bottom: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
    required this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;

  static const double _size = 48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Semantics(
      button: true,
      label: semanticLabel,
      child: AppTapScale(
        onTap: onTap,
        child: Container(
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
      ),
    );
  }
}
