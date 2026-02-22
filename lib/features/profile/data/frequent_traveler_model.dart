/// A saved frequent traveler (出行人) for bookings.
class FrequentTravelerModel {
  const FrequentTravelerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.idNumber,
    this.isDefault = false,
  });

  final String id;
  final String name;
  final String phone;
  final String idNumber;
  final bool isDefault;
}
