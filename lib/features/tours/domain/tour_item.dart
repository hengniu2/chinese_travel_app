/// 旅行团列表项
class TourItem {
  const TourItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.city,
    required this.price,
    required this.days,
    required this.departureDate,
    required this.type,
    this.imageUrl,
    this.tags = const [],
    this.hotelNights,
    this.mealCount,
    this.confirmLabel,
  });

  final String id;
  final String title;
  final String subtitle;
  final String city;
  final double price;
  final int days;
  final DateTime departureDate;
  final String type;
  final String? imageUrl;
  final List<String> tags;
  final int? hotelNights;
  final int? mealCount;
  final String? confirmLabel;
}

/// 筛选条件
class TourFilters {
  const TourFilters({
    this.city,
    this.priceMin,
    this.priceMax,
    this.daysMin,
    this.daysMax,
    this.departureFrom,
    this.departureTo,
    this.type,
  });

  final String? city;
  final double? priceMin;
  final double? priceMax;
  final int? daysMin;
  final int? daysMax;
  final DateTime? departureFrom;
  final DateTime? departureTo;
  final String? type;

  TourFilters copyWith({
    String? city,
    double? priceMin,
    double? priceMax,
    int? daysMin,
    int? daysMax,
    DateTime? departureFrom,
    DateTime? departureTo,
    String? type,
  }) {
    return TourFilters(
      city: city ?? this.city,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      daysMin: daysMin ?? this.daysMin,
      daysMax: daysMax ?? this.daysMax,
      departureFrom: departureFrom ?? this.departureFrom,
      departureTo: departureTo ?? this.departureTo,
      type: type ?? this.type,
    );
  }
}
