import 'dart:developer' as developer;

import 'analytics_events.dart';
import 'analytics_service.dart';

/// Default implementation: logs to console in debug, no-op in release.
/// Replace with FirebaseAnalytics, Mixpanel, etc.
class AnalyticsServiceImpl implements AnalyticsService {
  AnalyticsServiceImpl({this.debug = true});

  final bool debug;
  String? _userId;
  String? _screen;

  @override
  void logEvent(AnalyticsEvent event) {
    if (debug) {
      developer.log(
        'Analytics: ${event.name}',
        name: 'Analytics',
        error: event.parameters.isNotEmpty ? event.parameters : null,
      );
    }
    // TODO: Send to Firebase/Mixpanel/etc.
    // await _firebase.logEvent(name: event.name, parameters: event.parameters);
  }

  @override
  void setUserId(String? userId) {
    _userId = userId;
  }

  @override
  void setUserProperty(String name, String? value) {
    // TODO: _firebase.setUserProperty(name: name, value: value);
  }

  @override
  void setScreen(String screenName) {
    _screen = screenName;
  }
}
