import '../../catalog/data/catalog_repository.dart';
import '../domain/hotel.dart';
import '../domain/hotel_item.dart';
import 'hotel_repository.dart';

/// Maps catalog API hotel (Map) to canonical [Hotel].
/// Backend: _id, name, description, city, address, star_rating, amenities, price_per_night, image_urls, status.
Hotel hotelFromCatalogApi(Map<String, dynamic> json) {
  final id = (json['_id'] ?? json['id'])?.toString() ?? '';
  final name = json['name'] as String? ?? '酒店';
  final city = json['city'] as String? ?? '';
  final address = json['address'] as String? ?? '';
  final location = address.isNotEmpty ? '$city $address' : city;
  final starRating = (json['star_rating'] as num?)?.toInt();
  final pricePerNight = (json['price_per_night'] as num?)?.toDouble() ?? 0.0;
  final imageUrls = (json['image_urls'] as List<dynamic>?)?.map((e) => e.toString()).where((s) => s.isNotEmpty).toList() ?? [];
  final amenities = (json['amenities'] as List<dynamic>?)?.map((e) => e.toString()).where((s) => s.isNotEmpty).toList() ?? [];
  final room = Room(
    id: '${id}_default',
    name: '标准房',
    size: null,
    bedType: '大床',
    capacity: 2,
    price: pricePerNight,
    cancellationPolicy: '限时免费取消',
    breakfastIncluded: false,
    isRefundable: true,
    imageUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
  );
  return Hotel(
    id: id,
    name: name,
    rating: (starRating != null ? starRating.toDouble() : 4.5),
    price: pricePerNight,
    images: imageUrls,
    tags: [],
    location: location,
    facilities: amenities,
    rooms: [room],
    star: starRating,
    tagBadge: null,
    discountAmount: null,
    latitude: null,
    longitude: null,
  );
}

/// Hotel repository backed by catalog API (GET /api/catalog/hotels, GET /api/catalog/hotels/:id).
class HotelRepositoryCatalog implements HotelRepository {
  HotelRepositoryCatalog(this._catalog);

  final CatalogRepository _catalog;

  @override
  Future<HotelListResult> getHotels(HotelListQuery query) async {
    try {
      final pageSize = query.limit;
      final page = query.page;
      final res = await _catalog.getHotels(
        page: page,
        pageSize: pageSize,
        city: query.searchKeyword?.trim().isEmpty == false ? query.searchKeyword!.trim() : null,
        minPrice: query.priceMin,
        maxPrice: query.priceMax,
        minStar: query.star,
        sort: _sortToCatalog(query.sort),
      );
      final hotels = res.items.map((e) => hotelFromCatalogApi(e)).toList();
      final hasMore = (res.page * res.pageSize) < res.total;
      return HotelListResult(hotels: hotels, hasMore: hasMore);
    } catch (_) {
      return HotelListResult(hotels: [], hasMore: false, error: HotelListError.apiError);
    }
  }

  String? _sortToCatalog(HotelSort sort) {
    switch (sort) {
      case HotelSort.priceAsc:
        return 'price_asc';
      case HotelSort.priceDesc:
        return 'price_desc';
      case HotelSort.scoreDesc:
        return 'score_desc';
      case HotelSort.starDesc:
        return 'star_desc';
      case HotelSort.default_:
        return null;
    }
  }

  @override
  Future<Hotel?> getHotelById(String id) async {
    try {
      final json = await _catalog.getHotel(id);
      return hotelFromCatalogApi(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> getRoomAvailability(String hotelId, String roomId, DateTime checkIn, DateTime checkOut) async {
    return true;
  }
}
