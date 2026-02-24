import 'package:flutter/material.dart';

import 'travel_design_tokens.dart';

/// Filter chip for discovery/travel — selected uses primary green.
class TravelFilterChip extends StatelessWidget {
  const TravelFilterChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? TravelDesignTokens.primary.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: TravelDesignTokens.borderRadiusPill,
      child: InkWell(
        onTap: onTap,
        borderRadius: TravelDesignTokens.borderRadiusPill,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: TravelDesignTokens.borderRadiusPill,
            border: Border.all(
              color: selected
                  ? TravelDesignTokens.primary
                  : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TravelDesignTokens.caption(null).copyWith(
              color: selected
                  ? TravelDesignTokens.primary
                  : const Color(0xFF6B7280),
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
