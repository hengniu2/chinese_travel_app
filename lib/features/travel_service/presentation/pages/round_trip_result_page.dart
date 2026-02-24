import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_shadow.dart';

/// Round-trip flight result page: outbound + return grouped, combined price, book button.
class RoundTripResultPage extends StatelessWidget {
  const RoundTripResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('往返航班搜索结果'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _roundTripOptions.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _RoundTripCard(
            option: _roundTripOptions[index],
            onBook: () {
              // TODO: Navigate to round-trip booking
            },
          ),
        ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadow.light,
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
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.price,
                ),
              ),
              const Text(
                ' 往返总价',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary,
                ),
              ),
              const Spacer(),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  onTap: onBook,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 10),
                    child: const Text(
                      '预订',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
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
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
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
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            leg.airlineCode,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        leg.departureCity,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
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
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textTertiary,
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
                                  color: AppColors.textTertiary,
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        leg.arrivalCity,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiary,
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
