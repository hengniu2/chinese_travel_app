import 'package:flutter/material.dart';

import '../colors.dart';
import '../radius.dart';
import '../typography.dart';

/// Green rounded pill for rating score (e.g. 4.8 分).
class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.score,
    this.suffix = '分',
    this.backgroundColor,
    this.textColor,
  });

  final double score;
  final String suffix;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? OtaColors.accentGreen;
    final fg = textColor ?? OtaColors.neutral0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: OtaRadius.pillRadius,
      ),
      child: Text(
        '${score.toStringAsFixed(1)} $suffix',
        style: OtaTypography.overline(fg).copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}
