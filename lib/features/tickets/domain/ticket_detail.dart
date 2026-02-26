/// Detail model for a single attraction ticket (from catalog API).
class TicketDetail {
  const TicketDetail({
    required this.id,
    required this.attractionName,
    required this.price,
    this.description,
    this.location,
    this.ticketType,
    this.validityDays,
  });

  final String id;
  final String attractionName;
  final double price;
  final String? description;
  final String? location;
  final String? ticketType;
  final int? validityDays;
}
