# Analytics Module

Centralized analytics service for scalable event tracking.

## Structure

```
lib/core/analytics/
├── analytics_events.dart      # Event definitions (add new events here)
├── analytics_service.dart     # Abstract interface
├── analytics_service_impl.dart # Default impl (console in debug)
├── analytics_provider.dart   # Riverpod provider + context extension
├── analytics.dart             # Barrel export
└── README.md
```

## Tracked Events

| Event | When | Parameters |
|-------|------|------------|
| `search_click` | User taps search | departure, arrival, trip_type |
| `filter_apply` | User changes sort/filter | filter_type, screen |
| `booking_start` | User initiates booking | item_id, item_type |
| `payment_success` | Payment completed | order_id, amount, method |
| `payment_fail` | Payment failed | order_id, reason |

## Adding New Events

1. Define event in `analytics_events.dart`:

```dart
class MyNewEvent extends AnalyticsEvent {
  const MyNewEvent({this.myParam});
  final String? myParam;

  @override
  String get name => 'my_new_event';

  @override
  Map<String, Object?> get parameters => {
    if (myParam != null) 'my_param': myParam,
  };
}
```

2. Log from UI or provider:

```dart
// With ref
ref.read(analyticsServiceProvider).logEvent(MyNewEvent(myParam: 'value'));

// With context (no ref)
context.analytics.logEvent(MyNewEvent(myParam: 'value'));
```

## Swapping Implementation

Replace `AnalyticsServiceImpl` with Firebase, Mixpanel, etc.:

```dart
// analytics_provider.dart
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return FirebaseAnalyticsService(); // or MixpanelAnalyticsService()
});
```

Implement `AnalyticsService` and forward `logEvent` to your SDK.
