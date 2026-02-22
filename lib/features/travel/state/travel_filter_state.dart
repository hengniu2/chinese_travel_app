import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Duration range option ID for multi-select (e.g. "1-3", "4-7", "8-14", "15+").
const List<String> kDurationRangeIds = ['1-3', '4-7', '8-14', '15+'];

/// Group size option IDs for filter.
const List<String> kGroupSizeIds = ['solo', '2-4', '5-9', '10+'];

/// Accommodation level option IDs.
const List<String> kAccommodationLevelIds = ['economy', 'comfort', 'premium', 'luxury'];

/// Transportation type option IDs.
const List<String> kTransportationTypeIds = ['flight', 'train', 'bus', 'self_drive'];

/// Filter state for discovery list (price, duration, themes, etc.).
/// Separate from UI state and package data. Preserved when navigating to detail and back.
class TravelFilterState {
  const TravelFilterState({
    this.departureCity,
    this.destinations = const [],
    this.priceMin,
    this.priceMax,
    this.durationDaysMin,
    this.durationDaysMax,
    this.selectedDurationRanges = const [],
    this.themes = const [],
    this.groupSize,
    this.selectedGroupSizes = const [],
    this.accommodationLevel,
    this.selectedAccommodationLevels = const [],
    this.transportationTypes = const [],
  });

  final String? departureCity;
  final List<String> destinations;
  final double? priceMin;
  final double? priceMax;
  final int? durationDaysMin;
  final int? durationDaysMax;
  /// Multi-select duration: e.g. ["1-3", "4-7"].
  final List<String> selectedDurationRanges;
  final List<String> themes;
  final String? groupSize;
  /// Multi-select group size: e.g. ["2-4", "5-9"].
  final List<String> selectedGroupSizes;
  final String? accommodationLevel;
  /// Multi-select accommodation: e.g. ["comfort", "premium"].
  final List<String> selectedAccommodationLevels;
  /// Transportation types: e.g. ["flight", "train"].
  final List<String> transportationTypes;

  /// Number of filter dimensions that have a non-default value (for badge).
  int get activeFilterCount {
    int n = 0;
    if (departureCity != null && departureCity!.trim().isNotEmpty) n++;
    if (priceMin != null || priceMax != null) n++;
    if (durationDaysMin != null || durationDaysMax != null || selectedDurationRanges.isNotEmpty) n++;
    if (themes.isNotEmpty) n++;
    if (groupSize != null || selectedGroupSizes.isNotEmpty) n++;
    if (accommodationLevel != null || selectedAccommodationLevels.isNotEmpty) n++;
    if (transportationTypes.isNotEmpty) n++;
    return n;
  }

  TravelFilterState copyWith({
    String? departureCity,
    List<String>? destinations,
    double? priceMin,
    double? priceMax,
    int? durationDaysMin,
    int? durationDaysMax,
    List<String>? selectedDurationRanges,
    List<String>? themes,
    String? groupSize,
    List<String>? selectedGroupSizes,
    String? accommodationLevel,
    List<String>? selectedAccommodationLevels,
    List<String>? transportationTypes,
  }) {
    return TravelFilterState(
      departureCity: departureCity ?? this.departureCity,
      destinations: destinations ?? this.destinations,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      durationDaysMin: durationDaysMin ?? this.durationDaysMin,
      durationDaysMax: durationDaysMax ?? this.durationDaysMax,
      selectedDurationRanges: selectedDurationRanges ?? this.selectedDurationRanges,
      themes: themes ?? this.themes,
      groupSize: groupSize ?? this.groupSize,
      selectedGroupSizes: selectedGroupSizes ?? this.selectedGroupSizes,
      accommodationLevel: accommodationLevel ?? this.accommodationLevel,
      selectedAccommodationLevels: selectedAccommodationLevels ?? this.selectedAccommodationLevels,
      transportationTypes: transportationTypes ?? this.transportationTypes,
    );
  }
}

final travelFilterStateProvider =
    StateNotifierProvider<TravelFilterStateNotifier, TravelFilterState>(
  (ref) => TravelFilterStateNotifier(),
);

class TravelFilterStateNotifier extends StateNotifier<TravelFilterState> {
  TravelFilterStateNotifier() : super(const TravelFilterState());

  void apply(TravelFilterState next) {
    state = next;
  }

  void clear() {
    state = const TravelFilterState();
  }
}
