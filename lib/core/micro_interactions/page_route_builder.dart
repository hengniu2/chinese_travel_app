import 'package:flutter/material.dart';

import 'luxury_constants.dart';

/// Luxury page transition: 250ms, easeInOutCubic.
const Duration kPageTransitionDuration = LuxuryInteractions.duration;
const Duration kPageReverseDuration = LuxuryInteractions.durationReverse;

/// Slide + fade (250ms, easeInOutCubic). Use with Navigator.push(context, slidePageRoute(builder: ...)).
PageRouteBuilder<T> slidePageRoute<T>({
  required WidgetBuilder builder,
  RouteSettings? settings,
  bool fullscreenDialog = false,
  bool maintainState = true,
}) {
  return PageRouteBuilder<T>(
    settings: settings,
    fullscreenDialog: fullscreenDialog,
    maintainState: maintainState,
    transitionDuration: kPageTransitionDuration,
    reverseTransitionDuration: kPageReverseDuration,
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = LuxuryInteractions.luxuryCurve;

      final slideTween = Tween(begin: begin, end: end).chain(
        CurveTween(curve: curve),
      );
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 0.65, curve: curve)),
      );

      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}
