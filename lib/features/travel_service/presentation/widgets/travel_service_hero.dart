import 'package:flutter/material.dart';

import '../../theme/luxury_travel_theme.dart';

/// Luxury hero section for Travel Service main page: full-width background image,
/// subtle dark gradient at bottom, elegant title, gold divider, subtitle, parallax.
/// Height 300px. No emoji, no cartoon icons.
class TravelServiceHero extends StatelessWidget {
  const TravelServiceHero({
    super.key,
    this.height = 300,
    this.parallaxOffset = 0,
    this.backgroundImage = 'assets/header_travel_service.png',
  });

  final double height;
  /// Scroll offset passed from parent for parallax (e.g. from ScrollController).
  final double parallaxOffset;
  final String backgroundImage;

  static const double _goldDividerHeight = 1.5;
  static const double _goldDividerWidth = 48;

  @override
  Widget build(BuildContext context) {
    final h = height;
    const radius = 28.0;

    return SizedBox(
      height: h,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1) Full-width background image with parallax (moves slower than scroll)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              child: Transform.translate(
                offset: Offset(0, parallaxOffset * 0.25),
                child: Image.asset(
                  backgroundImage,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          // 2) Subtle dark gradient overlay at bottom for readability
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.45),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // 3) Content with slight parallax
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, parallaxOffset * 0.15),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '出行服务',
                      style: LuxuryTravelTheme.displayLarge(Colors.white),
                    ),
                    const SizedBox(height: LuxuryTravelTheme.spacingSm),
                    Container(
                      height: _goldDividerHeight,
                      width: _goldDividerWidth,
                      decoration: BoxDecoration(
                        color: LuxuryTravelTheme.primaryGold,
                        borderRadius: BorderRadius.circular(_goldDividerHeight / 2),
                      ),
                    ),
                    const SizedBox(height: LuxuryTravelTheme.spacingSm),
                    Text(
                      'Premium Travel Experience',
                      style: LuxuryTravelTheme.caption(Colors.white.withValues(alpha: 0.9))
                          .copyWith(fontSize: 14, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
