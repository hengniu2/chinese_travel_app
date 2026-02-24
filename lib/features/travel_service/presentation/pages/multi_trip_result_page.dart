import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/luxury_travel_theme.dart';
import '../widgets/flight_detail_booking_bar.dart';

/// Multi-city flight result page: segments summary, total price, confirm booking button.
class MultiTripResultPage extends StatelessWidget {
  const MultiTripResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LuxuryTravelTheme.background,
      appBar: AppBar(
        title: const Text('多程航班搜索结果'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        backgroundColor: LuxuryTravelTheme.cardBackground,
        foregroundColor: LuxuryTravelTheme.darkText,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                _MultiTripSummaryCard(option: _multiTripOption),
              ],
            ),
          ),
          FlightDetailBookingBar(
            totalPrice: _multiTripOption.totalPrice,
            onReserveTap: () {
              // TODO: Confirm booking
            },
            buttonLabel: '确认预订',
          ),
        ],
      ),
    );
  }

}

// ——— Data ———

class _MultiTripSegment {
  _MultiTripSegment({
    required this.segmentIndex,
    required this.airlineName,
    required this.airlineCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.departureCity,
    required this.arrivalCity,
  });

  final int segmentIndex;
  final String airlineName;
  final String airlineCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String departureCity;
  final String arrivalCity;
}

class _MultiTripOption {
  _MultiTripOption({
    required this.segments,
    required this.totalPrice,
  });

  final List<_MultiTripSegment> segments;
  final int totalPrice;
}

final _MultiTripOption _multiTripOption = _MultiTripOption(
  segments: [
    _MultiTripSegment(
      segmentIndex: 1,
      airlineName: '中国国航',
      airlineCode: 'CA',
      departureTime: '08:30',
      arrivalTime: '10:45',
      duration: '2h 15m',
      departureCity: '北京',
      arrivalCity: '上海',
    ),
    _MultiTripSegment(
      segmentIndex: 2,
      airlineName: '东方航空',
      airlineCode: 'MU',
      departureTime: '14:00',
      arrivalTime: '16:30',
      duration: '2h 30m',
      departureCity: '上海',
      arrivalCity: '广州',
    ),
    _MultiTripSegment(
      segmentIndex: 3,
      airlineName: '南方航空',
      airlineCode: 'CZ',
      departureTime: '09:20',
      arrivalTime: '12:00',
      duration: '2h 40m',
      departureCity: '广州',
      arrivalCity: '北京',
    ),
  ],
  totalPrice: 2680,
);

// ——— Summary card ———

class _MultiTripSummaryCard extends StatelessWidget {
  const _MultiTripSummaryCard({required this.option});

  final _MultiTripOption option;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LuxuryTravelTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: LuxuryTravelTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.flight_rounded,
                  size: 20, color: LuxuryTravelTheme.textSecondary),
              const SizedBox(width: 8),
              Text(
                '行程概览（${option.segments.length}段）',
                style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.darkText).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(option.segments.length, (i) {
            final seg = option.segments[i];
            final isLast = i == option.segments.length - 1;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SegmentRow(segment: seg),
                if (!isLast)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 6, bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 16,
                          color: LuxuryTravelTheme.divider,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '转机',
                          style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '合计',
                style: LuxuryTravelTheme.bodyMedium(LuxuryTravelTheme.textSecondary).copyWith(
                  fontSize: 14,
                ),
              ),
              Text(
                '¥${option.totalPrice}',
                style: LuxuryTravelTheme.headlineMedium(LuxuryTravelTheme.price).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentRow extends StatelessWidget {
  const _SegmentRow({required this.segment});

  final _MultiTripSegment segment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: LuxuryTravelTheme.primaryGoldPale,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '${segment.segmentIndex}',
            style: LuxuryTravelTheme.caption(LuxuryTravelTheme.darkText).copyWith(
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
                '第${segment.segmentIndex}段  ${segment.departureCity} → ${segment.arrivalCity}',
                style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.darkText).copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 28,
                    decoration: BoxDecoration(
                      color: LuxuryTravelTheme.surfaceMuted,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      segment.airlineCode,
                      style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textSecondary).copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    segment.departureTime,
                    style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.darkText).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' ${segment.departureCity}',
                    style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      segment.duration,
                      style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary).copyWith(
                        fontSize: 11,
                      ),
                    ),
                  ),
                  Text(
                    segment.arrivalTime,
                    style: LuxuryTravelTheme.titleSmall(LuxuryTravelTheme.darkText).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ' ${segment.arrivalCity}',
                    style: LuxuryTravelTheme.caption(LuxuryTravelTheme.textTertiary),
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
