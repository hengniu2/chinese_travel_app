import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../widgets/booking_tab_section.dart';
import '../widgets/multi_trip_form.dart';
import '../widgets/round_trip_form.dart';
import '../widgets/single_trip_form.dart';

/// 出行服务 - Full-screen background with stacked content.
/// Background extends behind status bar; no AppBar; custom back when needed.
class TravelServicePage extends StatefulWidget {
  const TravelServicePage({super.key});

  @override
  State<TravelServicePage> createState() => _TravelServicePageState();
}

class _TravelServicePageState extends State<TravelServicePage> {
  static const String _bgAsset = 'assets/travel_service_body.png';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Full-screen background image (extends behind status bar)
          Positioned.fill(
            child: Image.asset(
              _bgAsset,
              fit: BoxFit.cover,
            ),
          ),
          // 2) Dark overlay for readability
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
              ),
            ),
          ),
          // 3) Main content in SafeArea (form height limited so train in bg is visible)
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopBar(context),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                      child: BookingTabSection(
                        overlapHeight: 16,
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
                  ),
                ),
              ],
            ),
          ),
          // 4) Floating buttons bottom right: Order, Home
          Positioned(
            right: 20,
            bottom: 24 + MediaQuery.paddingOf(context).bottom,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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

  /// Top bar: back button only when route can pop (title is in background image).
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
              backgroundColor: Colors.black.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular bright-yellow FAB with soft shadow and scale animation on tap.
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
  static const Color _yellow = Color(0xFFFFD54F);
  static const Color _yellowDark = Color(0xFFFFC107);

  @override
  Widget build(BuildContext context) {
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
            color: _yellow,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _yellowDark.withValues(alpha: 0.4),
                offset: const Offset(0, 4),
                blurRadius: 12,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            size: 26,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  bool _pressed = false;
}
