import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../micro_interactions/luxury_constants.dart';

/// Luxury page transition: slow fade + slide, 250ms, easeInOutCubic (60fps, no bounce).
const Duration _kTransitionDuration = LuxuryInteractions.duration;
const Duration _kReverseDuration = LuxuryInteractions.durationReverse;

/// 详情页过渡（更顺滑、略长）
const Duration _kDetailTransitionDuration = Duration(milliseconds: 300);
const Duration _kDetailReverseDuration = Duration(milliseconds: 240);

/// Slide from right + fade (250ms, easeInOutCubic).
CustomTransitionPage<T> slideTransitionPage<T>({
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: _kTransitionDuration,
    reverseTransitionDuration: _kReverseDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = LuxuryInteractions.luxuryCurve;

      final slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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

/// 详情页右滑 + 淡入（更顺滑，用于陪游/活动等详情）
CustomTransitionPage<T> slideTransitionPageSmooth<T>({
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: _kDetailTransitionDuration,
    reverseTransitionDuration: _kDetailReverseDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = LuxuryInteractions.luxuryCurve;

      final slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 0.5, curve: curve)),
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

/// 陪游详情：淡入 + 轻微右滑（premium、信任感）
CustomTransitionPage<T> companionDetailTransitionPage<T>({
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: _kDetailTransitionDuration,
    reverseTransitionDuration: _kDetailReverseDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = LuxuryInteractions.luxuryCurve;
      final slideTween = Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 0.7, curve: Curves.easeOut)),
      );

      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}

/// 淡入淡出（弹窗/错误页，带缓动）
CustomTransitionPage<T> fadeTransitionPage<T>({
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: _kTransitionDuration,
    reverseTransitionDuration: _kReverseDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: LuxuryInteractions.luxuryCurve,
      );
      return FadeTransition(
        opacity: curve,
        child: child,
      );
    },
  );
}

/// 从底部轻微上滑 + 淡入（适合底部弹层风格，可选）
CustomTransitionPage<T> slideUpFadeTransitionPage<T>({
  required Widget child,
  LocalKey? key,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionDuration: _kTransitionDuration,
    reverseTransitionDuration: _kReverseDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = LuxuryInteractions.luxuryCurve;
      final slideTween = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: curve),
      );
      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: SlideTransition(
          position: animation.drive(slideTween),
          child: child,
        ),
      );
    },
  );
}
