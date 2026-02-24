import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/design_system/app_colors.dart';
import '../../../../shared/design_system/app_shadow.dart';
import '../../models/flight_filter.dart';
import '../../models/models.dart';
import '../../providers/filter_provider.dart';
import '../../providers/flight_search_provider.dart';
import '../../providers/travel_service_providers.dart';

/// Flight result page wired to flightSearchResultsProvider + filterProvider.
/// Example of UI consuming Riverpod state.
class FlightResultPageRefactored extends ConsumerWidget {
  const FlightResultPageRefactored({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightsAsync = ref.watch(flightSearchResultsProvider);
    final filterType = ref.watch(flightFilterProvider);
    final filterNotifier = ref.read(flightFilterProvider.notifier);
    final bookingNotifier = ref.read(flightBookingProvider.notifier);

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
          _FilterRow(
            selected: filterType,
            onSelect: filterNotifier.setFilter,
          ),
          Expanded(
            child: flightsAsync.when(
              data: (flights) {
                final sorted = _sortFlights(flights, filterType);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: sorted.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _FlightCard(
                      flight: sorted[index],
                      onBook: () {
                        bookingNotifier.selectFlight(sorted[index]);
                        // TODO: Navigate to booking flow
                      },
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (e, _) => Center(
                child: Text('加载失败: $e'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlightItem> _sortFlights(
    List<FlightItem> flights,
    FlightFilterType filter,
  ) {
    final list = List<FlightItem>.from(flights);
    switch (filter) {
      case FlightFilterType.price:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case FlightFilterType.departureTime:
        list.sort((a, b) =>
            a.departureTime.compareTo(b.departureTime));
        break;
      case FlightFilterType.airline:
        list.sort((a, b) =>
            a.airlineName.compareTo(b.airlineName));
        break;
    }
    return list;
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.selected,
    required this.onSelect,
  });

  final FlightFilterType selected;
  final void Function(FlightFilterType) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Row(
        children: FlightFilterType.values.map((type) {
          final isSelected = selected == type;
          return Padding(
            padding: EdgeInsets.only(
              right: type != FlightFilterType.airline ? 10 : 0,
            ),
            child: Material(
              color: isSelected ? AppColors.primaryPale : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onSelect(type),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Text(
                    type.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  const _FlightCard({
    required this.flight,
    required this.onBook,
  });

  final FlightItem flight;
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
              Container(
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
              ),
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
                            child: Text(
                              flight.duration,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textTertiary,
                              ),
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
              const Text(' 起', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
              const Spacer(),
              Material(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  onTap: onBook,
                  borderRadius: BorderRadius.circular(22),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
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
}
