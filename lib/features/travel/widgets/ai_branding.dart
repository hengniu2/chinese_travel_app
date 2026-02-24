import 'package:flutter/material.dart';

import '../../../shared/design_system/design_system.dart';

/// Subtle AI brand presence: sparkle icon + "Powered by 智行AI".
/// Use near smart features across Travel Planner.
class AiBranding extends StatelessWidget {
  const AiBranding({
    super.key,
    this.compact = false,
    this.iconSize = 12,
    this.fontSize = 10,
  });

  /// If true, only show sparkle + short text (single line).
  final bool compact;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.auto_awesome_rounded,
          size: iconSize,
          color: AppColors.textTertiary,
        ),
        SizedBox(width: compact ? 4 : 6),
        Text(
          'Powered by 智行AI',
          style: TravelTypography.hint(AppColors.textTertiary, fontSize: fontSize),
        ),
      ],
    );
  }
}

/// Inline sparkle icon only — use next to "智能推荐" / AI feature labels.
class AiSparkleIcon extends StatelessWidget {
  const AiSparkleIcon({super.key, this.size = 14});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.auto_awesome_rounded,
      size: size,
      color: TravelDesignTokens.primary.withValues(alpha: 0.9),
    );
  }
}
