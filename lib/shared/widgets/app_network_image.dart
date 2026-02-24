import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../design_system/design_system.dart';

/// 网络图片懒加载：缓存 + 占位 + 错误图 + 可选渐入
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  /// 与 fit 一起使用，决定裁剪时保留图片的哪一部分（如 Alignment(1, 0.5) 保留右侧）
  final Alignment alignment;
  final Widget? placeholder;
  final Widget? errorWidget;
  /// 加载完成后渐入时长，null 则无渐入
  final Duration? fadeInDuration;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return errorWidget ?? _defaultError();
    }
    final cacheWidth = width != null && width!.isFinite ? (width! * 2).toInt() : null;
    final cacheHeight = height != null && height!.isFinite ? (height! * 2).toInt() : null;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      memCacheWidth: cacheWidth,
      memCacheHeight: cacheHeight,
      placeholder: (_, __) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (_, __, ___) => errorWidget ?? _defaultError(),
      fadeInDuration: fadeInDuration ?? Duration.zero,
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _defaultError() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface,
      child: Icon(Icons.broken_image_outlined, size: 40, color: AppColors.textTertiary),
    );
  }
}
