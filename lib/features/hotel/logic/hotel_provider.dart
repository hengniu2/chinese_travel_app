import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/hotel_mappers.dart';
import '../data/hotel_model.dart';
import '../data/hotel_repository.dart';
import '../data/hotel_repository_mock.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Repository (swap mock for API implementation)
// ─────────────────────────────────────────────────────────────────────────────

final hotelRepositoryProvider = Provider<HotelRepository>((ref) {
  return HotelRepositoryMock(simulateNoInternet: false, simulateApiError: false);
});

// ─────────────────────────────────────────────────────────────────────────────
// List: query state
// ─────────────────────────────────────────────────────────────────────────────

class HotelListQueryState {
  const HotelListQueryState({
    this.sort = HotelSort.default_,
    this.priceMin,
    this.priceMax,
    this.star,
    this.searchKeyword = '',
    this.page = 1,
    this.pageSize = 10,
  });

  final HotelSort sort;
  final double? priceMin;
  final double? priceMax;
  final int? star;
  final String searchKeyword;
  final int page;
  final int pageSize;

  HotelListQueryState copyWith({
    HotelSort? sort,
    double? priceMin,
    double? priceMax,
    int? star,
    String? searchKeyword,
    int? page,
    int? pageSize,
  }) {
    return HotelListQueryState(
      sort: sort ?? this.sort,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      star: star ?? this.star,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  HotelListQuery toQuery() => HotelListQuery(
        page: page,
        limit: pageSize,
        sort: sort,
        priceMin: priceMin,
        priceMax: priceMax,
        star: star,
        searchKeyword:
            searchKeyword.trim().isEmpty ? null : searchKeyword.trim(),
      );
}

final hotelListQueryProvider =
    StateNotifierProvider<HotelListQueryNotifier, HotelListQueryState>((ref) {
  return HotelListQueryNotifier();
});

class HotelListQueryNotifier extends StateNotifier<HotelListQueryState> {
  HotelListQueryNotifier() : super(const HotelListQueryState());

  void setSort(HotelSort sort) {
    state = state.copyWith(sort: sort, page: 1);
  }

  void setPriceRange(double? min, double? max) {
    state = state.copyWith(priceMin: min, priceMax: max, page: 1);
  }

  void setStar(int? star) {
    state = state.copyWith(star: star, page: 1);
  }

  void setSearchKeyword(String keyword) {
    state = state.copyWith(searchKeyword: keyword, page: 1);
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
  }

  void resetPage() {
    state = state.copyWith(page: 1);
  }

  void resetFilters() {
    state = const HotelListQueryState();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// List: paginated result
// ─────────────────────────────────────────────────────────────────────────────

class HotelListState {
  const HotelListState({
    this.items = const [],
    this.hasMore = true,
    this.loading = false,
    this.loadingMore = false,
    this.error,
  });

  final List<HotelItem> items;
  final bool hasMore;
  final bool loading;
  final bool loadingMore;
  final HotelListError? error;

  HotelListState copyWith({
    List<HotelItem>? items,
    bool? hasMore,
    bool? loading,
    bool? loadingMore,
    HotelListError? error,
  }) {
    return HotelListState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error,
    );
  }
}

final hotelListStateProvider =
    StateNotifierProvider<HotelListNotifier, HotelListState>((ref) {
  return HotelListNotifier(ref);
});

class HotelListNotifier extends StateNotifier<HotelListState> {
  HotelListNotifier(this._ref) : super(const HotelListState());

  final Ref _ref;

  HotelRepository get _repo => _ref.read(hotelRepositoryProvider);

  Future<void> loadFirst() async {
    _ref.read(hotelListQueryProvider.notifier).resetPage();
    state = state.copyWith(loading: true, error: null);
    final queryState = _ref.read(hotelListQueryProvider);
    final query = queryState.toQuery().copyWith(page: 1);
    final result = await _repo.getHotels(query);
    state = HotelListState(
      items: result.hotels.map(hotelToItem).toList(),
      hasMore: result.hasMore,
      loading: false,
      error: result.error,
    );
  }

  Future<void> loadMore() async {
    if (state.loadingMore || state.loading || !state.hasMore) return;
    state = state.copyWith(loadingMore: true);
    _ref.read(hotelListQueryProvider.notifier).nextPage();
    final queryState = _ref.read(hotelListQueryProvider);
    final result = await _repo.getHotels(queryState.toQuery());
    final newItems = result.hotels.map(hotelToItem).toList();
    state = state.copyWith(
      items: [...state.items, ...newItems],
      hasMore: result.hasMore,
      loadingMore: false,
      error: result.error,
    );
  }

  Future<void> refresh() async {
    _ref.read(hotelListQueryProvider.notifier).resetPage();
    await loadFirst();
  }

  Future<void> applyQuery() async {
    _ref.read(hotelListQueryProvider.notifier).resetPage();
    state = state.copyWith(loading: true, error: null);
    final queryState = _ref.read(hotelListQueryProvider);
    final result = await _repo.getHotels(queryState.toQuery());
    state = HotelListState(
      items: result.hotels.map(hotelToItem).toList(),
      hasMore: result.hasMore,
      loading: false,
      error: result.error,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail: single hotel
// ─────────────────────────────────────────────────────────────────────────────

final hotelDetailProvider =
    FutureProvider.autoDispose.family<HotelDetail?, String>((ref, id) async {
  final repo = ref.watch(hotelRepositoryProvider);
  final hotel = await repo.getHotelById(id);
  return hotel != null ? hotelToDetail(hotel) : null;
});

final hotelByIdProvider =
    FutureProvider.autoDispose.family<Hotel?, String>((ref, id) async {
  final repo = ref.watch(hotelRepositoryProvider);
  return repo.getHotelById(id);
});

// ─────────────────────────────────────────────────────────────────────────────
// Detail: selected dates
// ─────────────────────────────────────────────────────────────────────────────

final hotelSelectedDatesProvider =
    StateProvider.autoDispose<DateTimeRange?>((ref) {
  final now = DateTime.now();
  return DateTimeRange(start: now, end: now.add(const Duration(days: 1)));
});

// ─────────────────────────────────────────────────────────────────────────────
// Detail: room availability
// ─────────────────────────────────────────────────────────────────────────────

final roomAvailabilityProvider = FutureProvider.autoDispose
    .family<bool, ({String hotelId, String roomId, DateTime checkIn, DateTime checkOut})>(
        (ref, params) async {
  final repo = ref.watch(hotelRepositoryProvider);
  return repo.getRoomAvailability(
    params.hotelId,
    params.roomId,
    params.checkIn,
    params.checkOut,
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Favorites
// ─────────────────────────────────────────────────────────────────────────────

final hotelFavoritesProvider =
    StateNotifierProvider<HotelFavoritesNotifier, Set<String>>((ref) {
  return HotelFavoritesNotifier();
});

class HotelFavoritesNotifier extends StateNotifier<Set<String>> {
  HotelFavoritesNotifier() : super({});

  void toggle(String hotelId) {
    state = Set.from(state)..toggle(hotelId);
  }

  bool isFavorite(String hotelId) => state.contains(hotelId);
}

extension _SetToggle on Set<String> {
  void toggle(String id) {
    if (contains(id)) {
      remove(id);
    } else {
      add(id);
    }
  }
}
