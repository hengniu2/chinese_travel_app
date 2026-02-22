import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/booking_models.dart';

/// Booking flow state: package, date, travelers, add-ons, etc.
/// Steps: Select Date → Travelers → Add-ons → Review → Payment → Confirmation.
class TravelBookingState {
  const TravelBookingState({
    this.packageId,
    this.departureDate,
    this.datePrice,
    this.travelerCount = 1,
    this.travelers = const [],
    this.selectedAddOnIds = const [],
    this.contactPhone,
    this.contactEmail,
    this.notes,
    this.orderId,
    this.pointsToRedeem = 0,
  });

  final String? packageId;
  final DateTime? departureDate;
  /// Price per person for selected date (from available dates).
  final double? datePrice;
  final int travelerCount;
  final List<TravelerInfo> travelers;
  final List<String> selectedAddOnIds;
  final String? contactPhone;
  final String? contactEmail;
  final String? notes;
  /// Set after payment success for confirmation.
  final String? orderId;
  /// Points to redeem for discount (0 = not using points).
  final int pointsToRedeem;

  TravelBookingState copyWith({
    String? packageId,
    DateTime? departureDate,
    double? datePrice,
    int? travelerCount,
    List<TravelerInfo>? travelers,
    List<String>? selectedAddOnIds,
    String? contactPhone,
    String? contactEmail,
    String? notes,
    String? orderId,
    int? pointsToRedeem,
  }) {
    return TravelBookingState(
      packageId: packageId ?? this.packageId,
      departureDate: departureDate ?? this.departureDate,
      datePrice: datePrice ?? this.datePrice,
      travelerCount: travelerCount ?? this.travelerCount,
      travelers: travelers ?? this.travelers,
      selectedAddOnIds: selectedAddOnIds ?? this.selectedAddOnIds,
      contactPhone: contactPhone ?? this.contactPhone,
      contactEmail: contactEmail ?? this.contactEmail,
      notes: notes ?? this.notes,
      orderId: orderId ?? this.orderId,
      pointsToRedeem: pointsToRedeem ?? this.pointsToRedeem,
    );
  }
}

final travelBookingStateProvider =
    StateNotifierProvider<TravelBookingStateNotifier, TravelBookingState>(
  (ref) => TravelBookingStateNotifier(),
);

class TravelBookingStateNotifier extends StateNotifier<TravelBookingState> {
  TravelBookingStateNotifier() : super(const TravelBookingState());

  void startBooking(String packageId) {
    state = TravelBookingState(packageId: packageId);
  }

  void setDepartureDate(DateTime? date, {double? price}) {
    state = state.copyWith(departureDate: date, datePrice: price);
  }

  void setTravelerCount(int count) {
    state = state.copyWith(travelerCount: count.clamp(1, 99));
  }

  void setTravelers(List<TravelerInfo> list) {
    state = state.copyWith(travelers: list);
  }

  void updateTraveler(int index, TravelerInfo info) {
    final list = List<TravelerInfo>.from(state.travelers);
    while (list.length <= index) list.add(const TravelerInfo());
    list[index] = info;
    state = state.copyWith(travelers: list);
  }

  void addTraveler() {
    state = state.copyWith(
      travelerCount: state.travelerCount + 1,
      travelers: [...state.travelers, const TravelerInfo()],
    );
  }

  void setSelectedAddOns(List<String> ids) {
    state = state.copyWith(selectedAddOnIds: ids);
  }

  void toggleAddOn(String id) {
    final list = List<String>.from(state.selectedAddOnIds);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    state = state.copyWith(selectedAddOnIds: list);
  }

  void setContact(String? phone, String? email) {
    state = state.copyWith(contactPhone: phone, contactEmail: email);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void setOrderId(String orderId) {
    state = state.copyWith(orderId: orderId);
  }

  void setPointsToRedeem(int points) {
    state = state.copyWith(pointsToRedeem: points.clamp(0, 999999));
  }

  void reset() {
    state = const TravelBookingState();
  }
}
