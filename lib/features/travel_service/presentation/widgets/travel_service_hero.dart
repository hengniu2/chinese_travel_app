import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Hero for Travel Service: high-res Chinese cartoon background
/// (airplane, train, clouds), title "出行服务" + handwritten "Travel",
/// dynamic subtitle, parallax-ready.
class TravelServiceHero extends StatelessWidget {
  const TravelServiceHero({
    super.key,
    this.height = 300,
    this.parallaxOffset = 0,
  });

  final double height;
  final double parallaxOffset;

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
          // 1) High-res background illustration (yellow–green, airplane, train, clouds)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(radius),
                bottomRight: Radius.circular(radius),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/header_travel_service.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 2) Light gradient overlay for title readability
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
                      Colors.white.withValues(alpha: 0.25),
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // 3) Content with subtle parallax
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, parallaxOffset * 0.2),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Chinese title
                    const Text(
                      '出行服务',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Handwritten accent English
                    Text(
                      'Travel',
                      style: GoogleFonts.caveat(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Dynamic subtitle
                    Text(
                      '机票 · 定制 · 团队 · 高端出行',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withValues(alpha: 0.6),
                        letterSpacing: 0.3,
                      ),
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
