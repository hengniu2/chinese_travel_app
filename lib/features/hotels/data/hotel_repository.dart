import '../domain/hotel.dart';
import '../domain/hotel_item.dart';

/// Result of a paginated hotel list fetch.
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

/// Query params for hotel list: sort, filter, search, pagination.
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

abstract class HotelRepository {
  /// Fetches hotels with sort, filter, search, pagination.
  Future<HotelListResult> getHotels(HotelListQuery query);

  /// Fetches a single hotel by id (for detail).
  Future<Hotel?> getHotelById(String id);

  /// Simulates room availability for given dates (for detail page).
  Future<bool> getRoomAvailability(String hotelId, String roomId, DateTime checkIn, DateTime checkOut);
}
