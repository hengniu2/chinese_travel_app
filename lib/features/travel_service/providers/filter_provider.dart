import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/analytics/analytics.dart';
import '../models/flight_filter.dart';

final flightFilterProvider =
    StateNotifierProvider<FlightFilterNotifier, FlightFilterType>(
  (ref) => FlightFilterNotifier(ref),
);

class FlightFilterNotifier extends StateNotifier<FlightFilterType> {
  FlightFilterNotifier(this._ref) : super(FlightFilterType.price);

  final Ref _ref;

  void setFilter(FlightFilterType type) {
    _ref.read(analyticsServiceProvider).logEvent(FilterApplyEvent(
      filterType: type.label,
      screen: 'flight_result',
    ));
    state = type;
  }
}
