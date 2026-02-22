import 'package:flutter/material.dart';

import '../gradients.dart';
import '../radius.dart';
import '../spacing.dart';

/// Yellow cartoon-style header with gradient background and rounded bottom.
/// Flexible height, immersive top (optional SafeArea), configurable content.
class AppHeaderYellow extends StatelessWidget {
  const AppHeaderYellow({
    super.key,
    required this.child,
    this.height,
    this.roundedBottomRadius,
    this.gradient,
    this.safeAreaTop = true,
  });

  /// Main content (title row, search, etc.).
  final Widget child;

  /// If set, header has fixed height; otherwise wraps [child] with padding.
  final double? height;

  /// Bottom corner radius. Defaults to [OtaRadius.extraLarge].
  final double? roundedBottomRadius;

  /// Gradient for background. Defaults to [OtaGradients.heroWarmGradient].
  final Gradient? gradient;

  /// Whether to respect top safe area (status bar).
  final bool safeAreaTop;

  @override
  Widget build(BuildContext context) {
    final radius = roundedBottomRadius ?? OtaRadius.extraLarge;
    final bgGradient = gradient ?? OtaGradients.heroWarmGradient;

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: bgGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
      ),
      child: SafeArea(
        top: safeAreaTop,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            OtaSpacing.screenHorizontal,
            OtaSpacing.xxs,
            OtaSpacing.screenHorizontal,
            OtaSpacing.xs,
          ),
          child: child,
        ),
      ),
    );
  }
}
