import 'package:flutter/material.dart';

import '../../theme/luxury_travel_theme.dart';
import 'booking_card.dart';

/// Booking form container (BookingCard) with TabBar (单程 / 往返 / 多程):
/// minimal gold underline indicator, fade on tab switch. Elegant spacing.
class BookingTabSection extends StatelessWidget {
  const BookingTabSection({
    super.key,
    required this.tabOne,
    this.tabTwo,
    this.tabThree,
    this.overlapHeight = 16,
  });

  /// First tab content (e.g. one-way booking form).
  final Widget tabOne;

  /// Second tab content. Defaults to placeholder.
  final Widget? tabTwo;

  /// Third tab content. Defaults to placeholder.
  final Widget? tabThree;

  /// How much the card overlaps the content above (positive = move up).
  final double overlapHeight;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -overlapHeight),
      child: BookingCard(
        constraints: BoxConstraints(
          minHeight: 260,
          maxHeight: MediaQuery.sizeOf(context).height * 0.80,
        ),
        child: DefaultTabController(
          length: 3,
          child: Builder(
            builder: (context) {
              final controller = DefaultTabController.of(context);
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  TabBar(
                    controller: controller,
                    labelColor: LuxuryTravelTheme.darkText,
                    unselectedLabelColor: LuxuryTravelTheme.textTertiary,
                    labelStyle: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.darkText)
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: LuxuryTravelTheme.bodyMedium(LuxuryTravelTheme.textTertiary)
                        .copyWith(fontSize: 16),
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        color: LuxuryTravelTheme.primaryGold,
                        width: 2,
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    dividerColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    tabs: const [
                      Tab(text: '单程'),
                      Tab(text: '往返'),
                      Tab(text: '多程'),
                    ],
                  ),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (_, __) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        child: _TabContent(
                          key: ValueKey<int>(controller.index),
                          index: controller.index,
                          tabOne: tabOne,
                          tabTwo: tabTwo,
                          tabThree: tabThree,
                          buildPlaceholder: _buildPlaceholder,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget _buildPlaceholder() {
    return Center(
      child: Text(
        '敬请期待',
        style: LuxuryTravelTheme.bodyMedium(LuxuryTravelTheme.textTertiary),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    super.key,
    required this.index,
    required this.tabOne,
    this.tabTwo,
    this.tabThree,
    required this.buildPlaceholder,
  });

  final int index;
  final Widget tabOne;
  final Widget? tabTwo;
  final Widget? tabThree;
  final Widget Function() buildPlaceholder;

  @override
  Widget build(BuildContext context) {
    switch (index) {
      case 0:
        return tabOne;
      case 1:
        return tabTwo ?? buildPlaceholder();
      case 2:
        return tabThree ?? buildPlaceholder();
      default:
        return tabOne;
    }
  }
}
