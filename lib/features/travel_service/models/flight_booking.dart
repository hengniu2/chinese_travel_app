import 'flight_item.dart';

/// Flight booking state (selected flight + passenger info).
class FlightBooking {
  const FlightBooking({
    required this.flight,
    this.passengerCount = 1,
    this.contactPhone,
    this.contactEmail,
  });

  final FlightItem flight;
  final int passengerCount;
  final String? contactPhone;
  final String? contactEmail;

  FlightBooking copyWith({
    FlightItem? flight,
    int? passengerCount,
    String? contactPhone,
    String? contactEmail,
  }) =>
      FlightBooking(
        flight: flight ?? this.flight,
        passengerCount: passengerCount ?? this.passengerCount,
        contactPhone: contactPhone ?? this.contactPhone,
        contactEmail: contactEmail ?? this.contactEmail,
      );
}
