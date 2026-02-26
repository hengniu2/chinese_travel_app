import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/luxury_travel_theme.dart';
import '../widgets/luxury_empty_state.dart';

/// Flight search result page: AppBar, filter row, scrollable flight cards.
class FlightResultPage extends StatefulWidget {
  const FlightResultPage({super.key});

  @override
  State<FlightResultPage> createState() => _FlightResultPageState();
}

class _FlightResultPageState extends State<FlightResultPage> {
  int _filterIndex = 0; // 0 价格, 1 起飞时间, 2 航空公司

  static const List<String> _filterLabels = ['价格', '起飞时间', '航空公司'];

  final List<_FlightItem> _flights = [
    _FlightItem(
      airlineName: '中国国航',
      airlineCode: 'CA',
      departureTime: '08:30',
      arrivalTime: '10:45',
      duration: '2h 15m',
      price: 680,
      departureCity: '北京',
      arrivalCity: '上海',
    ),
    _FlightItem(
      airlineName: '东方航空',
      airlineCode: 'MU',
      departureTime: '12:00',
      arrivalTime: '14:20',
      duration: '2h 20m',
      price: 620,
      departureCity: '北京',
      arrivalCity: '上海',
    ),
    _FlightItem(
      airlineName: '南方航空',
      airlineCode: 'CZ',
      departureTime: '15:45',
      arrivalTime: '18:00',
      duration: '2h 15m',
      price: 590,
      departureCity: '北京',
      arrivalCity: '上海',
    ),
    _FlightItem(
      airlineName: '海南航空',
      airlineCode: 'HU',
      departureTime: '09:20',
      arrivalTime: '11:35',
      duration: '2h 15m',
      price: 720,
      departureCity: '北京',
      arrivalCity: '上海',
    ),
    _FlightItem(
      airlineName: '厦门航空',
      airlineCode: 'MF',
      departureTime: '14:10',
      arrivalTime: '16:25',
      duration: '2h 15m',
      price: 650,
      departureCity: '北京',
      arrivalCity: '上海',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxuryTravelTheme.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildSearchSummary(context)),
          SliverToBoxAdapter(child: _buildFilterRow()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Text(
                    '共 ${_flights.length} 个航班',
                    style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textSecondary)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          _flights.isEmpty
              ? SliverFillRemaining(
                  child: LuxuryEmptyState.flightNoResults(
                    ctaLabel: '调整筛选',
                    onCtaTap: () {
                      // TODO: Open filters or clear filters
                    },
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _FlightCard(
                          flight: _flights[index],
                          onBook: () => _onBookFlight(context, _flights[index]),
                        ),
                      ),
                      childCount: _flights.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: LuxuryTravelTheme.cardBackground,
      foregroundColor: LuxuryTravelTheme.darkText,
      elevation: 0,
      scrolledUnderElevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Text(
        '航班搜索结果',
        style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.darkText).copyWith(fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSearchSummary(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: LuxuryTravelTheme.cardBackground,
      child: Row(
        children: [
          Icon(Icons.flight_takeoff_rounded, size: 18, color: LuxuryTravelTheme.primaryGold),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '北京 → 上海',
              style: LuxuryTravelTheme.bodyMedium(LuxuryTravelTheme.darkText)
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: LuxuryTravelTheme.primaryGoldPale,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '单程',
              style: LuxuryTravelTheme.caption(LuxuryTravelTheme.darkText)
                  .copyWith(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _onBookFlight(BuildContext context, _FlightItem flight) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认预订'),
        content: Text(
          '${flight.departureCity} → ${flight.arrivalCity}\n'
          '${flight.departureTime} - ${flight.arrivalTime} · ${flight.duration}\n'
          '${flight.airlineName} · ¥${flight.price}',
          style: LuxuryTravelTheme.bodyMedium(LuxuryTravelTheme.darkText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('取消', style: TextStyle(color: LuxuryTravelTheme.textSecondary)),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: LuxuryTravelTheme.primaryGold, foregroundColor: LuxuryTravelTheme.darkText),
            child: const Text('确定'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        context.push('/orders');
      }
    });
  }

  Widget _buildFilterRow() {
    return Container(
      color: LuxuryTravelTheme.background,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: List.generate(_filterLabels.length, (i) {
          final selected = _filterIndex == i;
          return Padding(
            padding: EdgeInsets.only(right: i < _filterLabels.length - 1 ? 10 : 0),
            child: Material(
              color: selected
                  ? LuxuryTravelTheme.primaryGold.withValues(alpha: 0.18)
                  : LuxuryTravelTheme.cardBackground,
              borderRadius: BorderRadius.circular(22),
              elevation: selected ? 0 : 0,
              shadowColor: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _filterIndex = i),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: selected
                        ? Border.all(color: LuxuryTravelTheme.primaryGold.withValues(alpha: 0.5), width: 1)
                        : null,
                  ),
                  child: Text(
                    _filterLabels[i],
                    style: LuxuryTravelTheme.bodyMedium(
                            selected ? LuxuryTravelTheme.darkText : LuxuryTravelTheme.textSecondary)
                        .copyWith(
                            fontSize: 14, fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ——— Flight item & card ———

class _FlightItem {
  _FlightItem({
    required this.airlineName,
    required this.airlineCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.departureCity,
    required this.arrivalCity,
  });

  final String airlineName;
  final String airlineCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final int price;
  final String departureCity;
  final String arrivalCity;
}

/// Redesigned flight card: cream background, soft shadow, gold left stripe,
/// left = times + duration, right = price + outlined book button, hover lift.
class _FlightCard extends StatefulWidget {
  const _FlightCard({
    required this.flight,
    required this.onBook,
  });

  final _FlightItem flight;
  final VoidCallback onBook;

  @override
  State<_FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<_FlightCard> {
  bool _hovered = false;

  static const double _goldStripeWidth = 2;
  static const double _cardRadius = 16;

  /// Cream background for flight cards (warm off-white).
  static const Color _cream = Color(0xFFFFFEFB);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        child: Container(
          decoration: BoxDecoration(
            color: _cream,
            borderRadius: BorderRadius.circular(_cardRadius),
            border: Border.all(
              color: LuxuryTravelTheme.border.withValues(alpha: 0.6),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF000000).withValues(alpha: 0.05),
                offset: Offset(0, _hovered ? 6 : 2),
                blurRadius: _hovered ? 20 : 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_cardRadius),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Gold accent stripe (2px left)
                  Container(
                    width: _goldStripeWidth,
                    color: LuxuryTravelTheme.primaryGold,
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                      child: Row(
                        children: [
                          // Left: departure (large bold), arrival, duration
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    widget.flight.departureTime,
                                    style: LuxuryTravelTheme.displayLarge(LuxuryTravelTheme.darkText).copyWith(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                const SizedBox(height: LuxuryTravelTheme.spacingXs),
                                Text(
                                  widget.flight.arrivalTime,
                                  style: LuxuryTravelTheme.bodyMedium(LuxuryTravelTheme.textSecondary).copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: LuxuryTravelTheme.spacingSm),
                                Text(
                                  widget.flight.duration,
                                  style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Right: price (large gold) + outlined book button
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¥${widget.flight.price}',
                                style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.primaryGold).copyWith(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: widget.onBook,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: LuxuryTravelTheme.primaryGold,
                                  side: const BorderSide(
                                    color: LuxuryTravelTheme.primaryGold,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('预订'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
