import 'package:flutter/material.dart';

import 'app_tap_scale.dart';
import 'travel_design_tokens.dart';

/// Primary CTA — travel green fill, 12dp radius, level-2 shadow.
class TravelPrimaryButton extends StatelessWidget {
  const TravelPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.minHeight = 48,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool loading;
  final double minHeight;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = !loading && onPressed != null;

    final child = Container(
      height: minHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled ? TravelDesignTokens.primary : TravelDesignTokens.primary.withValues(alpha: 0.5),
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        boxShadow: enabled ? TravelDesignTokens.shadowLevel2 : null,
      ),
      child: loading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TravelDesignTokens.titleL(Colors.white).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );

    if (onPressed != null && !loading) {
      return AppTapScale(
        onTap: onPressed,
        child: child,
      );
    }
    return child;
  }
}
