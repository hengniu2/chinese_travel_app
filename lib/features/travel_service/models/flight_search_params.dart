/// Flight search parameters (single, round-trip, multi-city).
sealed class FlightSearchParams {
  const FlightSearchParams({
    required this.departure,
    required this.arrival,
    required this.adults,
    required this.children,
    required this.cabinClass,
  });

  final String departure;
  final String arrival;
  final int adults;
  final int children;
  final CabinClass cabinClass;
}

enum CabinClass {
  economy(0, '经济'),
  business(1, '商务'),
  first(2, '头等');

  const CabinClass(this.index, this.label);
  final int index;
  final String label;
}

/// Single-trip (单程) search.
class SingleTripSearchParams extends FlightSearchParams {
  const SingleTripSearchParams({
    required super.departure,
    required super.arrival,
    required this.departureDate,
    super.adults = 1,
    super.children = 0,
    super.cabinClass = CabinClass.economy,
  });

  final DateTime departureDate;
}

/// Round-trip (往返) search.
class RoundTripSearchParams extends FlightSearchParams {
  const RoundTripSearchParams({
    required super.departure,
    required super.arrival,
    required this.outboundDate,
    required this.returnDate,
    super.adults = 1,
    super.children = 0,
    super.cabinClass = CabinClass.economy,
  });

  final DateTime outboundDate;
  final DateTime returnDate;
}

/// Multi-city (多程) search.
class MultiTripSearchParams extends FlightSearchParams {
  const MultiTripSearchParams({
    required this.segments,
    super.adults = 1,
    super.children = 0,
    super.cabinClass = CabinClass.economy,
  })  : departure = segments.first.departure,
        arrival = segments.last.arrival;

  final List<TripSegment> segments;
}

class TripSegment {
  const TripSegment({
    required this.departure,
    required this.arrival,
    required this.date,
  });

  final String departure;
  final String arrival;
  final DateTime date;

  TripSegment copyWith({
    String? departure,
    String? arrival,
    DateTime? date,
  }) =>
      TripSegment(
        departure: departure ?? this.departure,
        arrival: arrival ?? this.arrival,
        date: date ?? this.date,
      );
}
