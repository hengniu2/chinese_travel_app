import 'flight_item.dart';
import 'payment_info.dart';

/// Completed flight order.
class FlightOrder {
  const FlightOrder({
    required this.id,
    required this.flight,
    required this.amount,
    required this.status,
    this.createdAt,
  });

  final String id;
  final FlightItem flight;
  final int amount;
  final OrderStatus status;
  final DateTime? createdAt;
}

enum OrderStatus {
  pending,
  paid,
  cancelled,
}
