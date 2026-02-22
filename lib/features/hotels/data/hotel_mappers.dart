import '../domain/hotel.dart';
import '../domain/hotel_detail.dart';
import '../domain/hotel_item.dart';

/// Maps canonical Hotel to list-item DTO.
HotelItem hotelToItem(Hotel h) {
  HotelTagBadge? badge;
  if (h.tagBadge != null) {
    switch (h.tagBadge!) {
      case '舒适':
        badge = HotelTagBadge.comfort;
        break;
      case '高端':
        badge = HotelTagBadge.premium;
        break;
      case '热门':
        badge = HotelTagBadge.hot;
        break;
      default:
        badge = null;
    }
  }
  return HotelItem(
    id: h.id,
    name: h.name,
    star: h.star ?? 4,
    price: h.price,
    imageUrl: h.images.isNotEmpty ? h.images.first : null,
    address: h.location.isNotEmpty ? h.location : null,
    tags: h.tags,
    score: h.rating,
    tagBadge: badge,
    features: h.facilities,
    discountAmount: h.discountAmount,
    latitude: h.latitude,
    longitude: h.longitude,
  );
}

/// Maps canonical Hotel to detail DTO (with Room -> RoomType).
HotelDetail hotelToDetail(Hotel h) {
  return HotelDetail(
    id: h.id,
    name: h.name,
    star: h.star ?? 4,
    address: h.location,
    imageUrls: h.images,
    score: h.rating,
    tags: h.tags,
    tagBadge: h.tagBadge,
    rooms: h.rooms.map(roomToType).toList(),
    cancellationPolicy: '入住前1天18:00前免费取消；逾期取消按政策收取费用。',
    policyCheckInOut: '入住时间: 12:00以后 · 离店时间: 14:00以前',
    policyReception: '接待来自任何国家/地区的客人',
    facilities: h.facilities,
    reviews: [],
  );
}

RoomType roomToType(Room r) {
  final featuresSummary = [
    if (r.size != null) r.size,
    if (r.bedType != null) r.bedType,
    '可住${r.capacity}人',
  ].join(' | ');
  final pricePlans = <RoomPricePlan>[
    if (r.breakfastIncluded)
      RoomPricePlan(label: '含早', price: r.price)
    else
      RoomPricePlan(label: '无早餐', price: r.price * 0.92),
    RoomPricePlan(label: r.isRefundable ? '限时免费取消' : '不可取消', price: r.isRefundable ? r.price : r.price * 0.88),
  ];
  return RoomType(
    id: r.id,
    name: r.name,
    price: r.price,
    stockStatus: RoomStockStatus.available,
    bedInfo: r.bedType,
    area: r.size,
    breakfast: r.breakfastIncluded ? '含早' : null,
    imageUrl: r.imageUrl,
    featuresSummary: featuresSummary,
    pricePlans: pricePlans,
  );
}
