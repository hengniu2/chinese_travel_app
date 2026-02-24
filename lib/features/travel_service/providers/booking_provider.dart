import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/analytics/analytics.dart';
import '../models/models.dart';
import 'flight_search_provider.dart';

final flightBookingProvider =
    StateNotifierProvider<FlightBookingNotifier, FlightBooking?>(
  (ref) => FlightBookingNotifier(ref),
);

class FlightBookingNotifier extends StateNotifier<FlightBooking?> {
  FlightBookingNotifier(this._ref) : super(null);

  final Ref _ref;

  void selectFlight(FlightItem flight) {
    _ref.read(analyticsServiceProvider).logEvent(BookingStartEvent(
      itemId: flight.id,
      itemType: 'flight',
    ));
    final form = _ref.read(flightSearchFormProvider);
    state = FlightBooking(
      flight: flight,
      passengerCount: form.adults + form.children,
    );
  }

  void setPassengerCount(int count) {
    if (state == null) return;
    state = state!.copyWith(passengerCount: count);
  }

  void setContact(String? phone, String? email) {
    if (state == null) return;
    state = state!.copyWith(contactPhone: phone, contactEmail: email);
  }

  void clear() => state = null;
}
