import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/hotel_item.dart';

/// Max number of hotels user can add to compare.
const int hotelCompareMaxCount = 3;

/// Compare list state: up to [hotelCompareMaxCount] hotels. Add / remove support.
final hotelCompareListProvider =
    StateNotifierProvider<HotelCompareListNotifier, List<HotelItem>>((ref) {
  return HotelCompareListNotifier();
});

class HotelCompareListNotifier extends StateNotifier<List<HotelItem>> {
  HotelCompareListNotifier() : super([]);

  /// Add hotel to compare. No-op if already in list or list has 3 items.
  void add(HotelItem hotel) {
    if (state.length >= hotelCompareMaxCount) return;
    if (state.any((h) => h.id == hotel.id)) return;
    state = [...state, hotel];
  }

  /// Remove by id.
  void remove(String hotelId) {
    state = state.where((h) => h.id != hotelId).toList();
  }

  void clear() {
    state = [];
  }

  bool contains(String hotelId) => state.any((h) => h.id == hotelId);

  bool get canAdd => state.length < hotelCompareMaxCount;
}
