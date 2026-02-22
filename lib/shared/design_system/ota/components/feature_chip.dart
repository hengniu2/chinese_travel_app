import 'package:flutter/material.dart';

import '../colors.dart';
import '../radius.dart';
import '../typography.dart';

/// Light yellow rounded chip for features (e.g. 免费WiFi, 早餐).
class FeatureChip extends StatelessWidget {
  const FeatureChip({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? OtaColors.tertiaryYellow;
    final fg = textColor ?? OtaColors.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: OtaRadius.smallRadius,
      ),
      child: Text(
        label,
        style: OtaTypography.overline(fg),
      ),
    );
  }
}
