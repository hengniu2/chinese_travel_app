import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/luxury_travel_theme.dart';

/// Round-trip flight result page: outbound + return grouped, combined price, book button.
class RoundTripResultPage extends StatelessWidget {
  const RoundTripResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxuryTravelTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
              '往返航班',
              style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.darkText).copyWith(fontSize: 18),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: LuxuryTravelTheme.cardBackground,
              child: Row(
                children: [
                  Icon(Icons.flight_rounded, size: 18, color: LuxuryTravelTheme.primaryGold),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '北京 ⇄ 上海',
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
                      '往返',
                      style: LuxuryTravelTheme.caption(LuxuryTravelTheme.darkText)
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                '共 ${_roundTripOptions.length} 个组合',
                style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textSecondary)
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _RoundTripCard(
                    option: _roundTripOptions[index],
                    onBook: () {
                      // TODO: Navigate to round-trip booking
                    },
                  ),
                ),
                childCount: _roundTripOptions.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Data ———

class _Leg {
  _Leg({
    required this.airlineName,
    required this.airlineCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.departureCity,
    required this.arrivalCity,
  });

  final String airlineName;
  final String airlineCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String departureCity;
  final String arrivalCity;
}

class _RoundTripOption {
  _RoundTripOption({
    required this.outbound,
    required this.returnLeg,
    required this.combinedPrice,
  });

  final _Leg outbound;
  final _Leg returnLeg;
  final int combinedPrice;
}

final List<_RoundTripOption> _roundTripOptions = [
  _RoundTripOption(
    outbound: _Leg(
      airlineName: '中国国航',
      airlineCode: 'CA',
      departureTime: '08:30',
      arrivalTime: '10:45',
      duration: '2h 15m',
      departureCity: '北京',
      arrivalCity: '上海',
    ),
    returnLeg: _Leg(
      airlineName: '中国国航',
      airlineCode: 'CA',
      departureTime: '18:20',
      arrivalTime: '20:35',
      duration: '2h 15m',
      departureCity: '上海',
      arrivalCity: '北京',
    ),
    combinedPrice: 1280,
  ),
  _RoundTripOption(
    outbound: _Leg(
      airlineName: '东方航空',
      airlineCode: 'MU',
      departureTime: '12:00',
      arrivalTime: '14:20',
      duration: '2h 20m',
      departureCity: '北京',
      arrivalCity: '上海',
    ),
    returnLeg: _Leg(
      airlineName: '东方航空',
      airlineCode: 'MU',
      departureTime: '16:00',
      arrivalTime: '18:15',
      duration: '2h 15m',
      departureCity: '上海',
      arrivalCity: '北京',
    ),
    combinedPrice: 1180,
  ),
  _RoundTripOption(
    outbound: _Leg(
      airlineName: '南方航空',
      airlineCode: 'CZ',
      departureTime: '15:45',
      arrivalTime: '18:00',
      duration: '2h 15m',
      departureCity: '北京',
      arrivalCity: '上海',
    ),
    returnLeg: _Leg(
      airlineName: '南方航空',
      airlineCode: 'CZ',
      departureTime: '09:30',
      arrivalTime: '11:45',
      duration: '2h 15m',
      departureCity: '上海',
      arrivalCity: '北京',
    ),
    combinedPrice: 1120,
  ),
];

// ——— Card ———

class _RoundTripCard extends StatelessWidget {
  const _RoundTripCard({
    required this.option,
    required this.onBook,
  });

  final _RoundTripOption option;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: LuxuryTravelTheme.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: LuxuryTravelTheme.border.withValues(alpha: 0.6), width: 0.5),
        boxShadow: LuxuryTravelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionLabel('去程'),
          const SizedBox(height: 10),
          _LegRow(leg: option.outbound),
          const SizedBox(height: 16),
          _buildSectionLabel('返程'),
          const SizedBox(height: 10),
          _LegRow(leg: option.returnLeg),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '¥${option.combinedPrice}',
                style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.price).copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                ' 往返总价',
                style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary),
              ),
              const Spacer(),
              Material(
                color: LuxuryTravelTheme.primaryGold,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  onTap: onBook,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                    child: Text(
                      '预订',
                      style: LuxuryTravelTheme.buttonLabel(LuxuryTravelTheme.darkText).copyWith(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textSecondary).copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _LegRow extends StatelessWidget {
  const _LegRow({required this.leg});

  final _Leg leg;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: LuxuryTravelTheme.surfaceMuted,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            leg.airlineCode,
            style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textSecondary).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leg.airlineName,
                style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.darkText).copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leg.departureTime,
                        style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.darkText).copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        leg.departureCity,
                        style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary).copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Text(
                            leg.duration,
                            style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary).copyWith(
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              5,
                              (i) => Container(
                                margin: EdgeInsets.only(right: i < 4 ? 2 : 0),
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  color: LuxuryTravelTheme.textTertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        leg.arrivalTime,
                        style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.darkText).copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        leg.arrivalCity,
                        style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary).copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
