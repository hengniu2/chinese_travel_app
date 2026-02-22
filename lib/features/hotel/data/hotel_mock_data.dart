import 'hotel_mappers.dart';
import 'hotel_model.dart';
import 'hotel_repository_mock.dart';

/// Synchronous mock list for home/carousel — uses same data as [HotelRepositoryMock].
List<HotelItem> getHotelListForDisplay(HotelFilters filters) {
  final hotels = HotelRepositoryMock.hotelsForDisplay;
  var list = hotels.map(hotelToItem).toList();

  if (filters.star != null) {
    list = list.where((h) => h.star == filters.star).toList();
  }
  if (filters.priceMin != null) {
    list = list.where((h) => h.price >= filters.priceMin!).toList();
  }
  if (filters.priceMax != null) {
    list = list.where((h) => h.price <= filters.priceMax!).toList();
  }

  switch (filters.sort) {
    case HotelSort.priceAsc:
      list.sort((a, b) => a.price.compareTo(b.price));
      break;
    case HotelSort.priceDesc:
      list.sort((a, b) => b.price.compareTo(a.price));
      break;
    case HotelSort.scoreDesc:
      list.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
      break;
    case HotelSort.starDesc:
      list.sort((a, b) => b.star.compareTo(a.star));
      break;
    case HotelSort.default_:
      break;
  }
  return list;
}

/// Sync hotel detail for order page. Prefer [HotelRepository.getHotelById] + [hotelToDetail] for UI.
HotelDetail? getHotelDetailForOrder(String id) {
  final h = HotelRepositoryMock.getHotelByIdSync(id);
  return h != null ? hotelToDetail(h) : null;
}
