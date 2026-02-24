import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/design_system/design_system.dart';
import '../../shared/design_system/app_tap_scale.dart';
import 'app_router.dart';

/// 底部 6 Tab 壳 · 贴底导航条：选中=青柠光晕 + 切换动效
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static const double _kIndicatorRadius = 20;
  static const Color _kUnselectedColor = Color(0xFF9E9E9E);
  static const Duration _kAnimDuration = Duration(milliseconds: 280);

  /// Tab order must match shell branch order in app_router.dart
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
    final destinations = [
      (icon: Icons.home_outlined, label: l10n.tabHome),
      (icon: Icons.explore_outlined, label: l10n.tabPlanner),
      (icon: Icons.luggage_rounded, label: l10n.tabTravelService),
      (icon: Icons.groups_outlined, label: l10n.tabJoinUs),
      (icon: Icons.chat_bubble_outline_rounded, label: l10n.tabMessages),
      (icon: Icons.person_outline_rounded, label: l10n.tabProfile),
    ];

    final surface = colorScheme.surface;

    return Scaffold(
      body: RepaintBoundary(
        child: navigationShell,
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: surface,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(destinations.length, (i) {
                  final d = destinations[i];
                  final selected = i == index;
                  return Expanded(
                    child: _NavItem(
                      icon: d.icon,
                      label: d.label,
                      selected: selected,
                      onTap: () => _onTap(context, i),
                      theme: theme,
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
      navigationShell.goBranch(index, initialLocation: true);
    }
  }
}

/// Single nav item: tap scale, active = lime glow + elastic scale-in
class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceScale;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 320),
      vsync: this,
    );
    _bounceScale = Tween<double>(begin: 1, end: 1.06).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.selected && widget.selected) {
      _bounceController.forward(from: 0).then((_) => _bounceController.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return AppTapScale(
      onTap: widget.onTap,
      pressedScale: 0.96,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppShell._kIndicatorRadius),
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          highlightColor: AppColors.primary.withValues(alpha: 0.06),
          child: AnimatedContainer(
            duration: AppShell._kAnimDuration,
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.primaryPale.withValues(alpha: 0.8) : Colors.transparent,
              borderRadius: BorderRadius.circular(AppShell._kIndicatorRadius),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: -2,
                      ),
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        blurRadius: 24,
                        spreadRadius: -4,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _bounceController,
                  builder: (context, child) {
                    final scale = selected ? (1.04 * _bounceScale.value) : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 44.w,
                    height: 44.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.95)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.5),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.35),
                                blurRadius: 20,
                                spreadRadius: -2,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 24.sp,
                      color: selected ? const Color(0xFF1A1A1A) : AppShell._kUnselectedColor,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.label,
                  style: widget.theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10.sp,
                    color: selected ? AppColors.primaryDark : AppShell._kUnselectedColor,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
