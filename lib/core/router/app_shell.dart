import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/design_system/design_system.dart';
import 'app_router.dart';

/// 底部 5 Tab 壳 · 卡通风：浮动圆角条、选中渐变圆底、柔和未选
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static const double _kBarTopRadius = 20;
  static const double _kIndicatorRadius = 16;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final index = navigationShell.currentIndex;
    // Outlined icons only, dark stroke — same style as Profile "My orders" section
    final destinations = [
      (icon: Icons.home_outlined, label: l10n.tabHome),
      (icon: Icons.groups_outlined, label: l10n.tabJoinUs),
      (icon: Icons.explore_outlined, label: l10n.tabPlanner),
      (icon: Icons.chat_bubble_outline_rounded, label: l10n.tabMessages),
      (icon: Icons.person_outline_rounded, label: l10n.tabProfile),
    ];

    final primary = colorScheme.primary;
    final primaryContainer = colorScheme.primaryContainer;
    final onPrimary = colorScheme.onPrimary;
    final surface = colorScheme.surface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(_kBarTopRadius)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, -2),
              blurRadius: 12,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (i) {
                final d = destinations[i];
                final selected = i == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => _onTap(context, i),
                    borderRadius: BorderRadius.circular(_kIndicatorRadius),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primaryPale : Colors.transparent,
                        borderRadius: BorderRadius.circular(_kIndicatorRadius),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.12),
                                  offset: const Offset(0, 2),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: selected ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            child: Container(
                              width: 48.w,
                              height: 48.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary.withValues(alpha: 0.16)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                d.icon,
                                size: 26.sp,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.iconOutlineOnLight,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            d.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10.sp,
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.iconOutlineOnLight,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    final paths = [
      '/${RouteNames.home}',
      '/${RouteNames.joinUs}',
      '/${RouteNames.planner}',
      '/${RouteNames.messages}',
      '/${RouteNames.profile}',
    ];
    if (index < paths.length) {
      context.go(paths[index]);
      navigationShell.goBranch(index);
    }
  }
}
