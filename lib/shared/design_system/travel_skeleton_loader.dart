import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'travel_design_tokens.dart';

/// Skeleton placeholder for travel content. Uses travel background, 8dp radius, soft shimmer.
class TravelSkeletonLoader extends StatelessWidget {
  const TravelSkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: borderRadius ?? TravelDesignTokens.borderRadiusSmall,
      ),
    );
  }
}

/// Wraps children in shimmer for loading state. Use with TravelSkeletonLoader.
class TravelSkeletonWrap extends StatelessWidget {
  const TravelSkeletonWrap({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE5E7EB),
      highlightColor: const Color(0xFFF3F4F6),
      period: const Duration(milliseconds: 1500),
      child: child,
    );
  }
}

/// Preset: travel package card skeleton (image + title + subtitle + price).
class TravelSkeletonCard extends StatelessWidget {
  const TravelSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return TravelSkeletonWrap(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: TravelSkeletonLoader(
              width: double.infinity,
              height: double.infinity,
              borderRadius: TravelDesignTokens.borderRadiusSmall,
            ),
          ),
          const SizedBox(height: 12),
          TravelSkeletonLoader(width: 160, height: 18),
          const SizedBox(height: 8),
          TravelSkeletonLoader(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          TravelSkeletonLoader(width: 80, height: 16),
        ],
      ),
    );
  }
}
