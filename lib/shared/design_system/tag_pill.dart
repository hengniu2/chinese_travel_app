import 'package:flutter/material.dart';

import 'app_radius.dart';
import 'travel_design_tokens.dart';

/// Small pill tag (e.g. "热卖", "品质团"). Pill radius 20–24, compact padding.
class TagPill extends StatelessWidget {
  const TagPill({
    super.key,
    required this.label,
    this.color,
    this.textColor,
  });

  final String label;
  /// Background; default primary with alpha
  final Color? color;
  /// Text color; default white on colored bg
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? TravelDesignTokens.primary.withValues(alpha: 0.9);
    final fg = textColor ?? Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.pillRadius,
      ),
      child: Text(
        label,
        style: TravelDesignTokens.caption(fg).copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
