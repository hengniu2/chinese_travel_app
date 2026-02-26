/// List item for insurance product (from catalog API).
class InsuranceItem {
  const InsuranceItem({
    required this.id,
    required this.name,
    required this.price,
    this.insuranceType,
    this.validityDays,
    this.coverageAmount,
    this.description,
  });

  final String id;
  final String name;
  final double price;
  final String? insuranceType;
  final int? validityDays;
  final double? coverageAmount;
  final String? description;
}
