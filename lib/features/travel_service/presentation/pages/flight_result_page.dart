import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_shadow.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('航班搜索结果'),
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
          _buildFilterRow(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: _flights.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _FlightCard(
                  flight: _flights[index],
                  onBook: () {
                    // TODO: Navigate to booking
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Row(
        children: List.generate(_filterLabels.length, (i) {
          final selected = _filterIndex == i;
          return Padding(
            padding: EdgeInsets.only(right: i < _filterLabels.length - 1 ? 10 : 0),
            child: Material(
              color: selected ? AppColors.primaryPale : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => setState(() => _filterIndex = i),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Text(
                    _filterLabels[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
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

class _FlightCard extends StatelessWidget {
  const _FlightCard({
    required this.flight,
    required this.onBook,
  });

  final _FlightItem flight;
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAirlineLogo(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.airlineName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flight.departureTime,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              flight.departureCity,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Text(
                                  flight.duration,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Container(
                                      margin: EdgeInsets.only(
                                          right: i < 4 ? 2 : 0),
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
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
                              flight.arrivalTime,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              flight.arrivalCity,
                              style: TextStyle(
                                fontSize: 12,
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
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '¥${flight.price}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.price,
                ),
              ),
              const Text(
                ' 起',
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
                        horizontal: 20, vertical: 10),
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

  Widget _buildAirlineLogo() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        flight.airlineCode,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
