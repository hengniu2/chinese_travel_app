/// Centralized analytics event definitions.
/// Add new events here to keep tracking scalable.
sealed class AnalyticsEvent {
  const AnalyticsEvent();
  String get name;
  Map<String, Object?> get parameters => const {};
}

/// Search click: user tapped search button.
class SearchClickEvent extends AnalyticsEvent {
  const SearchClickEvent({
    this.departure,
    this.arrival,
    this.tripType = 'single',
  });

  final String? departure;
  final String? arrival;
  final String tripType;

  @override
  String get name => 'search_click';

  @override
  Map<String, Object?> get parameters => {
        if (departure != null) 'departure': departure,
        if (arrival != null) 'arrival': arrival,
        'trip_type': tripType,
      };
}

/// Filter apply: user changed sort/filter.
class FilterApplyEvent extends AnalyticsEvent {
  const FilterApplyEvent({
    required this.filterType,
    this.screen,
  });

  final String filterType;
  final String? screen;

  @override
  String get name => 'filter_apply';

  @override
  Map<String, Object?> get parameters => {
        'filter_type': filterType,
        if (screen != null) 'screen': screen,
      };
}

/// Booking start: user initiated booking flow.
class BookingStartEvent extends AnalyticsEvent {
  const BookingStartEvent({
    this.itemId,
    this.itemType = 'flight',
  });

  final String? itemId;
  final String itemType;

  @override
  String get name => 'booking_start';

  @override
  Map<String, Object?> get parameters => {
        if (itemId != null) 'item_id': itemId,
        'item_type': itemType,
      };
}

/// Payment success: payment completed.
class PaymentSuccessEvent extends AnalyticsEvent {
  const PaymentSuccessEvent({
    this.orderId,
    this.amount,
    this.method,
  });

  final String? orderId;
  final num? amount;
  final String? method;

  @override
  String get name => 'payment_success';

  @override
  Map<String, Object?> get parameters => {
        if (orderId != null) 'order_id': orderId,
        if (amount != null) 'amount': amount,
        if (method != null) 'method': method,
      };
}

/// Payment fail: payment failed.
class PaymentFailEvent extends AnalyticsEvent {
  const PaymentFailEvent({
    this.orderId,
    this.reason,
  });

  final String? orderId;
  final String? reason;

  @override
  String get name => 'payment_fail';

  @override
  Map<String, Object?> get parameters => {
        if (orderId != null) 'order_id': orderId,
        if (reason != null) 'reason': reason,
      };
}
