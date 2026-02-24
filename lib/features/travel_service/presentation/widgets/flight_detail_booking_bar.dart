import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/luxury_travel_theme.dart';

/// Bottom booking bar for flight detail: cream background, thin gold top border,
/// total price left, black "Reserve Now" button (gold text) right.
/// Slide-up on load and light haptic on tap.
class FlightDetailBookingBar extends StatefulWidget {
  const FlightDetailBookingBar({
    super.key,
    required this.totalPrice,
    required this.onReserveTap,
    this.buttonLabel = 'Reserve Now',
  });

  final int totalPrice;
  final VoidCallback onReserveTap;
  final String buttonLabel;

  @override
  State<FlightDetailBookingBar> createState() => _FlightDetailBookingBarState();
}

class _FlightDetailBookingBarState extends State<FlightDetailBookingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  static const Color _cream = Color(0xFFFFFEFB);
  static const Color _buttonBlack = Color(0xFF1E1E1E);
  static const double _topBorderHeight = 1.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 380),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onReserveTap() {
    HapticFeedback.lightImpact();
    widget.onReserveTap();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: _cream,
            border: Border(
              top: BorderSide(
                color: LuxuryTravelTheme.primaryGold,
                width: _topBorderHeight,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.04),
                offset: const Offset(0, -2),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            16 + MediaQuery.paddingOf(context).bottom,
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Total price on left
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '总价',
                      style: LuxuryTravelTheme.caption(
                        LuxuryTravelTheme.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '¥${widget.totalPrice}',
                      style: LuxuryTravelTheme.headlineMedium(
                        LuxuryTravelTheme.darkText,
                      ).copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                // Black "Reserve Now" button on right
                Expanded(
                  child: Material(
                    color: _buttonBlack,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      onTap: _onReserveTap,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        child: Text(
                          widget.buttonLabel,
                          style: LuxuryTravelTheme.buttonLabel(
                            LuxuryTravelTheme.primaryGold,
                          ).copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
