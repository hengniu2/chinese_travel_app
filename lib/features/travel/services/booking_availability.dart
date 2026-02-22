import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking_models.dart';
import '../models/travel_package.dart';

/// Provides available departure dates with dynamic pricing and add-ons for a package.
class BookingAvailability {
  /// Next 90 days: weekend/holiday = peak (higher), else off-peak. Unavailable: past or random 20%.
  List<AvailableDate> getAvailableDates(TravelPackage package, {DateTime? from}) {
    final start = from ?? DateTime.now();
    final basePrice = package.price;
    final dates = <AvailableDate>[];
    for (var i = 0; i < 90; i++) {
      final d = DateTime(start.year, start.month, start.day + i);
      if (d.isBefore(DateTime.now())) continue;
      final isWeekend = d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;
      final isPeak = isWeekend || _isHoliday(d);
      final price = isPeak ? basePrice * 1.12 : basePrice * 0.95;
      final available = (d.day + d.month) % 5 != 0; // mock: some dates unavailable
      dates.add(AvailableDate(date: d, price: price, available: available));
    }
    return dates;
  }

  static bool _isHoliday(DateTime d) {
    final m = d.month;
    final day = d.day;
    if (m == 1 && (day >= 1 && day <= 3)) return true;
    if (m == 5 && day == 1) return true;
    if (m == 10 && (day >= 1 && day <= 7)) return true;
    return false;
  }

  /// Optional add-ons for this package (airport transfer, upgrade, insurance, guide).
  List<BookingAddOn> getAddOns(TravelPackage package) {
    return [
      const BookingAddOn(
        id: 'transfer',
        name: 'Airport transfer',
        description: 'Round-trip transfer between airport and hotel',
        price: 198,
        iconId: 'transfer',
      ),
      const BookingAddOn(
        id: 'room_upgrade',
        name: 'Room upgrade',
        description: 'Upgrade to deluxe room',
        price: 380,
        iconId: 'upgrade',
      ),
      const BookingAddOn(
        id: 'insurance',
        name: 'Travel insurance',
        description: 'Coverage for trip cancellation and medical',
        price: 58,
        iconId: 'insurance',
      ),
      const BookingAddOn(
        id: 'guide',
        name: 'Private guide',
        description: 'Dedicated guide for your group (per day)',
        price: 680,
        iconId: 'guide',
      ),
    ];
  }
}

final bookingAvailabilityProvider = Provider<BookingAvailability>((ref) {
  return BookingAvailability();
});
