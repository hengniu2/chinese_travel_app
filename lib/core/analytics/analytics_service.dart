import 'analytics_events.dart';

/// Centralized analytics service. Swap implementation for Firebase, Mixpanel, etc.
abstract class AnalyticsService {
  /// Log a typed event.
  void logEvent(AnalyticsEvent event);

  /// Optional: set user ID for attribution.
  void setUserId(String? userId);

  /// Optional: set user property.
  void setUserProperty(String name, String? value);

  /// Optional: set screen name for automatic screen tracking.
  void setScreen(String screenName);
}
