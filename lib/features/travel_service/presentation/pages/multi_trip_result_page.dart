import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_shadow.dart';

/// Multi-city flight result page: segments summary, total price, confirm booking button.
class MultiTripResultPage extends StatelessWidget {
  const MultiTripResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('多程航班搜索结果'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
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
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '总价',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '¥${_multiTripOption.totalPrice}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.price,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(26),
                child: InkWell(
                  onTap: () {
                    // TODO: Confirm booking
                  },
                  borderRadius: BorderRadius.circular(26),
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    child: const Text(
                      '确认预订',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadow.light,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.flight_rounded,
                  size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                '行程概览（${option.segments.length}段）',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
                          color: AppColors.divider,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '转机',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
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
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                '¥${option.totalPrice}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.price,
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
            color: AppColors.primaryPale,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '${segment.segmentIndex}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      segment.airlineCode,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    segment.departureTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    ' ${segment.departureCity}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      segment.duration,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ),
                  Text(
                    segment.arrivalTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    ' ${segment.arrivalCity}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textTertiary,
                    ),
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
