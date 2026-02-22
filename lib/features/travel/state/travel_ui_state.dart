import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI-only state for the travel module (selected tab, sheet open, etc.).
/// Does not hold business data.
class TravelUiState {
  const TravelUiState({
    this.selectedDetailTab = 0,
    this.isFilterSheetOpen = false,
    this.isPlannerFormExpanded = false,
  });

  final int selectedDetailTab;
  final bool isFilterSheetOpen;
  final bool isPlannerFormExpanded;

  TravelUiState copyWith({
    int? selectedDetailTab,
    bool? isFilterSheetOpen,
    bool? isPlannerFormExpanded,
  }) {
    return TravelUiState(
      selectedDetailTab: selectedDetailTab ?? this.selectedDetailTab,
      isFilterSheetOpen: isFilterSheetOpen ?? this.isFilterSheetOpen,
      isPlannerFormExpanded: isPlannerFormExpanded ?? this.isPlannerFormExpanded,
    );
  }
}

final travelUiStateProvider =
    StateNotifierProvider<TravelUiStateNotifier, TravelUiState>(
  (ref) => TravelUiStateNotifier(),
);

class TravelUiStateNotifier extends StateNotifier<TravelUiState> {
  TravelUiStateNotifier() : super(const TravelUiState());

  void setDetailTab(int index) {
    state = state.copyWith(selectedDetailTab: index);
  }

  void setFilterSheetOpen(bool open) {
    state = state.copyWith(isFilterSheetOpen: open);
  }

  void setPlannerFormExpanded(bool expanded) {
    state = state.copyWith(isPlannerFormExpanded: expanded);
  }
}
