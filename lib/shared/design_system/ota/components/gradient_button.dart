import 'package:flutter/material.dart';

import '../gradients.dart';
import '../radius.dart';
import '../shadows.dart';
import '../spacing.dart';
import '../typography.dart';
import 'tap_scale.dart';

/// Reusable gradient CTA button with scale animation on tap.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.gradient,
    this.minHeight = 48,
    this.borderRadius,
    this.textColor,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final double minHeight;
  final BorderRadius? borderRadius;
  final Color? textColor;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final g = gradient ?? OtaGradients.primaryButtonGradient;
    final radius = borderRadius ?? OtaRadius.mediumRadius;
    final fg = textColor ?? OtaColors.neutral900;

    final child = Container(
      height: minHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: OtaSpacing.xs),
      decoration: BoxDecoration(
        gradient: onPressed != null ? g : null,
        color: onPressed == null ? OtaColors.neutral500 : null,
        borderRadius: radius,
        boxShadow: onPressed != null ? OtaShadows.level1 : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[icon!, const SizedBox(width: 8)],
          Text(label, style: OtaTypography.button(fg)),
        ],
      ),
    );

    if (onPressed == null) return child;
    return OtaTapScale(
      onTap: onPressed,
      child: child,
    );
  }
}
