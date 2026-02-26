/// Detail model for a single insurance product (from catalog API).
class InsuranceDetail {
  const InsuranceDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.validityDays,
    this.description,
    this.insuranceType,
    this.coverageAmount,
  });

  final String id;
  final String name;
  final double price;
  final int validityDays;
  final String? description;
  final String? insuranceType;
  final double? coverageAmount;
}
