import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../coupon/providers/coupon_provider.dart';
import '../domain/booking.dart';

/// Draft state for the current hotel booking flow (Steps 1–4).
/// Filled on confirm page, guest page, then payment creates final [HotelBooking].
class HotelBookingDraft {
  const HotelBookingDraft({
    required this.hotelId,
    required this.hotelName,
    required this.roomId,
    required this.roomName,
    required this.roomPrice,
    required this.checkIn,
    required this.checkOut,
    this.guests = const [HotelBookingGuest()],
    this.serviceFee = 0,
  });

  final String hotelId;
  final String hotelName;
  final String roomId;
  final String roomName;
  final double roomPrice;
  final DateTime checkIn;
  final DateTime checkOut;
  final List<HotelBookingGuest> guests;
  final double serviceFee;

  HotelBookingDraft copyWith({
    String? hotelId,
    String? hotelName,
    String? roomId,
    String? roomName,
    double? roomPrice,
    DateTime? checkIn,
    DateTime? checkOut,
    List<HotelBookingGuest>? guests,
    double? serviceFee,
  }) {
    return HotelBookingDraft(
      hotelId: hotelId ?? this.hotelId,
      hotelName: hotelName ?? this.hotelName,
      roomId: roomId ?? this.roomId,
      roomName: roomName ?? this.roomName,
      roomPrice: roomPrice ?? this.roomPrice,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      guests: guests ?? this.guests,
      serviceFee: serviceFee ?? this.serviceFee,
    );
  }
}

final hotelBookingDraftProvider =
    StateNotifierProvider<HotelBookingDraftNotifier, HotelBookingDraft?>((ref) {
  return HotelBookingDraftNotifier(ref);
});

class HotelBookingDraftNotifier extends StateNotifier<HotelBookingDraft?> {
  HotelBookingDraftNotifier(this._ref) : super(null);

  final Ref _ref;

  void startDraft(HotelBookingDraft draft) {
    state = draft;
  }

  void setDates(DateTime checkIn, DateTime checkOut) {
    final d = state;
    if (d == null) return;
    state = d.copyWith(checkIn: checkIn, checkOut: checkOut);
  }

  void setGuests(List<HotelBookingGuest> guests) {
    final d = state;
    if (d == null) return;
    state = d.copyWith(guests: guests);
  }

  void clear() {
    state = null;
    clearSelectedCoupon(_ref);
  }
}

/// Coupon discount for current draft.
final hotelBookingCouponDiscountProvider = Provider<double>((ref) {
  final draft = ref.watch(hotelBookingDraftProvider);
  if (draft == null) return 0;
  final selected = ref.watch(selectedCouponForBookingProvider);
  return discountForSelectedCoupon(selected, draft.roomPrice + draft.serviceFee);
});

/// Total payable for current draft (room + serviceFee - coupon).
final hotelBookingTotalPayableProvider = Provider<double>((ref) {
  final draft = ref.watch(hotelBookingDraftProvider);
  if (draft == null) return 0;
  final selected = ref.watch(selectedCouponForBookingProvider);
  return finalAmountAfterCoupon(
    draft.roomPrice + draft.serviceFee,
    selected,
  );
});

/// Last completed booking (for success page and "View order").
final lastHotelBookingProvider = StateProvider<HotelBooking?>((ref) => null);

/// List of all hotel bookings (in-memory; can replace with repository).
final hotelBookingsProvider =
    StateNotifierProvider<HotelBookingsNotifier, List<HotelBooking>>((ref) {
  return HotelBookingsNotifier(ref);
});

class HotelBookingsNotifier extends StateNotifier<List<HotelBooking>> {
  HotelBookingsNotifier(this._ref) : super([]);

  final Ref _ref;

  void addBooking(HotelBooking booking) {
    state = [booking, ...state];
    _ref.read(lastHotelBookingProvider.notifier).state = booking;
  }
}
