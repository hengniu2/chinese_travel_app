import 'package:flutter/material.dart';

import '../colors.dart';
import '../gradients.dart';
import '../radius.dart';
import '../shadows.dart';
import '../spacing.dart';
import '../typography.dart';
import 'feature_chip.dart';
import 'gradient_button.dart';
import 'price_text.dart';
import 'rating_badge.dart';
import 'tap_scale.dart';

/// Yellow cartoon-style hotel card: rounded 20, left image, rating, feature chips, price, discount, gradient CTA.
/// All content optional via parameters for maximum reuse.
class HotelCardYellow extends StatelessWidget {
  const HotelCardYellow({
    super.key,
    required this.title,
    this.imageUrl,
    this.imageWidget,
    this.rating,
    this.address,
    this.features = const [],
    this.price,
    this.discountLabel,
    this.ctaLabel = '查看详情',
    this.onTap,
    this.tagLabel,
  });

  final String title;
  final String? imageUrl;
  final Widget? imageWidget;
  final double? rating;
  final String? address;
  final List<String> features;
  final double? price;
  final String? discountLabel;
  final String ctaLabel;
  final VoidCallback? onTap;
  final String? tagLabel;

  @override
  Widget build(BuildContext context) {
    return OtaTapScale(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: OtaColors.surface,
          borderRadius: OtaRadius.largeRadius,
          boxShadow: OtaShadows.level1,
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(OtaSpacing.xxs),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              SizedBox(width: OtaSpacing.xxs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTitleRow(),
                    if (address != null && address!.isNotEmpty) ...[
                      SizedBox(height: OtaSpacing.xxs / 2),
                      Text(
                        address!,
                        style: OtaTypography.caption(OtaColors.textTertiary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (features.isNotEmpty) ...[
                      SizedBox(height: OtaSpacing.xxs / 2),
                      Wrap(
                        spacing: OtaSpacing.xxs / 2,
                        runSpacing: OtaSpacing.xxs / 2,
                        children: features.take(3).map((f) => FeatureChip(label: f)).toList(),
                      ),
                    ],
                    SizedBox(height: OtaSpacing.xxs),
                    _buildBottomRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    const width = 112.0;
    const height = 106.0;
    if (imageWidget != null) {
      return ClipRRect(
        borderRadius: OtaRadius.smallRadius,
        child: SizedBox(width: width, height: height, child: imageWidget),
      );
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: OtaRadius.smallRadius,
        child: Image.network(
          imageUrl!,
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholderImage(),
        ),
      );
    }
    return _placeholderImage();
  }

  Widget _placeholderImage() {
    return Container(
      width: 112,
      height: 106,
      decoration: BoxDecoration(
        color: OtaColors.tertiaryYellow.withValues(alpha: 0.5),
        borderRadius: OtaRadius.smallRadius,
      ),
      child: Icon(Icons.hotel_rounded, size: 40, color: OtaColors.primary.withValues(alpha: 0.6)),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: OtaTypography.h3(OtaColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (tagLabel != null && tagLabel!.isNotEmpty) ...[
          SizedBox(width: OtaSpacing.xxs / 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: OtaColors.tertiaryYellow,
              borderRadius: OtaRadius.smallRadius,
            ),
            child: Text(tagLabel!, style: OtaTypography.overline(OtaColors.textSecondary)),
          ),
        ],
        if (rating != null) ...[
          SizedBox(width: OtaSpacing.xxs / 2),
          RatingBadge(score: rating!),
        ],
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (price != null) PriceText(value: price!, unit: '起', size: PriceTextSize.large),
              if (discountLabel != null && discountLabel!.isNotEmpty) ...[
                SizedBox(height: OtaSpacing.xxs / 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: OtaColors.accentRed.withValues(alpha: 0.1),
                    borderRadius: OtaRadius.smallRadius,
                  ),
                  child: Text(
                    discountLabel!,
                    style: OtaTypography.overline(OtaColors.accentRed),
                  ),
                ),
              ],
            ],
          ),
        ),
        GradientButton(
          label: ctaLabel,
          onPressed: onTap,
          minHeight: 36,
        ),
      ],
    );
  }
}
