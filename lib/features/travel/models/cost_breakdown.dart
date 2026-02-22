/// Cost breakdown for a travel package: included, excluded, optional add-ons.
class CostBreakdown {
  const CostBreakdown({
    this.included = const [],
    this.excluded = const [],
    this.optionalAddOns = const [],
  });

  final List<String> included;
  final List<String> excluded;
  final List<String> optionalAddOns;
}
