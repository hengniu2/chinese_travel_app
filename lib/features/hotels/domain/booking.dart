/// Booking status flow: Pending → Paid → Confirmed → Completed; or Cancelled; Refunded.
enum BookingStatus {
  pending,
  paid,
  confirmed,
  completed,
  cancelled,
  refunded,
}

/// Guest info for hotel booking (name, phone, ID number, special request).
class HotelBookingGuest {
  const HotelBookingGuest({
    this.name = '',
    this.phone = '',
    this.idNumber = '',
    this.specialRequest = '',
  });

  final String name;
  final String phone;
  final String idNumber;
  final String specialRequest;

  HotelBookingGuest copyWith({
    String? name,
    String? phone,
    String? idNumber,
    String? specialRequest,
  }) {
    return HotelBookingGuest(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      idNumber: idNumber ?? this.idNumber,
      specialRequest: specialRequest ?? this.specialRequest,
    );
  }
}

/// Hotel booking: id, hotelId, roomId, checkIn, checkOut, guests, price, coupon, status.
class HotelBooking {
  const HotelBooking({
    required this.id,
    required this.hotelId,
    required this.roomId,
    required this.roomName,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.roomPrice,
    this.serviceFee = 0,
    this.couponDiscount = 0,
    this.couponId,
    this.status = BookingStatus.pending,
    this.paymentMethod,
    this.createdAt,
  });

  final String id;
  final String hotelId;
  final String roomId;
  final String roomName;
  final String hotelName;
  final DateTime checkIn;
  final DateTime checkOut;
  final List<HotelBookingGuest> guests;
  final double roomPrice;
  final double serviceFee;
  final double couponDiscount;
  final String? couponId;
  final BookingStatus status;
  final String? paymentMethod;
  final DateTime? createdAt;

  double get totalPayable =>
      (roomPrice + serviceFee - couponDiscount).clamp(0.0, double.infinity);
}
