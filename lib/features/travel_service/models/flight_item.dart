/// Flight search result item.
class FlightItem {
  const FlightItem({
    required this.id,
    required this.airlineName,
    required this.airlineCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.departureCity,
    required this.arrivalCity,
  });

  final String id;
  final String airlineName;
  final String airlineCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int price;
  final String departureCity;
  final String arrivalCity;
}
