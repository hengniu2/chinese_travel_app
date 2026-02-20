import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 过渡时长（商业感：略慢、顺滑）
const Duration _kTransitionDuration = Duration(milliseconds: 320);
const Duration _kReverseDuration = Duration(milliseconds: 260);

/// 右滑进入 + 淡入（中国主流 App 风格）
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
      const curve = Curves.easeOutCubic;

      final slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
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
        curve: Curves.easeOutCubic,
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
      final slideTween = Tween<Offset>(
        begin: const Offset(0, 0.04),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      final fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeOut),
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
