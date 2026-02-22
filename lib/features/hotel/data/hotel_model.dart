import 'room_model.dart';

/// Canonical hotel model for list & detail — API-ready.
class Hotel {
  const Hotel({
    required this.id,
    required this.name,
    required this.rating,
    required this.price,
    this.images = const [],
    this.tags = const [],
    this.location = '',
    this.facilities = const [],
    this.rooms = const [],
    this.star,
    this.tagBadge,
    this.discountAmount,
  });

  final String id;
  final String name;
  final double rating;
  final double price;
  final List<String> images;
  final List<String> tags;
  final String location;
  final List<String> facilities;
  final List<Room> rooms;
  final int? star;
  final String? tagBadge;
  final int? discountAmount;
}

/// List item tag: 舒适 / 高端 / 热门
enum HotelTagBadge {
  comfort,
  premium,
  hot,
}

/// List item for hotel list UI.
class HotelItem {
  const HotelItem({
    required this.id,
    required this.name,
    required this.star,
    required this.price,
    this.imageUrl,
    this.address,
    this.tags = const [],
    this.score,
    this.tagBadge,
    this.features = const [],
    this.discountAmount,
  });

  final String id;
  final String name;
  final int star;
  final double price;
  final String? imageUrl;
  final String? address;
  final List<String> tags;
  final double? score;
  final HotelTagBadge? tagBadge;
  final List<String> features;
  final int? discountAmount;
}

/// Sort options for list.
enum HotelSort {
  default_,
  priceAsc,
  priceDesc,
  scoreDesc,
  starDesc,
}

/// Filter state (optional, for UI that uses filters object).
class HotelFilters {
  const HotelFilters({
    this.checkIn,
    this.checkOut,
    this.priceMin,
    this.priceMax,
    this.star,
    this.sort = HotelSort.default_,
  });

  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? priceMin;
  final double? priceMax;
  final int? star;
  final HotelSort sort;

  HotelFilters copyWith({
    DateTime? checkIn,
    DateTime? checkOut,
    double? priceMin,
    double? priceMax,
    int? star,
    HotelSort? sort,
  }) {
    return HotelFilters(
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      star: star ?? this.star,
      sort: sort ?? this.sort,
    );
  }
}

/// Query for repository.getHotels (pagination, sort, filters).
class HotelListQuery {
  const HotelListQuery({
    this.page = 1,
    this.limit = 10,
    this.sort = HotelSort.default_,
    this.priceMin,
    this.priceMax,
    this.star,
    this.searchKeyword,
  });

  final int page;
  final int limit;
  final HotelSort sort;
  final double? priceMin;
  final double? priceMax;
  final int? star;
  final String? searchKeyword;

  HotelListQuery copyWith({
    int? page,
    int? limit,
    HotelSort? sort,
    double? priceMin,
    double? priceMax,
    int? star,
    String? searchKeyword,
  }) {
    return HotelListQuery(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sort: sort ?? this.sort,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      star: star ?? this.star,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }
}

/// Result of getHotels (paginated).
class HotelListResult {
  const HotelListResult({
    required this.hotels,
    required this.hasMore,
    this.error,
  });

  final List<Hotel> hotels;
  final bool hasMore;
  final HotelListError? error;
}

enum HotelListError {
  noInternet,
  apiError,
}

/// Detail DTO for detail page (rooms as RoomType, policies, reviews).
class HotelDetail {
  const HotelDetail({
    required this.id,
    required this.name,
    required this.star,
    required this.address,
    required this.rooms,
    required this.cancellationPolicy,
    required this.facilities,
    required this.reviews,
    this.imageUrl,
    this.imageUrls = const [],
    this.score,
    this.tags = const [],
    this.tagBadge,
    this.policyCheckInOut,
    this.policyReception,
  });

  final String id;
  final String name;
  final int star;
  final String address;
  final String? imageUrl;
  final List<String> imageUrls;
  final double? score;
  final List<String> tags;
  final String? tagBadge;
  final List<RoomType> rooms;
  final String cancellationPolicy;
  final String? policyCheckInOut;
  final String? policyReception;
  final List<String> facilities;
  final List<HotelReview> reviews;
}
