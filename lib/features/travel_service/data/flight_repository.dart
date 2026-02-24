import '../models/models.dart';

/// Result of flight search API.
class FlightSearchResult {
  const FlightSearchResult({
    required this.flights,
    this.error,
  });

  final List<FlightItem> flights;
  final FlightSearchError? error;
}

enum FlightSearchError {
  noInternet,
  apiError,
}

/// Abstract flight repository for API integration.
abstract class FlightRepository {
  /// Search flights by params (single/round/multi).
  Future<FlightSearchResult> searchFlights(FlightSearchParams params);

  /// Create order and return order ID.
  Future<String?> createOrder(FlightBooking booking);

  /// Process payment.
  Future<bool> processPayment(String orderId, PaymentMethod method);

  /// Fetch order by ID.
  Future<FlightOrder?> getOrder(String orderId);
}
