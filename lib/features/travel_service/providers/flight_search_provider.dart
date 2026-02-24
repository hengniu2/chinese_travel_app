import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/flight_repository.dart';
import '../data/flight_repository_mock.dart';
import '../models/models.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Repository
// ─────────────────────────────────────────────────────────────────────────────

final flightRepositoryProvider = Provider<FlightRepository>((ref) {
  return FlightRepositoryMock();
  // For API: return FlightRepositoryApi(ref.read(dioClientProvider));
});

// ─────────────────────────────────────────────────────────────────────────────
// Search params state (form inputs)
// ─────────────────────────────────────────────────────────────────────────────

class FlightSearchFormState {
  const FlightSearchFormState({
    this.departure = '北京',
    this.arrival = '上海',
    this.departureDate,
    this.outboundDate,
    this.returnDate,
    this.segments = const [],
    this.adults = 1,
    this.children = 0,
    this.cabinIndex = 0,
  });

  final String departure;
  final String arrival;
  final DateTime? departureDate;
  final DateTime? outboundDate;
  final DateTime? returnDate;
  final List<TripSegment> segments;
  final int adults;
  final int children;
  final int cabinIndex;

  CabinClass get cabinClass => CabinClass.values[cabinIndex.clamp(0, 2)];

  FlightSearchFormState copyWith({
    String? departure,
    String? arrival,
    DateTime? departureDate,
    DateTime? outboundDate,
    DateTime? returnDate,
    List<TripSegment>? segments,
    int? adults,
    int? children,
    int? cabinIndex,
  }) =>
      FlightSearchFormState(
        departure: departure ?? this.departure,
        arrival: arrival ?? this.arrival,
        departureDate: departureDate ?? this.departureDate,
        outboundDate: outboundDate ?? this.outboundDate,
        returnDate: returnDate ?? this.returnDate,
        segments: segments ?? this.segments,
        adults: adults ?? this.adults,
        children: children ?? this.children,
        cabinIndex: cabinIndex ?? this.cabinIndex,
      );
}

final flightSearchFormProvider =
    StateNotifierProvider<FlightSearchFormNotifier, FlightSearchFormState>(
  (ref) => FlightSearchFormNotifier(),
);

class FlightSearchFormNotifier extends StateNotifier<FlightSearchFormState> {
  FlightSearchFormNotifier() : super(const FlightSearchFormState());

  void setDeparture(String v) => state = state.copyWith(departure: v);
  void setArrival(String v) => state = state.copyWith(arrival: v);
  void swapCities() =>
      state = state.copyWith(departure: state.arrival, arrival: state.departure);

  void setDepartureDate(DateTime? v) =>
      state = state.copyWith(departureDate: v);
  void setOutboundDate(DateTime? v) =>
      state = state.copyWith(outboundDate: v);
  void setReturnDate(DateTime? v) => state = state.copyWith(returnDate: v);

  void setAdults(int v) => state = state.copyWith(adults: v);
  void setChildren(int v) => state = state.copyWith(children: v);
  void setCabinIndex(int v) => state = state.copyWith(cabinIndex: v);

  void setSegments(List<TripSegment> segments) =>
      state = state.copyWith(segments: segments);
  void addSegment(TripSegment s) =>
      state = state.copyWith(segments: [...state.segments, s]);
  void removeSegment(int i) =>
      state = state.copyWith(
        segments: [...state.segments]..removeAt(i),
      );
  void updateSegment(int i, TripSegment s) {
    final list = [...state.segments];
    list[i] = s;
    state = state.copyWith(segments: list);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search results (async, from repository)
// ─────────────────────────────────────────────────────────────────────────────

final flightSearchResultsProvider =
    FutureProvider.autoDispose<List<FlightItem>>((ref) async {
  final form = ref.watch(flightSearchFormProvider);
  final repo = ref.watch(flightRepositoryProvider);

  final params = _buildParams(form);
  if (params == null) return [];

  final result = await repo.searchFlights(params);
  if (result.error != null) return [];
  return result.flights;
});

FlightSearchParams? _buildParams(FlightSearchFormState form) {
  if (form.segments.isNotEmpty) {
    return MultiTripSearchParams(
      segments: form.segments,
      adults: form.adults,
      children: form.children,
      cabinClass: form.cabinClass,
    );
  }
  if (form.outboundDate != null && form.returnDate != null) {
    return RoundTripSearchParams(
      departure: form.departure,
      arrival: form.arrival,
      outboundDate: form.outboundDate!,
      returnDate: form.returnDate!,
      adults: form.adults,
      children: form.children,
      cabinClass: form.cabinClass,
    );
  }
  final dep = form.departureDate ?? DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  return SingleTripSearchParams(
    departure: form.departure,
    arrival: form.arrival,
    departureDate: dep,
    adults: form.adults,
    children: form.children,
    cabinClass: form.cabinClass,
  );
}
