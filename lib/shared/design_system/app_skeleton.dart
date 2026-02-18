import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'app_colors.dart';
import 'app_radius.dart';

/// Skeleton 加载组件（基于 shimmer）
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
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
        color: AppColors.surface,
        borderRadius: borderRadius ?? AppRadius.smRadius,
      ),
    );
  }
}

/// 提供 Shimmer 包装的 Skeleton 区域
class AppSkeletonWrap extends StatelessWidget {
  const AppSkeletonWrap({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.surface,
      highlightColor: highlightColor ?? AppColors.backgroundCard,
      child: child,
    );
  }
}

/// 预设：卡片骨架（图+标题+描述+价格）
class AppSkeletonCard extends StatelessWidget {
  const AppSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonWrap(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(
            width: double.infinity,
            height: 120,
            borderRadius: AppRadius.cardRadius,
          ),
          const SizedBox(height: 12),
          AppSkeleton(width: 160, height: 18),
          const SizedBox(height: 8),
          AppSkeleton(width: double.infinity, height: 14),
          const SizedBox(height: 6),
          AppSkeleton(width: 80, height: 14),
          const SizedBox(height: 12),
          AppSkeleton(width: 72, height: 20),
        ],
      ),
    );
  }
}

/// 预设：列表项骨架
class AppSkeletonListItem extends StatelessWidget {
  const AppSkeletonListItem({
    super.key,
    this.imageWidth = 96,
    this.imageHeight = 72,
  });

  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return AppSkeletonWrap(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(
            width: imageWidth,
            height: imageHeight,
            borderRadius: AppRadius.smRadius,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeleton(width: double.infinity, height: 16),
                const SizedBox(height: 8),
                AppSkeleton(width: 120, height: 12),
                const SizedBox(height: 8),
                AppSkeleton(width: 80, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
