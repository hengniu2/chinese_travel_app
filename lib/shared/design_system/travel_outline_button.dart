import 'package:flutter/material.dart';

import 'app_tap_scale.dart';
import 'travel_design_tokens.dart';

/// Outline/secondary button — border primary, transparent fill, 12dp radius.
class TravelOutlineButton extends StatelessWidget {
  const TravelOutlineButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.minHeight = 48,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double minHeight;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    final child = Container(
      height: minHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        border: Border.all(
          color: enabled ? TravelDesignTokens.primary : TravelDesignTokens.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TravelDesignTokens.titleL(enabled ? TravelDesignTokens.primary : TravelDesignTokens.primary.withValues(alpha: 0.5)).copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onPressed != null) {
      return AppTapScale(
        onTap: onPressed,
        child: child,
      );
    }
    return child;
  }
}
