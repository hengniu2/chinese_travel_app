import 'package:flutter/material.dart';

import '../colors.dart';
import '../typography.dart';

/// Red bold large price text. Optional unit (e.g. 起, /晚).
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.value,
    this.unit,
    this.size = PriceTextSize.large,
    this.color,
  });

  final num value;
  final String? unit;
  final PriceTextSize size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? OtaColors.accentRed;
    final style = size == PriceTextSize.large
        ? OtaTypography.priceLarge(c)
        : OtaTypography.priceMedium(c);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('¥', style: style.copyWith(fontSize: (style.fontSize ?? 20) * 0.75)),
        Text(value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1), style: style),
        if (unit != null && unit!.isNotEmpty)
          Text(' $unit', style: OtaTypography.caption(OtaColors.textTertiary)),
      ],
    );
  }
}

enum PriceTextSize { large, medium }
