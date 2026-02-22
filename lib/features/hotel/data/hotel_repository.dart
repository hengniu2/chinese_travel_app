import 'hotel_model.dart';

/// Abstract hotel data source — swap with real API implementation later.
abstract class HotelRepository {
  /// Fetches hotels with sort, filter, search, pagination.
  Future<HotelListResult> getHotels(HotelListQuery query);

  /// Fetches a single hotel by id (for detail).
  Future<Hotel?> getHotelById(String id);

  /// Room availability for given dates (for detail/booking).
  Future<bool> getRoomAvailability(
    String hotelId,
    String roomId,
    DateTime checkIn,
    DateTime checkOut,
  );
}
