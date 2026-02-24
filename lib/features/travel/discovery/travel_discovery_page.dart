import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../state/state.dart';
import 'discovery_package_card.dart';
import 'discovery_filter_sheet.dart';

/// Discovery marketplace: search, category tabs, filter chips, vertical cards,
/// pull to refresh, skeleton, empty state, sort & advanced filter.
class TravelDiscoveryPage extends ConsumerStatefulWidget {
  const TravelDiscoveryPage({super.key});

  @override
  ConsumerState<TravelDiscoveryPage> createState() => _TravelDiscoveryPageState();
}

class _TravelDiscoveryPageState extends ConsumerState<TravelDiscoveryPage> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final discovery = ref.read(discoveryStateProvider);
      _searchController.text = discovery.searchQuery;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final discovery = ref.watch(discoveryStateProvider);
    final visibleAsync = ref.watch(discoveryVisibleListProvider);
    final countAsync = ref.watch(discoveryFilteredCountProvider);
    final favorites = ref.watch(discoveryFavoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.warmBackground,
      appBar: AppBar(
        backgroundColor: AppColors.homeSearchCapsule,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: _SearchBar(
          controller: _searchController,
          focusNode: _searchFocus,
          hint: l10n.discoverySearchHint,
          onChanged: (v) {
            ref.read(discoveryStateProvider.notifier).setSearchQuery(v);
            ref.read(discoveryPageProvider.notifier).state = 0;
          },
        ),
        actions: [
          _FilterIconWithBadge(
            activeCount: ref.watch(travelFilterStateProvider).activeFilterCount,
            onPressed: () => _openAdvancedFilter(context, ref, l10n),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(travelPackageListProvider);
          ref.read(discoveryPageProvider.notifier).state = 0;
          await ref.read(travelPackageListProvider.future);
        },
        color: TravelDesignTokens.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.homeSearchCapsule,
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CategoryTabs(
                      selected: discovery.category,
                      onSelected: (c) {
                        ref.read(discoveryStateProvider.notifier).setCategory(c);
                        ref.read(discoveryPageProvider.notifier).state = 0;
                      },
                      l10n: l10n,
                    ),
                    _FilterChips(
                      filter: ref.watch(travelFilterStateProvider),
                      sortOption: discovery.sortOption,
                      l10n: l10n,
                      onOpenAdvanced: () => _openAdvancedFilter(context, ref, l10n),
                      onOpenSort: () => _openSortSheet(context, ref, l10n),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.homeSectionGreen,
                  border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
                ),
              ),
            ),
            visibleAsync.when(
              data: (list) {
                if (list.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyDiscovery(
                      l10n: l10n,
                      onClearFilters: () {
                        ref.read(travelFilterStateProvider.notifier).clear();
                        ref.read(discoveryStateProvider.notifier).setSearchQuery('');
                        ref.read(discoveryStateProvider.notifier).setCategory(DiscoveryCategory.all);
                        ref.read(discoveryPageProvider.notifier).state = 0;
                      },
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == list.length) {
                          return countAsync.when(
                            data: (total) {
                              if (total <= list.length) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(top: 16, bottom: 24),
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      ref.read(discoveryPageProvider.notifier).state =
                                          ref.read(discoveryPageProvider) + 1;
                                    },
                                    child: Text(l10n.discoveryLoadMore),
                                  ),
                                ),
                              );
                            },
                            loading: () => const SizedBox.shrink(),
                            error: (_, Object? st) => const SizedBox.shrink(),
                          );
                        }
                        final p = list[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: DiscoveryPackageCard(
                            package: p,
                            isFavorite: favorites.contains(p.id),
                            onTap: () => context.push('/planner/detail/${p.id}'),
                            onFavoriteTap: () => toggleDiscoveryFavorite(ref, p.id),
                          ),
                        );
                      },
                      childCount: list.length + 1,
                    ),
                  ),
                );
              },
              loading: () => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: TravelSkeletonWrap(child: TravelSkeletonCard()),
                    ),
                    childCount: 6,
                  ),
                ),
              ),
              error: (e, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  message: '$e',
                  actionLabel: l10n.discoveryEmptyAction,
                  onAction: () => ref.invalidate(travelPackageListProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAdvancedFilter(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    ref.read(travelUiStateProvider.notifier).setFilterSheetOpen(true);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DiscoveryFilterSheet(
        filter: ref.read(travelFilterStateProvider),
        onApply: (next) {
          ref.read(travelFilterStateProvider.notifier).apply(next);
          ref.read(discoveryPageProvider.notifier).state = 0;
          ref.read(travelUiStateProvider.notifier).setFilterSheetOpen(false);
          Navigator.of(ctx).pop();
        },
        onClear: () {
          ref.read(travelFilterStateProvider.notifier).clear();
          ref.read(discoveryPageProvider.notifier).state = 0;
          ref.read(travelUiStateProvider.notifier).setFilterSheetOpen(false);
          Navigator.of(ctx).pop();
        },
        onDismiss: () {
          ref.read(travelUiStateProvider.notifier).setFilterSheetOpen(false);
          Navigator.of(ctx).pop();
        },
        l10n: l10n,
      ),
    ).then((_) {
      ref.read(travelUiStateProvider.notifier).setFilterSheetOpen(false);
    });
  }

  void _openSortSheet(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: TravelDesignTokens.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.discoveryChipSort,
                style: TravelDesignTokens.titleL(null),
              ),
              const SizedBox(height: 16),
              ...DiscoverySortOption.values.map((option) {
                final label = _sortLabel(option, l10n);
                final selected = ref.read(discoveryStateProvider).sortOption == option;
                return ListTile(
                  title: Text(label),
                  trailing: selected ? Icon(Icons.check_rounded, color: TravelDesignTokens.primary, size: 22) : null,
                  onTap: () {
                    ref.read(discoveryStateProvider.notifier).setSortOption(option);
                    ref.read(discoveryPageProvider.notifier).state = 0;
                    Navigator.of(ctx).pop();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  static String _sortLabel(DiscoverySortOption option, AppLocalizations l10n) {
    switch (option) {
      case DiscoverySortOption.recommended:
        return l10n.discoverySortRecommended;
      case DiscoverySortOption.priceAsc:
        return l10n.discoverySortPriceAsc;
      case DiscoverySortOption.priceDesc:
        return l10n.discoverySortPriceDesc;
      case DiscoverySortOption.durationAsc:
        return l10n.discoverySortDurationAsc;
      case DiscoverySortOption.durationDesc:
        return l10n.discoverySortDurationDesc;
      case DiscoverySortOption.rating:
        return l10n.discoverySortRating;
    }
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(Icons.search_rounded, size: 22, color: AppColors.textTertiary),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          isDense: true,
        ),
        style: TravelDesignTokens.body(AppColors.textPrimary).copyWith(fontSize: 14),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  const _CategoryTabs({
    required this.selected,
    required this.onSelected,
    required this.l10n,
  });

  final DiscoveryCategory selected;
  final ValueChanged<DiscoveryCategory> onSelected;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final categories = [
      DiscoveryCategory.all,
      DiscoveryCategory.group,
      DiscoveryCategory.smallGroup,
      DiscoveryCategory.family,
      DiscoveryCategory.custom,
      DiscoveryCategory.local,
    ];
    final labels = [
      l10n.discoveryCategoryAll,
      l10n.discoveryCategoryGroup,
      l10n.discoveryCategorySmallGroup,
      l10n.discoveryCategoryFamily,
      l10n.discoveryCategoryCustom,
      l10n.discoveryCategoryLocal,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(categories.length, (i) {
          final c = categories[i];
          final active = selected == c;
          return Padding(
            padding: EdgeInsets.only(right: i < categories.length - 1 ? 20 : 0),
            child: InkWell(
              onTap: () => onSelected(c),
              borderRadius: BorderRadius.circular(4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels[i],
                    style: TravelDesignTokens.body(active ? AppColors.textPrimary : AppColors.textTertiary).copyWith(
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 3,
                    width: 20,
                    decoration: BoxDecoration(
                      color: active ? TravelDesignTokens.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filter,
    required this.sortOption,
    required this.l10n,
    required this.onOpenAdvanced,
    required this.onOpenSort,
  });

  final TravelFilterState filter;
  final DiscoverySortOption sortOption;
  final AppLocalizations l10n;
  final VoidCallback onOpenAdvanced;
  final VoidCallback onOpenSort;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          TravelFilterChip(
            label: filter.departureCity ?? l10n.discoveryChipDeparture,
            selected: filter.departureCity != null,
            onTap: onOpenAdvanced,
          ),
          const SizedBox(width: 8),
          TravelFilterChip(
            label: filter.selectedDurationRanges.isNotEmpty
                ? '${filter.selectedDurationRanges.join(', ')} ${l10n.discoveryChipDays}'
                : (filter.durationDaysMin != null || filter.durationDaysMax != null
                    ? '${filter.durationDaysMin ?? '?'}-${filter.durationDaysMax ?? '?'} ${l10n.discoveryChipDays}'
                    : l10n.discoveryChipDays),
            selected: filter.selectedDurationRanges.isNotEmpty ||
                filter.durationDaysMin != null ||
                filter.durationDaysMax != null,
            onTap: onOpenAdvanced,
          ),
          const SizedBox(width: 8),
          TravelFilterChip(
            label: filter.priceMin != null || filter.priceMax != null
                ? '¥${filter.priceMin?.toStringAsFixed(0) ?? ''}-¥${filter.priceMax?.toStringAsFixed(0) ?? ''}'
                : l10n.discoveryChipBudget,
            selected: filter.priceMin != null || filter.priceMax != null,
            onTap: onOpenAdvanced,
          ),
          const SizedBox(width: 8),
          TravelFilterChip(
            label: filter.themes.isNotEmpty ? filter.themes.join(', ') : l10n.discoveryChipTheme,
            selected: filter.themes.isNotEmpty,
            onTap: onOpenAdvanced,
          ),
          if (filter.selectedGroupSizes.isNotEmpty || filter.selectedAccommodationLevels.isNotEmpty || filter.transportationTypes.isNotEmpty) ...[
            const SizedBox(width: 8),
            TravelFilterChip(
              label: l10n.discoveryFilterGroupSize,
              selected: true,
              onTap: onOpenAdvanced,
            ),
          ],
          const SizedBox(width: 8),
          TravelFilterChip(
            label: l10n.discoveryChipSort,
            selected: sortOption != DiscoverySortOption.recommended,
            onTap: onOpenSort,
          ),
        ],
      ),
    );
  }
}

class _EmptyDiscovery extends StatelessWidget {
  const _EmptyDiscovery({required this.l10n, required this.onClearFilters});

  final AppLocalizations l10n;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icon(
        Icons.travel_explore_rounded,
        size: 64,
        color: AppColors.textTertiary.withValues(alpha: 0.6),
      ),
      message: '${l10n.discoveryEmptyTitle}\n${l10n.discoveryEmptySubtitle}',
      actionLabel: l10n.discoveryEmptyAction,
      onAction: onClearFilters,
    );
  }
}

class _FilterIconWithBadge extends StatelessWidget {
  const _FilterIconWithBadge({
    required this.activeCount,
    required this.onPressed,
  });

  final int activeCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: const Icon(Icons.tune_rounded),
          onPressed: onPressed,
        ),
        if (activeCount > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: BoxDecoration(
                color: TravelDesignTokens.primary,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: TravelDesignTokens.card, width: 1),
              ),
              child: Text(
                activeCount > 99 ? '99+' : '$activeCount',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
