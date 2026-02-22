import '../domain/hotel_bundle.dart';

/// Returns recommended bundles for a hotel (nearby attractions, tickets, insurance).
List<HotelTicketBundle> getBundlesForHotel(String hotelId) {
  return _bundles
      .where((b) => b.hotelId == hotelId)
      .toList();
}

final List<HotelTicketBundle> _bundles = [
  HotelTicketBundle(
    id: 'b1',
    hotelId: '1',
    ticketId: 't1',
    title: '酒店+丽江古城门票',
    subtitle: '含双人古城维护费',
    originalPrice: 2780,
    bundlePrice: 2580,
    discount: 200,
    addons: [
      BundleAddon(id: 't1', name: '丽江古城门票（双人）', type: BundleAddonType.attraction, originalPrice: 100),
    ],
  ),
  HotelTicketBundle(
    id: 'b2',
    hotelId: '1',
    ticketId: 't2',
    title: '酒店+旅行保障',
    subtitle: '含取消险+意外险',
    originalPrice: 2720,
    bundlePrice: 2690,
    discount: 30,
    addons: [
      BundleAddon(id: 'ins1', name: '取消险', type: BundleAddonType.insurance, originalPrice: 20),
      BundleAddon(id: 'ins2', name: '意外险', type: BundleAddonType.insurance, originalPrice: 20),
    ],
  ),
  HotelTicketBundle(
    id: 'b3',
    hotelId: '2',
    ticketId: 't3',
    title: '酒店+泸沽湖门票',
    subtitle: '含环湖观光',
    originalPrice: 780,
    bundlePrice: 720,
    discount: 60,
    addons: [
      BundleAddon(id: 't3', name: '泸沽湖门票（双人）', type: BundleAddonType.ticket, originalPrice: 140),
    ],
  ),
  HotelTicketBundle(
    id: 'b4',
    hotelId: '3',
    ticketId: 't4',
    title: '酒店+亚龙湾森林公园',
    subtitle: '含往返接送',
    originalPrice: 1580,
    bundlePrice: 1480,
    discount: 100,
    addons: [
      BundleAddon(id: 't4', name: '森林公园门票+车', type: BundleAddonType.attraction, originalPrice: 300),
    ],
  ),
  HotelTicketBundle(
    id: 'b5',
    hotelId: '8',
    ticketId: 't5',
    title: '酒店+西湖游船',
    subtitle: '含双人船票',
    originalPrice: 1980,
    bundlePrice: 1920,
    discount: 60,
    addons: [
      BundleAddon(id: 't5', name: '西湖游船（双人）', type: BundleAddonType.ticket, originalPrice: 100),
    ],
  ),
  // Fallback: show a generic bundle for any hotel without specific data
  HotelTicketBundle(
    id: 'b0',
    hotelId: '0',
    ticketId: 't0',
    title: '酒店+景点联票',
    subtitle: '附近热门景点',
    originalPrice: 500,
    bundlePrice: 450,
    discount: 50,
    addons: [],
  ),
];
