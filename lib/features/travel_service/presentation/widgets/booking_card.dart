import 'dart:ui';

import 'package:flutter/material.dart';

/// Booking form container: semi-transparent white, optional backdrop blur,
/// border radius 20, thin soft border, elegant spacing.
/// Use as the card wrapping TabBar + form content.
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.child,
    this.constraints,
    this.useBlur = true,
  });

  final Widget child;
  final BoxConstraints? constraints;
  /// When true (default), applies BackdropFilter blur when supported.
  final bool useBlur;

  static const double radius = 20;
  static const Color borderColor = Color(0xFFEAE6DC);
  static const double borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      constraints: constraints,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.06),
            offset: const Offset(0, 4),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );

    if (!useBlur) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: content,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: content,
      ),
    );
  }
}
