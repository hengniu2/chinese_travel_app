/// One traveler in the booking flow.
class TravelerInfo {
  const TravelerInfo({
    this.name,
    this.phone,
    this.idNumber,
    this.passportNumber,
    this.specialRequests,
  });

  final String? name;
  final String? phone;
  /// ID card number (China).
  final String? idNumber;
  /// Passport number (if needed for destination).
  final String? passportNumber;
  final String? specialRequests;

  TravelerInfo copyWith({
    String? name,
    String? phone,
    String? idNumber,
    String? passportNumber,
    String? specialRequests,
  }) {
    return TravelerInfo(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      idNumber: idNumber ?? this.idNumber,
      passportNumber: passportNumber ?? this.passportNumber,
      specialRequests: specialRequests ?? this.specialRequests,
    );
  }

  bool get isComplete =>
      (name != null && name!.trim().isNotEmpty) &&
      (phone != null && phone!.trim().isNotEmpty);
}

/// Optional add-on for booking (airport transfer, room upgrade, insurance, etc.).
class BookingAddOn {
  const BookingAddOn({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.iconId,
  });

  final String id;
  final String name;
  final String? description;
  /// Price per booking or per person (clarify in UI).
  final double price;
  /// Optional icon key for UI (e.g. 'transfer', 'upgrade', 'insurance', 'guide').
  final String? iconId;
}

/// A date available for departure with its price (dynamic/peak/off-peak).
class AvailableDate {
  const AvailableDate({
    required this.date,
    required this.price,
    this.available = true,
  });

  final DateTime date;
  final double price;
  final bool available;
}
