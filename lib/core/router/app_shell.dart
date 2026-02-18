import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'app_router.dart';

/// 底部 5 Tab 壳（仅布局，无业务逻辑）
class AppShell extends ConsumerWidget {
  const AppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.tabHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.group_outlined),
            selectedIcon: const Icon(Icons.group),
            label: AppLocalizations.of(context)!.tabJoinUs,
          ),
          NavigationDestination(
            icon: const Icon(Icons.travel_explore_outlined),
            selectedIcon: const Icon(Icons.travel_explore),
            label: AppLocalizations.of(context)!.tabPlanner,
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: AppLocalizations.of(context)!.tabMessages,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.tabProfile,
          ),
        ],
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
