import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/design_system/design_system.dart';
import 'app_router.dart';

/// 底部 6 Tab 壳 · 中国卡通商业风：选中=浮动渐变胶囊+缩放+光晕，未选=灰色
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static const double _kBarTopRadius = 20;
  static const double _kIndicatorRadius = 22;
  /// Unselected tab: gray icon
  static const Color _kUnselectedColor = Color(0xFF9E9E9E);

  /// Tab order must match shell branch order in app_router.dart:
  /// 0=Home, 1=Travel Planner, 2=Travel Service, 3=Companion, 4=Chat, 5=Profile
  static List<String> get _paths => [
    '/${RouteNames.home}',
    '/${RouteNames.planner}',
    '/${RouteNames.travelService}',
    '/${RouteNames.joinUs}',
    '/${RouteNames.messages}',
    '/${RouteNames.profile}',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final index = navigationShell.currentIndex;
    // Same order as _paths and app_router branches
    final destinations = [
      (icon: Icons.home_outlined, label: l10n.tabHome),             // 0 → Home
      (icon: Icons.explore_outlined, label: l10n.tabPlanner),       // 1 → Travel Planner
      (icon: Icons.luggage_rounded, label: l10n.tabTravelService),  // 2 → Travel Service
      (icon: Icons.groups_outlined, label: l10n.tabJoinUs),         // 3 → Companion
      (icon: Icons.chat_bubble_outline_rounded, label: l10n.tabMessages), // 4 → Chat
      (icon: Icons.person_outline_rounded, label: l10n.tabProfile),  // 5 → Profile
    ];

    final surface = colorScheme.surface;

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
                      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? LinearGradient(
                                colors: AppGradients.selectedNav,
                                stops: AppGradients.selectedNavStops,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: selected ? null : Colors.transparent,
                        borderRadius: BorderRadius.circular(_kIndicatorRadius),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  offset: const Offset(0, 4),
                                  blurRadius: 14,
                                ),
                                BoxShadow(
                                  color: AppColors.primaryDark.withValues(alpha: 0.2),
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
                            scale: selected ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeOutCubic,
                            child: Container(
                              width: 48.w,
                              height: 48.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: selected
                                    ? LinearGradient(
                                        colors: AppGradients.brand,
                                        stops: AppGradients.brandStops,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: selected ? null : Colors.transparent,
                                borderRadius: BorderRadius.circular(14.r),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryDark
                                              .withValues(alpha: 0.4),
                                          offset: const Offset(0, 3),
                                          blurRadius: 10,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                d.icon,
                                size: 26.sp,
                                color: selected
                                    ? Colors.white
                                    : _kUnselectedColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            d.label,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10.sp,
                              color: selected
                                  ? AppColors.primaryDark
                                  : _kUnselectedColor,
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
    if (index >= 0 && index < _paths.length) {
      // Always navigate to branch root so correct page + tab highlight stay in sync.
      navigationShell.goBranch(index, initialLocation: true);
    }
  }
}
