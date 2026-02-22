import 'package:flutter/material.dart';

import 'travel_design_tokens.dart';

/// Reusable status badge — label + semantic color. 8dp radius.
class TravelStatusBadge extends StatelessWidget {
  const TravelStatusBadge({
    super.key,
    required this.label,
    this.color,
    this.variant = TravelStatusBadgeVariant.neutral,
  });

  final String label;
  final Color? color;
  final TravelStatusBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? _colorForVariant(variant);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.12),
        borderRadius: TravelDesignTokens.borderRadiusSmall,
      ),
      child: Text(
        label,
        style: TravelDesignTokens.caption(effectiveColor).copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Color _colorForVariant(TravelStatusBadgeVariant v) {
    switch (v) {
      case TravelStatusBadgeVariant.success:
        return TravelDesignTokens.primary;
      case TravelStatusBadgeVariant.warning:
        return const Color(0xFFF59E0B);
      case TravelStatusBadgeVariant.error:
        return const Color(0xFFEF4444);
      case TravelStatusBadgeVariant.neutral:
        return const Color(0xFF6B7280);
    }
  }
}

enum TravelStatusBadgeVariant { success, warning, error, neutral }
