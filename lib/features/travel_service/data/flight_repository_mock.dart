import '../models/models.dart';
import 'flight_repository.dart';

/// Mock implementation for development. Replace with API client.
class FlightRepositoryMock implements FlightRepository {
  @override
  Future<FlightSearchResult> searchFlights(FlightSearchParams params) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return FlightSearchResult(
      flights: _mockFlights(params.departure, params.arrival),
    );
  }

  @override
  Future<String?> createOrder(FlightBooking booking) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return 'ORD-${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<bool> processPayment(String orderId, PaymentMethod method) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return true;
  }

  @override
  Future<FlightOrder?> getOrder(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return null;
  }

  static List<FlightItem> _mockFlights(String departure, String arrival) => [
        FlightItem(
          id: '1',
          airlineName: '中国国航',
          airlineCode: 'CA',
          departureTime: '08:30',
          arrivalTime: '10:45',
          duration: '2h 15m',
          price: 680,
          departureCity: departure,
          arrivalCity: arrival,
        ),
        FlightItem(
          id: '2',
          airlineName: '东方航空',
          airlineCode: 'MU',
          departureTime: '12:00',
          arrivalTime: '14:20',
          duration: '2h 20m',
          price: 620,
          departureCity: departure,
          arrivalCity: arrival,
        ),
        FlightItem(
          id: '3',
          airlineName: '南方航空',
          airlineCode: 'CZ',
          departureTime: '15:45',
          arrivalTime: '18:00',
          duration: '2h 15m',
          price: 590,
          departureCity: departure,
          arrivalCity: arrival,
        ),
        FlightItem(
          id: '4',
          airlineName: '海南航空',
          airlineCode: 'HU',
          departureTime: '09:20',
          arrivalTime: '11:35',
          duration: '2h 15m',
          price: 720,
          departureCity: departure,
          arrivalCity: arrival,
        ),
        FlightItem(
          id: '5',
          airlineName: '厦门航空',
          airlineCode: 'MF',
          departureTime: '14:10',
          arrivalTime: '16:25',
          duration: '2h 15m',
          price: 650,
          departureCity: departure,
          arrivalCity: arrival,
        ),
      ];
}
