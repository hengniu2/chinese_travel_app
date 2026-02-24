import 'package:flutter/material.dart';

import '../../../../shared/design_system/design_system.dart';
import 'companion_theme.dart';

/// Style variant for the gradient CTA.
enum GradientCTAButtonStyle {
  /// Bright yellow–amber–orange gradient (conversion).
  conversion,
  /// Primary brand gradient (e.g. from AppGradients).
  primary,
}

/// Gradient CTA with optional glow. Theme-driven colors.
class GradientCTAButton extends StatelessWidget {
  const GradientCTAButton({
    super.key,
    required this.label,
    required this.onTap,
    this.style = GradientCTAButtonStyle.conversion,
    this.theme = CompanionThemeData.defaultTheme,
    this.fontSize = 13,
    this.compact = false,
    this.borderRadius,
  });

  final String label;
  final VoidCallback onTap;
  final GradientCTAButtonStyle style;
  final CompanionThemeData theme;
  final double fontSize;
  final bool compact;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final (List<Color> colors, Color shadowColor) = _resolveGradient();
    final radius = borderRadius ?? BorderRadius.circular(10);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 12 : 16,
            vertical: compact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.45),
                offset: const Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.3),
                offset: const Offset(0, 1),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFF1A1A1A),
                fontWeight: FontWeight.w800,
                fontSize: fontSize,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  (List<Color>, Color) _resolveGradient() {
    switch (style) {
      case GradientCTAButtonStyle.conversion:
        return (
          theme.ctaGradientColorsResolved,
          theme.ctaShadowColorResolved,
        );
      case GradientCTAButtonStyle.primary:
        return (
          [AppColors.primary, AppColors.primaryDark],
          AppColors.primary,
        );
    }
  }
}
