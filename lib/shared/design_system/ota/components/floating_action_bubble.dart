import 'package:flutter/material.dart';

import '../colors.dart';
import '../gradients.dart';
import '../shadows.dart';
import 'tap_scale.dart';

/// Yellow circular FAB with shadow and press scale animation.
class FloatingActionBubble extends StatelessWidget {
  const FloatingActionBubble({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 48,
    this.gradient,
    this.backgroundColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Gradient? gradient;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final useGradient = gradient != null || (backgroundColor == null && onTap != null);
    final bg = backgroundColor ?? (useGradient ? null : OtaColors.primary);

    final child = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: useGradient ? (gradient ?? OtaGradients.primaryButtonGradient) : null,
        color: useGradient ? null : bg,
        shape: BoxShape.circle,
        boxShadow: OtaShadows.level3,
      ),
      child: Icon(icon, color: OtaColors.neutral900, size: size * 0.5),
    );

    if (onTap == null) return child;
    return OtaTapScale(onTap: onTap, child: child);
  }
}
