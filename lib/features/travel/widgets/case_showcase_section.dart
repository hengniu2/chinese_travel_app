import 'package:flutter/material.dart';

import '../../../shared/design_system/design_system.dart';
import '../../../shared/widgets/app_network_image.dart';

/// Data for one case card in the showcase.
/// [id] optional: when set, card tap navigates to /planner/detail/[id].
class CaseCardItem {
  const CaseCardItem({
    required this.destinationName,
    required this.subtitle,
    required this.durationBadge,
    required this.price,
    this.starRating = 0.0,
    this.isFavorite = false,
    this.imageUrl,
    this.gradient,
    this.id,
  });

  final String destinationName;
  final String subtitle;
  final String durationBadge;
  final double price;
  final double starRating;
  final bool isFavorite;
  final String? imageUrl;
  final List<Color>? gradient;
  /// Optional package id for navigation to detail (e.g. '1', '2').
  final String? id;

  CaseCardItem copyWith({
    String? destinationName,
    String? subtitle,
    String? durationBadge,
    double? price,
    double? starRating,
    bool? isFavorite,
    String? imageUrl,
    List<Color>? gradient,
    String? id,
  }) {
    return CaseCardItem(
      destinationName: destinationName ?? this.destinationName,
      subtitle: subtitle ?? this.subtitle,
      durationBadge: durationBadge ?? this.durationBadge,
      price: price ?? this.price,
      starRating: starRating ?? this.starRating,
      isFavorite: isFavorite ?? this.isFavorite,
      imageUrl: imageUrl ?? this.imageUrl,
      gradient: gradient ?? this.gradient,
      id: id ?? this.id,
    );
  }
}

/// Reusable case card: duration badge, large image, destination, subtitle,
/// starting price, star rating, heart favorite. 16px corners, soft shadow, tap scale.
class CaseCard extends StatefulWidget {
  const CaseCard({
    super.key,
    required this.item,
    this.width = 200,
    this.imageHeight = 140,
    this.onTap,
    this.onFavoriteToggle,
  });

  final CaseCardItem item;
  final double width;
  final double imageHeight;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFavoriteToggle;

  @override
  State<CaseCard> createState() => _CaseCardState();
}

class _CaseCardState extends State<CaseCard> {
  static const double _radius = 16;
  static const List<Color> _defaultGradient = [
    Color(0xFF6DD5ED),
    Color(0xFF2193B0),
  ];

  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final gradient = item.gradient ?? _defaultGradient;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: widget.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(_radius),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    height: widget.imageHeight,
                    width: double.infinity,
                    child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? AppNetworkImage(
                            imageUrl: item.imageUrl!,
                            width: double.infinity,
                            height: widget.imageHeight,
                            fit: BoxFit.cover,
                            fadeInDuration: const Duration(milliseconds: 300),
                            errorWidget: _gradientPlaceholder(gradient),
                            placeholder: _gradientPlaceholder(gradient),
                          )
                        : _gradientPlaceholder(gradient),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.durationBadge,
                        style: TravelTypography.label(Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => widget.onFavoriteToggle?.call(!item.isFavorite),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            item.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 22,
                            color: item.isFavorite ? const Color(0xFFE53935) : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.destinationName,
                      style: TravelTypography.sectionTitle(const Color(0xFF1A1A1A), fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TravelTypography.hint(Colors.grey[600]!, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        PriceTag(
                          price: item.price,
                          unit: '起',
                          size: PriceTagSize.small,
                        ),
                        const Spacer(),
                        if (item.starRating > 0) ...[
                          Icon(Icons.star_rounded, size: 14, color: Colors.amber[700]),
                          const SizedBox(width: 2),
                          Text(
                            item.starRating.toStringAsFixed(1),
                            style: TravelTypography.label(Colors.grey[800]!, fontSize: 12),
                          ),
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

  Widget _gradientPlaceholder(List<Color> gradient) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.landscape_rounded,
          size: 44,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

/// Section with title (decorative yellow underline), horizontal scroll cards,
/// and auto scroll indicator dots.
class CaseShowcaseSection extends StatefulWidget {
  const CaseShowcaseSection({
    super.key,
    required this.title,
    required this.items,
    this.cardWidth = 200,
    this.cardImageHeight = 140,
    this.onCardTap,
    this.onFavoriteToggle,
  });

  final String title;
  final List<CaseCardItem> items;
  final double cardWidth;
  final double cardImageHeight;
  final void Function(int index)? onCardTap;
  final void Function(int index, bool isFavorite)? onFavoriteToggle;

  @override
  State<CaseShowcaseSection> createState() => _CaseShowcaseSectionState();
}

class _CaseShowcaseSectionState extends State<CaseShowcaseSection> {
  static const double _underlineHeight = 3;
  static const Color _underlineColor = Color(0xFFFFEE58);

  late ScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || widget.items.isEmpty) return;
    final offset = _scrollController.offset;
    final cardSpan = widget.cardWidth + 12;
    final index = (offset / cardSpan).round().clamp(0, widget.items.length - 1);
    if (index != _currentIndex && mounted) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSectionTitle(),
          const SizedBox(height: 14),
          SizedBox(
            height: widget.cardImageHeight + 140,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return CaseCard(
                  item: item,
                  width: widget.cardWidth,
                  imageHeight: widget.cardImageHeight,
                  onTap: () => widget.onCardTap?.call(index),
                  onFavoriteToggle: widget.onFavoriteToggle != null
                      ? (fav) => widget.onFavoriteToggle!(index, fav)
                      : null,
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          _buildIndicatorDots(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: TravelTypography.sectionTitle(const Color(0xFF1A1A1A), fontSize: 18),
        ),
        const SizedBox(height: 6),
        Container(
          width: 40,
          height: _underlineHeight,
          decoration: BoxDecoration(
            color: _underlineColor,
            borderRadius: BorderRadius.circular(_underlineHeight / 2),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorDots() {
    final count = widget.items.length;
    if (count <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? _underlineColor
                : Colors.grey.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
