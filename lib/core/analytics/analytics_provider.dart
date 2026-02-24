import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_service.dart';
import 'analytics_service_impl.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsServiceImpl(debug: kDebugMode);
});

/// Access analytics from BuildContext (for widgets without ref).
extension AnalyticsContext on BuildContext {
  AnalyticsService get analytics =>
      ProviderScope.containerOf(this).read(analyticsServiceProvider);
}
