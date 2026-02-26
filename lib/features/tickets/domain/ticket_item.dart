/// List item for attraction ticket (from catalog API).
class TicketItem {
  const TicketItem({
    required this.id,
    required this.attractionName,
    required this.price,
    this.location,
    this.ticketType,
    this.validityDays,
    this.description,
  });

  final String id;
  final String attractionName;
  final double price;
  final String? location;
  final String? ticketType;
  final int? validityDays;
  final String? description;
}
