import 'package:flutter/material.dart';

import '../../../shared/design_system/design_system.dart';
import '../models/travel_package.dart';

/// Vertical discovery card: image (12dp radius), duration badge, title (2 lines),
/// highlight tags, price, rating, favorite icon.
class DiscoveryPackageCard extends StatelessWidget {
  const DiscoveryPackageCard({
    super.key,
    required this.package,
    this.isFavorite = false,
    this.onTap,
    this.onFavoriteTap,
  });

  final TravelPackage package;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TravelDesignTokens.radiusMedium),
        child: Container(
          decoration: BoxDecoration(
            color: TravelDesignTokens.card,
            borderRadius: BorderRadius.circular(TravelDesignTokens.radiusMedium),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: TravelDesignTokens.shadowLevel1,
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  _buildImage(),
                  if (package.durationDays != null)
                    Positioned(
                      left: 10,
                      top: 10,
                      child: TagPill(label: '${package.durationDays}D'),
                    ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Material(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: onFavoriteTap,
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 22,
                            color: isFavorite ? Colors.red : AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.title,
                      style: TravelDesignTokens.titleL(null).copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (package.tags.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: package.tags.take(3).map((t) => TagPill(
                          label: t,
                          color: TravelDesignTokens.primary.withValues(alpha: 0.2),
                          textColor: TravelDesignTokens.primary,
                        )).toList(),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        PriceTag(
                          price: package.price,
                          unit: '起',
                          size: PriceTagSize.small,
                          originalPrice: package.originalPrice,
                        ),
                        const Spacer(),
                        if (package.rating != null) ...[
                          Icon(Icons.star_rounded, size: 14, color: AppColors.accentGold),
                          const SizedBox(width: 2),
                          Text(
                            package.rating!.toStringAsFixed(1),
                            style: TravelDesignTokens.caption(AppColors.textSecondary).copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (package.reviewsCount != null) ...[
                            const SizedBox(width: 2),
                            Text(
                              '(${package.reviewsCount})',
                              style: TravelDesignTokens.caption(AppColors.textTertiary).copyWith(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ],
                    ),
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(TravelDesignTokens.radiusMedium),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                TravelDesignTokens.primary.withValues(alpha: 0.2),
                TravelDesignTokens.accentLimeEnd.withValues(alpha: 0.25),
              ],
            ),
          ),
          child: package.heroImages.isNotEmpty
              ? Image.network(
                  package.heroImages.first,
                  fit: BoxFit.cover,
                  errorBuilder: (_, Object e, StackTrace? st) => _placeholderIcon(),
                )
              : _placeholderIcon(),
        ),
      ),
    );
  }

  Widget _placeholderIcon() {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: TravelDesignTokens.primary.withValues(alpha: 0.4),
      ),
    );
  }
}
