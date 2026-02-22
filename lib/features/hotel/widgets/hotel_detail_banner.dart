import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/design_system/design_system.dart';
import '../data/hotel_model.dart';
import '../theme/hotel_theme.dart';

/// Detail page image carousel with overlay buttons and indicators.
class HotelDetailBanner extends StatefulWidget {
  const HotelDetailBanner({
    super.key,
    required this.detail,
    this.height = 280,
    this.cornerRadius = 24,
    this.autoScrollDuration = const Duration(seconds: 4),
    this.isFavorite = false,
    this.onShareTap,
    this.onFavoriteTap,
  });

  final HotelDetail detail;
  final double height;
  final double cornerRadius;
  final Duration autoScrollDuration;
  final bool isFavorite;
  final VoidCallback? onShareTap;
  final VoidCallback? onFavoriteTap;

  @override
  State<HotelDetailBanner> createState() => _HotelDetailBannerState();
}

class _HotelDetailBannerState extends State<HotelDetailBanner> {
  late PageController _pageController;
  late ScrollController _thumbController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  List<String> get _images {
    if (widget.detail.imageUrls.isNotEmpty) return widget.detail.imageUrls;
    if (widget.detail.imageUrl != null &&
        widget.detail.imageUrl!.isNotEmpty) {
      return [widget.detail.imageUrl!];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _thumbController = ScrollController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (_images.length <= 1) return;
    _autoScrollTimer = Timer.periodic(widget.autoScrollDuration, (_) {
      if (!_pageController.hasClients) return;
      final next = (_currentIndex + 1) % _images.length;
      _pageController.animateToPage(next,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    _thumbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = _images.isNotEmpty;
    return SizedBox(
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(widget.cornerRadius),
              bottomRight: Radius.circular(widget.cornerRadius),
            ),
            child: hasImages
                ? PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) {
                      setState(() => _currentIndex = i);
                      _scrollThumbTo(i);
                    },
                    itemCount: _images.length,
                    itemBuilder: (_, i) => _BannerImage(url: _images[i]),
                  )
                : _PlaceholderBanner(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 100,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.4),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _OverlayButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _OverlayButton(
                          icon: Icons.share_rounded,
                          onTap: widget.onShareTap ?? () {}),
                      SizedBox(width: 8.w),
                      _OverlayButton(
                        icon: widget.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        onTap: widget.onFavoriteTap ?? () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (hasImages && _images.length > 1)
            Positioned(
              bottom: 16.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _images.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: _currentIndex == i ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: _currentIndex == i
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
          if (hasImages && _images.length > 1)
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 40.h,
              height: 44,
              child: _ThumbStrip(
                images: _images,
                currentIndex: _currentIndex,
                scrollController: _thumbController,
                onTap: (i) {
                  _pageController.animateToPage(i,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _scrollThumbTo(int index) {
    if (!_thumbController.hasClients) return;
    final itemWidth = 56.0 + 8;
    final offset = (index * itemWidth) -
        (MediaQuery.of(context).size.width / 2) +
        (itemWidth / 2);
    _thumbController.animateTo(
      offset.clamp(0.0, _thumbController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }
}

class _OverlayButton extends StatelessWidget {
  const _OverlayButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(HotelTheme.overlayButtonRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius:
              BorderRadius.circular(HotelTheme.overlayButtonRadius),
          child: InkWell(
            onTap: onTap,
            borderRadius:
                BorderRadius.circular(HotelTheme.overlayButtonRadius),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 22, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, __) => Container(
        color: AppColors.surface,
        child: const Center(
          child: SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Container(
        color: AppColors.primaryLight2,
        child: Center(
          child: Icon(Icons.hotel_rounded, size: 64,
              color: AppColors.primary.withValues(alpha: 0.5)),
        ),
      ),
    );
  }
}

class _PlaceholderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLight2,
      child: Center(
        child: Icon(Icons.hotel_rounded, size: 80,
            color: AppColors.primary.withValues(alpha: 0.5)),
      ),
    );
  }
}

class _ThumbStrip extends StatelessWidget {
  const _ThumbStrip({
    required this.images,
    required this.currentIndex,
    required this.scrollController,
    required this.onTap,
  });

  final List<String> images;
  final int currentIndex;
  final ScrollController scrollController;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: images.length,
      itemBuilder: (_, i) {
        final selected = i == currentIndex;
        return GestureDetector(
          onTap: () => onTap(i),
          child: Container(
            width: 56,
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.5),
                width: selected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: CachedNetworkImage(
                imageUrl: images[i],
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.surface,
                  child: Icon(Icons.image_not_supported_rounded,
                      size: 24, color: AppColors.textTertiary),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
