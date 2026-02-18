/// 旅行团详情
class TourDetail {
  const TourDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.city,
    required this.price,
    required this.days,
    required this.departureDate,
    required this.type,
    required this.itinerary,
    required this.highlights,
    required this.costIncluded,
    required this.costExcluded,
    required this.hotels,
    required this.refundPolicy,
    required this.reviews,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String city;
  final double price;
  final int days;
  final DateTime departureDate;
  final String type;
  final List<ItineraryDay> itinerary;
  final List<String> highlights;
  final List<CostItem> costIncluded;
  final List<CostItem> costExcluded;
  final List<HotelInfo> hotels;
  final String refundPolicy;
  final List<TourReview> reviews;
  final String? imageUrl;
}

/// 行程某一天
class ItineraryDay {
  const ItineraryDay({
    required this.day,
    required this.title,
    required this.description,
    this.meals,
    this.hotel,
    this.attractions,
  });

  final int day;
  final String title;
  final String description;
  final String? meals;
  final String? hotel;
  final List<String>? attractions;
}

/// 费用项（包含/不含）
class CostItem {
  const CostItem({required this.category, required this.items});
  final String category;
  final List<String> items;
}

/// 酒店信息
class HotelInfo {
  const HotelInfo({
    required this.name,
    this.star,
    this.roomType,
    this.note,
  });

  final String name;
  final int? star;
  final String? roomType;
  final String? note;
}

/// 用户评价
class TourReview {
  const TourReview({
    required this.userName,
    required this.rating,
    required this.content,
    required this.date,
  });

  final String userName;
  final double rating;
  final String content;
  final String date;
}
