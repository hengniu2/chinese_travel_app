import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'travel_design_tokens.dart';

/// Price display — main price with optional unit/original.
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.unit,
    this.originalPrice,
    this.size = PriceTagSize.medium,
  });

  final double price;
  final String? unit;
  final double? originalPrice;
  final PriceTagSize size;

  @override
  Widget build(BuildContext context) {
    final (mainSize, unitSize) = size == PriceTagSize.large
        ? (20.0, 14.0)
        : size == PriceTagSize.medium
            ? (18.0, 12.0)
            : (16.0, 11.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '¥${price.toStringAsFixed(0)}',
          style: TravelDesignTokens.titleL(AppColors.price).copyWith(
            fontSize: mainSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (unit != null) ...[
          const SizedBox(width: 2),
          Text(
            unit!,
            style: TravelDesignTokens.caption(AppColors.textTertiary).copyWith(
              fontSize: unitSize,
            ),
          ),
        ],
        if (originalPrice != null && originalPrice! > price) ...[
          const SizedBox(width: 8),
          Text(
            '¥${originalPrice!.toStringAsFixed(0)}',
            style: TravelDesignTokens.caption(AppColors.textTertiary).copyWith(
              decoration: TextDecoration.lineThrough,
              fontSize: unitSize,
            ),
          ),
        ],
      ],
    );
  }
}

enum PriceTagSize { small, medium, large }
