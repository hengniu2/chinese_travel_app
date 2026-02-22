/// Type of add-on in a hotel bundle: attraction ticket, ticket, insurance.
enum BundleAddonType {
  attraction,
  ticket,
  insurance,
}

/// Single add-on item in a bundle (e.g. one attraction or insurance product).
class BundleAddon {
  const BundleAddon({
    required this.id,
    required this.name,
    required this.type,
    this.originalPrice,
  });

  final String id;
  final String name;
  final BundleAddonType type;
  final double? originalPrice;
}

/// Hotel + Ticket (or attraction / insurance) bundle for upsell.
/// Shows originalPrice, bundlePrice, discount and "已为您节省 ¥XX".
class HotelTicketBundle {
  const HotelTicketBundle({
    required this.id,
    required this.hotelId,
    required this.ticketId,
    required this.title,
    required this.originalPrice,
    required this.bundlePrice,
    required this.discount,
    this.subtitle,
    this.addons = const [],
  });

  final String id;
  final String hotelId;
  final String ticketId;
  final String title;
  /// Sum of hotel + addon prices before discount.
  final double originalPrice;
  /// Final bundle price.
  final double bundlePrice;
  /// Amount saved (originalPrice - bundlePrice).
  final double discount;
  final String? subtitle;
  final List<BundleAddon> addons;

  /// Savings label: "已为您节省 ¥XX"
  String savingsLabel() => '已为您节省 ¥${discount.toStringAsFixed(0)}';
}
