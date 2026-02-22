import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/travel_package.dart';
import 'package_data_state.dart';
import 'travel_filter_state.dart';

/// Parses group size string (e.g. "2-8人", "10人") and returns true if it overlaps [minSize, maxSize].
bool _groupSizeInRange(String groupSizeStr, int minSize, int maxSize) {
  final s = groupSizeStr.replaceAll(RegExp(r'[^\d\-]'), ' ').trim();
  final parts = s.split(RegExp(r'\s+'));
  int? a;
  int? b;
  for (final p in parts) {
    if (p.contains('-')) {
      final range = p.split('-');
      if (range.length == 2) {
        a = int.tryParse(range[0].trim());
        b = int.tryParse(range[1].trim());
        break;
      }
    } else {
      final n = int.tryParse(p);
      if (n != null) {
        a = n;
        b = n;
        break;
      }
    }
  }
  if (a == null || b == null) return false;
  return !(b < minSize || a > maxSize);
}

/// Category tab for discovery: All | Group | Small Group | Family | Custom | Local.
enum DiscoveryCategory {
  all,
  group,
  smallGroup,
  family,
  custom,
  local,
}

/// Sort options for discovery list.
enum DiscoverySortOption {
  recommended,
  priceAsc,
  priceDesc,
  durationAsc,
  durationDesc,
  rating,
}

/// Discovery UI state: search, category, sort, advanced filter open.
class DiscoveryState {
  const DiscoveryState({
    this.searchQuery = '',
    this.category = DiscoveryCategory.all,
    this.sortOption = DiscoverySortOption.recommended,
    this.isAdvancedFilterOpen = false,
  });

  final String searchQuery;
  final DiscoveryCategory category;
  final DiscoverySortOption sortOption;
  final bool isAdvancedFilterOpen;

  DiscoveryState copyWith({
    String? searchQuery,
    DiscoveryCategory? category,
    DiscoverySortOption? sortOption,
    bool? isAdvancedFilterOpen,
  }) {
    return DiscoveryState(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      sortOption: sortOption ?? this.sortOption,
      isAdvancedFilterOpen: isAdvancedFilterOpen ?? this.isAdvancedFilterOpen,
    );
  }
}

final discoveryStateProvider =
    StateNotifierProvider<DiscoveryStateNotifier, DiscoveryState>(
  (ref) => DiscoveryStateNotifier(),
);

class DiscoveryStateNotifier extends StateNotifier<DiscoveryState> {
  DiscoveryStateNotifier() : super(const DiscoveryState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(DiscoveryCategory category) {
    state = state.copyWith(category: category);
  }

  void setSortOption(DiscoverySortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void setAdvancedFilterOpen(bool open) {
    state = state.copyWith(isAdvancedFilterOpen: open);
  }
}

/// Favorites: set of package IDs. Toggle by id.
final discoveryFavoritesProvider = StateProvider<Set<String>>((ref) => {});

void toggleDiscoveryFavorite(WidgetRef ref, String packageId) {
  ref.read(discoveryFavoritesProvider.notifier).update((set) {
    final next = Set<String>.from(set);
    if (next.contains(packageId)) {
      next.remove(packageId);
    } else {
      next.add(packageId);
    }
    return next;
  });
}

/// Page size for lazy loading.
const int _kDiscoveryPageSize = 10;

/// Current page index for discovery list (0-based).
final discoveryPageProvider = StateProvider<int>((ref) => 0);

/// Filtered, sorted, paginated list for discovery.
/// Depends on: package list, filter state, discovery state (search, category, sort).
final discoveryFilteredListProvider = Provider<AsyncValue<List<TravelPackage>>>((ref) {
  final packagesAsync = ref.watch(travelPackageListProvider);
  final filter = ref.watch(travelFilterStateProvider);
  final discovery = ref.watch(discoveryStateProvider);

  return packagesAsync.when(
    data: (all) {
      var list = List<TravelPackage>.from(all);

      // Search: title, subtitle, destinations
      final q = discovery.searchQuery.trim().toLowerCase();
      if (q.isNotEmpty) {
        list = list.where((p) {
          final title = p.title.toLowerCase();
          final subtitle = p.subtitle.toLowerCase();
          final dest = p.destinations.join(' ').toLowerCase();
          return title.contains(q) || subtitle.contains(q) || dest.contains(q);
        }).toList();
      }

      // Category: simple tag/theme/groupSize match
      switch (discovery.category) {
        case DiscoveryCategory.all:
          break;
        case DiscoveryCategory.group:
          list = list.where((p) => (p.groupSize ?? '').contains('人')).toList();
          break;
        case DiscoveryCategory.smallGroup:
          list = list.where((p) {
            final g = p.groupSize ?? '';
            return g.contains('2') || g.contains('4') || g.contains('6') || g.contains('小');
          }).toList();
          break;
        case DiscoveryCategory.family:
          list = list.where((p) =>
              p.themes.any((t) => t.contains('亲子') || t.contains('家庭')) ||
              p.tags.any((t) => t.contains('亲子') || t.contains('家庭'))).toList();
          break;
        case DiscoveryCategory.custom:
          list = list.where((p) =>
              p.tags.any((t) => t.contains('定制') || t.contains('Custom'))).toList();
          break;
        case DiscoveryCategory.local:
          list = list.where((p) =>
              p.themes.any((t) => t.contains('周边') || t.contains('Local')) ||
              p.tags.any((t) => t.contains('周边'))).toList();
          break;
      }

      // Advanced filter: departure, duration, price, themes, group size, accommodation, transport
      if (filter.departureCity != null && filter.departureCity!.isNotEmpty) {
        list = list.where((p) =>
            p.departureCity?.toLowerCase().trim() == filter.departureCity!.toLowerCase().trim()).toList();
      }
      // Duration: legacy min/max or multi-select ranges
      if (filter.selectedDurationRanges.isNotEmpty) {
        list = list.where((p) {
          final d = p.durationDays ?? 0;
          return filter.selectedDurationRanges.any((rangeId) {
            switch (rangeId) {
              case '1-3': return d >= 1 && d <= 3;
              case '4-7': return d >= 4 && d <= 7;
              case '8-14': return d >= 8 && d <= 14;
              case '15+': return d >= 15;
              default: return false;
            }
          });
        }).toList();
      } else {
        if (filter.durationDaysMin != null) {
          list = list.where((p) => (p.durationDays ?? 0) >= filter.durationDaysMin!).toList();
        }
        if (filter.durationDaysMax != null) {
          list = list.where((p) => (p.durationDays ?? 999) <= filter.durationDaysMax!).toList();
        }
      }
      if (filter.priceMin != null) {
        list = list.where((p) => p.price >= filter.priceMin!).toList();
      }
      if (filter.priceMax != null) {
        list = list.where((p) => p.price <= filter.priceMax!).toList();
      }
      if (filter.themes.isNotEmpty) {
        list = list.where((p) =>
            filter.themes.any((t) => p.themes.any((pt) => pt.toLowerCase().contains(t.toLowerCase())))).toList();
      }
      if (filter.selectedGroupSizes.isNotEmpty) {
        list = list.where((p) {
          final g = p.groupSize ?? '';
          return filter.selectedGroupSizes.any((sizeId) {
            if (g.isEmpty) return sizeId == 'solo';
            final lower = g.toLowerCase();
            switch (sizeId) {
              case 'solo': return lower.contains('1') && !lower.contains('2');
              case '2-4': return _groupSizeInRange(g, 2, 4);
              case '5-9': return _groupSizeInRange(g, 5, 9);
              case '10+': return _groupSizeInRange(g, 10, 999);
              default: return false;
            }
          });
        }).toList();
      } else if (filter.groupSize != null && filter.groupSize!.isNotEmpty) {
        list = list.where((p) =>
            p.groupSize?.toLowerCase().contains(filter.groupSize!.toLowerCase()) ?? false).toList();
      }
      if (filter.selectedAccommodationLevels.isNotEmpty) {
        list = list.where((p) {
          final tagsThemes = (p.tags + p.themes).join(' ').toLowerCase();
          return filter.selectedAccommodationLevels.any((level) {
            switch (level) {
              case 'economy': return tagsThemes.contains('经济') || tagsThemes.contains('economy');
              case 'comfort': return tagsThemes.contains('舒适') || tagsThemes.contains('comfort') || tagsThemes.contains('三星') || tagsThemes.contains('四星');
              case 'premium': return tagsThemes.contains('高端') || tagsThemes.contains('premium') || tagsThemes.contains('四星') || tagsThemes.contains('五星');
              case 'luxury': return tagsThemes.contains('奢华') || tagsThemes.contains('luxury') || tagsThemes.contains('五星');
              default: return false;
            }
          });
        }).toList();
      }
      if (filter.transportationTypes.isNotEmpty) {
        list = list.where((p) {
          final tagsThemes = (p.tags + p.themes).join(' ').toLowerCase();
          return filter.transportationTypes.any((type) {
            switch (type) {
              case 'flight': return tagsThemes.contains('飞机') || tagsThemes.contains('flight') || tagsThemes.contains('航空');
              case 'train': return tagsThemes.contains('高铁') || tagsThemes.contains('火车') || tagsThemes.contains('train');
              case 'bus': return tagsThemes.contains('大巴') || tagsThemes.contains('bus') || tagsThemes.contains('汽车');
              case 'self_drive': return tagsThemes.contains('自驾') || tagsThemes.contains('self') || tagsThemes.contains('drive');
              default: return false;
            }
          });
        }).toList();
      }

      // Sort
      switch (discovery.sortOption) {
        case DiscoverySortOption.recommended:
          break;
        case DiscoverySortOption.priceAsc:
          list.sort((a, b) => a.price.compareTo(b.price));
          break;
        case DiscoverySortOption.priceDesc:
          list.sort((a, b) => b.price.compareTo(a.price));
          break;
        case DiscoverySortOption.durationAsc:
          list.sort((a, b) => (a.durationDays ?? 0).compareTo(b.durationDays ?? 0));
          break;
        case DiscoverySortOption.durationDesc:
          list.sort((a, b) => (b.durationDays ?? 0).compareTo(a.durationDays ?? 0));
          break;
        case DiscoverySortOption.rating:
          list.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
          break;
      }

      return AsyncValue.data(list);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

/// Visible list for discovery: first (page+1)*pageSize items (lazy load more).
final discoveryVisibleListProvider = Provider<AsyncValue<List<TravelPackage>>>((ref) {
  final filtered = ref.watch(discoveryFilteredListProvider);
  final page = ref.watch(discoveryPageProvider);

  return filtered.when(
    data: (list) {
      final end = ((page + 1) * _kDiscoveryPageSize).clamp(0, list.length);
      return AsyncValue.data(list.sublist(0, end));
    },
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});

/// Total filtered count (for "load more" and empty state).
final discoveryFilteredCountProvider = Provider<AsyncValue<int>>((ref) {
  final filtered = ref.watch(discoveryFilteredListProvider);
  return filtered.when(
    data: (list) => AsyncValue.data(list.length),
    loading: () => const AsyncValue.loading(),
    error: (e, st) => AsyncValue.error(e, st),
  );
});
