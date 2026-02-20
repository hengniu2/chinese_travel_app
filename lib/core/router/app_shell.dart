import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/design_system/design_system.dart';
import 'app_router.dart';

/// 底部 5 Tab 壳（自定义容器 + 顶部轻阴影 + 选中主色）
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final index = navigationShell.currentIndex;
    // 卡通风：圆润图标，选中绿、未选灰，icon 22-24，label 略粗
    final destinations = [
      (icon: Icons.home_rounded, selected: Icons.home_rounded, label: l10n.tabHome),
      (icon: Icons.groups_rounded, selected: Icons.groups_rounded, label: l10n.tabJoinUs),
      (icon: Icons.travel_explore_rounded, selected: Icons.travel_explore_rounded, label: l10n.tabPlanner),
      (icon: Icons.chat_bubble_rounded, selected: Icons.chat_bubble_rounded, label: l10n.tabMessages),
      (icon: Icons.person_rounded, selected: Icons.person_rounded, label: l10n.tabProfile),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -1),
              blurRadius: 4,
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (i) {
                final d = destinations[i];
                final selected = i == index;
                return InkWell(
                  onTap: () => _onTap(context, i),
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    width: 64,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          d.selected,
                          size: 23.sp,
                          color: selected ? AppColors.primary : AppColors.textTertiary,
                        ),
                        SizedBox(height: 2),
                        Text(
                          d.label,
                          style: AppTextStyles.caption.copyWith(
                            fontSize: 10.sp,
                            color: selected ? AppColors.primary : AppColors.textTertiary,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
