import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/design_system/design_system.dart';
import '../models/booking_models.dart';
import '../state/package_data_state.dart';
import '../state/state.dart';
import '../services/booking_availability.dart';
import 'booking_step_indicator.dart';

/// Step 1: Select departure date. Calendar with prices, summary card, Next.
class BookingSelectDatePage extends ConsumerStatefulWidget {
  const BookingSelectDatePage({super.key, required this.packageId});

  final String packageId;

  @override
  ConsumerState<BookingSelectDatePage> createState() => _BookingSelectDatePageState();
}

class _BookingSelectDatePageState extends ConsumerState<BookingSelectDatePage> {
  DateTime? _selectedDate;
  double? _selectedPrice;
  List<AvailableDate> _dates = [];
  double? _lowestPrice;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(travelBookingStateProvider.notifier).startBooking(widget.packageId);
      _loadDates();
    });
  }

  void _loadDates() {
    final package = ref.read(travelPackageDetailProvider(widget.packageId)).valueOrNull;
    if (package == null) return;
    final availability = ref.read(bookingAvailabilityProvider);
    final dates = availability.getAvailableDates(package);
    final availableDates = dates.where((d) => d.available).toList();
    final lowest = availableDates.isEmpty ? null : availableDates.map((d) => d.price).reduce((a, b) => a < b ? a : b);
    setState(() {
      _dates = dates;
      _lowestPrice = lowest;
    });
  }

  @override
  Widget build(BuildContext context) {
    final packageAsync = ref.watch(travelPackageDetailProvider(widget.packageId));
    final booking = ref.watch(travelBookingStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return packageAsync.when(
      data: (package) {
        if (package == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.bookingSelectDate)),
            body: const Center(child: Text('Package not found')),
          );
        }
        return _buildContent(context, package, booking, l10n);
      },
      loading: () => Scaffold(
        backgroundColor: TravelDesignTokens.background,
        appBar: AppBar(
          title: Text(l10n.bookingSelectDate),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(l10n.bookingSelectDate)),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    dynamic package,
    dynamic booking,
    AppLocalizations l10n,
  ) {
    final durationDays = package.durationDays ?? 1;
    final travelers = booking.travelerCount;
    final basePrice = (_selectedPrice ?? package.price) * travelers;
    final estimatedTotal = basePrice;

    return Scaffold(
      backgroundColor: TravelDesignTokens.background,
      appBar: AppBar(
        title: Text(l10n.bookingSelectDate),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: TravelDesignTokens.screenHorizontal,
                vertical: 12,
              ),
              child: BookingStepIndicator(currentStep: 1, totalSteps: 6),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: TravelDesignTokens.screenHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CalendarSection(
                      dates: _dates,
                      lowestPrice: _lowestPrice,
                      selectedDate: _selectedDate,
                      selectedPrice: _selectedPrice,
                      l10n: l10n,
                      onSelect: (date, price) {
                        setState(() {
                          _selectedDate = date;
                          _selectedPrice = price;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _SummaryCard(
                      durationDays: durationDays,
                      travelers: travelers,
                      basePrice: _selectedPrice != null ? _selectedPrice! * travelers : null,
                      estimatedTotal: estimatedTotal,
                      l10n: l10n,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                TravelDesignTokens.screenHorizontal,
                12,
                TravelDesignTokens.screenHorizontal,
                16,
              ),
              child: TravelPrimaryButton(
                label: l10n.bookingNext,
                onPressed: _selectedDate == null
                    ? null
                    : () {
                        ref.read(travelBookingStateProvider.notifier).setDepartureDate(
                              _selectedDate,
                              price: _selectedPrice,
                            );
                        context.push(
                          '/planner/detail/${widget.packageId}/booking/travelers',
                        );
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection({
    required this.dates,
    required this.lowestPrice,
    required this.selectedDate,
    required this.selectedPrice,
    required this.l10n,
    required this.onSelect,
  });

  final List<AvailableDate> dates;
  final double? lowestPrice;
  final DateTime? selectedDate;
  final double? selectedPrice;
  final AppLocalizations l10n;
  final void Function(DateTime date, double price) onSelect;

  @override
  Widget build(BuildContext context) {
    if (dates.isEmpty) {
      return const SizedBox(height: 200);
    }
    final first = dates.first.date;
    final month1 = _buildMonth(first.year, first.month);
    final secondStart = DateTime(first.year, first.month + 1, 1);
    final month2 = _buildMonth(secondStart.year, secondStart.month);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MonthTitle(DateTime(first.year, first.month)),
        const SizedBox(height: 8),
        month1,
        const SizedBox(height: 20),
        _MonthTitle(secondStart),
        const SizedBox(height: 8),
        month2,
      ],
    );
  }

  Widget _buildMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = start.weekday % 7;
    final dateMap = <int, AvailableDate>{};
    for (final ad in dates) {
      if (ad.date.year == year && ad.date.month == month) {
        dateMap[ad.date.day] = ad;
      }
    }
    final cells = <Widget>[];
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    for (final w in weekdays) {
      cells.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Center(
            child: Text(
              w,
              style: TravelDesignTokens.caption(AppColors.textTertiary),
            ),
          ),
        ),
      );
    }
    for (var i = 0; i < firstWeekday; i++) {
      cells.add(const SizedBox());
    }
    for (var d = 1; d <= daysInMonth; d++) {
      final date = DateTime(year, month, d);
      final ad = dateMap[d];
      final isSelected = selectedDate != null &&
          selectedDate!.year == date.year &&
          selectedDate!.month == date.month &&
          selectedDate!.day == date.day;
      final isLowest = ad != null && ad.available && lowestPrice != null && (ad.price - lowestPrice!).abs() < 1;
      cells.add(_DayCell(
        date: date,
        available: ad?.available ?? false,
        price: ad?.price,
        isSelected: isSelected,
        isLowest: isLowest,
        l10n: l10n,
        onTap: ad != null && ad.available
            ? () => onSelect(ad.date, ad.price)
            : null,
      ));
    }
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      childAspectRatio: 0.85,
      children: cells,
    );
  }
}

class _MonthTitle extends StatelessWidget {
  const _MonthTitle(this.date);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.yMMM().format(date),
      style: TravelDesignTokens.titleL(null),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.available,
    this.price,
    required this.isSelected,
    required this.isLowest,
    required this.l10n,
    this.onTap,
  });

  final DateTime date;
  final bool available;
  final double? price;
  final bool isSelected;
  final bool isLowest;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? TravelDesignTokens.primary.withValues(alpha: 0.15)
          : Colors.transparent,
      borderRadius: TravelDesignTokens.borderRadiusSmall,
      child: InkWell(
        onTap: onTap,
        borderRadius: TravelDesignTokens.borderRadiusSmall,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLowest)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: TravelDesignTokens.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    l10n.bookingLowestPrice,
                    style: TravelDesignTokens.caption(Colors.white).copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Text(
                '${date.day}',
                style: TravelDesignTokens.body(null).copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: available
                      ? (isSelected ? TravelDesignTokens.primary : AppColors.textPrimary)
                      : AppColors.textTertiary,
                ),
              ),
              Text(
                price != null ? '¥${price!.toStringAsFixed(0)}' : l10n.bookingUnavailable,
                style: TravelDesignTokens.caption(
                  available ? AppColors.textSecondary : AppColors.textTertiary,
                ).copyWith(fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.durationDays,
    required this.travelers,
    this.basePrice,
    required this.estimatedTotal,
    required this.l10n,
  });

  final int durationDays;
  final int travelers;
  final double? basePrice;
  final double estimatedTotal;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TravelDesignTokens.cardPadding),
      decoration: BoxDecoration(
        color: TravelDesignTokens.card,
        borderRadius: TravelDesignTokens.borderRadiusMedium,
        boxShadow: TravelDesignTokens.shadowLevel1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(l10n.bookingDuration, '$durationDays days'),
          const SizedBox(height: 8),
          _row(l10n.bookingTravelersCount, '$travelers'),
          if (basePrice != null) ...[
            const SizedBox(height: 8),
            _row(l10n.bookingBasePrice, '¥${basePrice!.toStringAsFixed(0)}'),
          ],
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.bookingEstimatedTotal,
                style: TravelDesignTokens.titleL(null),
              ),
              PriceTag(price: estimatedTotal, size: PriceTagSize.medium),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TravelDesignTokens.body(AppColors.textSecondary)),
        Text(value, style: TravelDesignTokens.body(null)),
      ],
    );
  }
}
