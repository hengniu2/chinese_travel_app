import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../theme/luxury_travel_theme.dart';
import '../widgets/booking_tab_section.dart';
import '../widgets/concierge_floating_button.dart';
import '../widgets/multi_trip_form.dart';
import '../widgets/round_trip_form.dart';
import '../widgets/single_trip_form.dart';

/// 出行服务 - Full-screen background (travel_service_body.png) with booking section only.
class TravelServicePage extends StatefulWidget {
  const TravelServicePage({super.key});

  @override
  State<TravelServicePage> createState() => _TravelServicePageState();
}

class _TravelServicePageState extends State<TravelServicePage> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _roundTripScrollController = ScrollController();
  final ScrollController _multiTripScrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _roundTripScrollController.dispose();
    _multiTripScrollController.dispose();
    super.dispose();
  }

  static const String _backgroundAsset = 'assets/travel_service_body.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image only
          Positioned.fill(
            child: Image.asset(
              _backgroundAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => ColoredBox(
                color: LuxuryTravelTheme.background,
              ),
            ),
          ),
          // Booking section in lower half, ~60% of screen height
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [
                  Expanded(flex: 2, child: const SizedBox.shrink()),
                  Expanded(
                    flex: 8,
                    child: BookingTabSection(
                      overlapHeight: 0,
                      tabOne: SingleTripForm(
                        scrollController: _scrollController,
                      ),
                      tabTwo: RoundTripForm(
                        scrollController: _roundTripScrollController,
                      ),
                      tabThree: MultiTripForm(
                        scrollController: _multiTripScrollController,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Top bar: back when route can pop
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context),
          ),
          // Floating buttons: Concierge, Order, Home
          Positioned(
            right: 20,
            bottom: 24 + MediaQuery.paddingOf(context).bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const ConciergeFloatingButton(),
                const SizedBox(height: 16),
                _FloatingNavButton(
                  icon: Icons.receipt_long_rounded,
                  onTap: () => context.go('/${RouteNames.orders}'),
                ),
                const SizedBox(height: 12),
                _FloatingNavButton(
                  icon: Icons.home_rounded,
                  onTap: () => context.go('/${RouteNames.home}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    if (!Navigator.canPop(context)) {
      return const SizedBox(height: 8);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular luxury gold FAB with soft shadow and scale animation on tap.
class _FloatingNavButton extends StatefulWidget {
  const _FloatingNavButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_FloatingNavButton> createState() => _FloatingNavButtonState();
}

class _FloatingNavButtonState extends State<_FloatingNavButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1.0,
        duration: Duration(milliseconds: _pressed ? 80 : 150),
        curve: _pressed ? Curves.easeIn : Curves.elasticOut,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.35),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
              ...LuxuryTravelTheme.softShadow,
            ],
          ),
          child: Icon(
            widget.icon,
            size: 26,
            color: LuxuryTravelTheme.darkText,
          ),
        ),
      ),
    );
  }

  bool _pressed = false;
}
