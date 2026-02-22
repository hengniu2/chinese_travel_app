import 'package:flutter/material.dart';

import 'travel_design_tokens.dart';
import 'app_tap_scale.dart';

/// Reusable card for travel content. White, level-1 shadow, 8dp radius, 16dp padding.
class TravelCard extends StatelessWidget {
  const TravelCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevated = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(TravelDesignTokens.cardPadding),
      child: child,
    );

    final container = Container(
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusSmall,
        boxShadow: elevated ? TravelDesignTokens.shadowLevel1 : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: content,
    );

    if (onTap != null) {
      return AppTapScale(
        onTap: onTap,
        child: container,
      );
    }
    return container;
  }
}
