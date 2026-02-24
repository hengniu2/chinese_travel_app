import 'package:flutter/material.dart';

import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_shadow.dart';

/// Rounded white card below hero overlay: TabBar (单程 / 往返 / 多程) with
/// yellow underline indicator, smooth switching, DefaultTabController.
/// Slightly overlaps background image; elevated shadow.
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

  /// How much the card overlaps the background image (positive = move up).
  final double overlapHeight;

  static const double _cardTopRadius = 28;
  static const Color _yellowIndicator = Color(0xFFFFD54F);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -overlapHeight),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 320,
          maxHeight: MediaQuery.sizeOf(context).height * 0.58,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(_cardTopRadius),
            topRight: Radius.circular(_cardTopRadius),
          ),
          boxShadow: [
            ...AppShadow.medium,
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, -6),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                labelColor: AppColors.textPrimary,
                unselectedLabelColor: _kUnselectedGrey,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: _yellowIndicator,
                    width: 3,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                tabs: const [
                  Tab(text: '单程'),
                  Tab(text: '往返'),
                  Tab(text: '多程'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    tabOne,
                    tabTwo ?? _buildPlaceholder(),
                    tabThree ?? _buildPlaceholder(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const Color _kUnselectedGrey = Color(0xFF8E8E8E);

  Widget _buildPlaceholder() {
    return Center(
      child: Text(
        '敬请期待',
        style: TextStyle(fontSize: 15, color: AppColors.textTertiary),
      ),
    );
  }
}
