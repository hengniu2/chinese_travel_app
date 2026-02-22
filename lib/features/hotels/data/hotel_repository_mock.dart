import 'dart:math';

import '../domain/hotel.dart';
import '../domain/hotel_item.dart';
import 'hotel_repository.dart';

/// Mock implementation: in-memory list, simulated delay, optional errors.
class HotelRepositoryMock implements HotelRepository {
  HotelRepositoryMock({this.simulateNoInternet = false, this.simulateApiError = false});

  final bool simulateNoInternet;
  final bool simulateApiError;

  static final List<Hotel> _hotels = _buildMockHotels();
  static final Random _random = Random();

  @override
  Future<HotelListResult> getHotels(HotelListQuery query) async {
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(400)));
    if (simulateNoInternet) {
      return HotelListResult(hotels: [], hasMore: false, error: HotelListError.noInternet);
    }
    if (simulateApiError) {
      return HotelListResult(hotels: [], hasMore: false, error: HotelListError.apiError);
    }

    var list = List<Hotel>.from(_hotels);

    // Search keyword filter
    if (query.searchKeyword != null && query.searchKeyword!.trim().isNotEmpty) {
      final k = query.searchKeyword!.trim().toLowerCase();
      list = list.where((h) {
        return h.name.toLowerCase().contains(k) ||
            h.location.toLowerCase().contains(k) ||
            h.tags.any((t) => t.toLowerCase().contains(k));
      }).toList();
    }

    // Price range
    if (query.priceMin != null) list = list.where((h) => h.price >= query.priceMin!).toList();
    if (query.priceMax != null) list = list.where((h) => h.price <= query.priceMax!).toList();
    if (query.star != null) list = list.where((h) => h.star == query.star).toList();

    // Sort
    switch (query.sort) {
      case HotelSort.priceAsc:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case HotelSort.priceDesc:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case HotelSort.scoreDesc:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case HotelSort.starDesc:
        list.sort((a, b) => (b.star ?? 0).compareTo(a.star ?? 0));
        break;
      case HotelSort.default_:
        break;
    }

    final start = (query.page - 1) * query.limit;
    final end = (start + query.limit).clamp(0, list.length);
    final page = list.sublist(start, end);
    final hasMore = end < list.length;

    return HotelListResult(hotels: page, hasMore: hasMore);
  }

  @override
  Future<Hotel?> getHotelById(String id) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(200)));
    if (simulateNoInternet || simulateApiError) return null;
    try {
      return _hotels.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> getRoomAvailability(String hotelId, String roomId, DateTime checkIn, DateTime checkOut) async {
    await Future.delayed(const Duration(milliseconds: 150));
    if (simulateNoInternet || simulateApiError) return false;
    // Simulate: 80% available; or make sold out on certain weekdays for demo
    final day = checkIn.weekday;
    if (day == DateTime.saturday || day == DateTime.sunday) {
      return _random.nextDouble() > 0.3; // 70% available on weekend
    }
    return _random.nextDouble() > 0.1; // 90% on weekday
  }

  static List<Hotel> _buildMockHotels() {
    return [
      Hotel(
        id: '1',
        name: '丽江古城悦榕庄',
        rating: 4.9,
        price: 2680,
        star: 5,
        tagBadge: '高端',
        discountAmount: 200,
        images: [
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800',
          'https://images.unsplash.com/photo-1578681994506-b8f463449011?w=800',
        ],
        tags: ['温泉', '接站', '亲子'],
        location: '云南省丽江市古城区束河街道悦榕路',
        facilities: ['免费WiFi', '停车场', '游泳池', '温泉', '健身房', '餐厅', '酒吧', '接站服务', '行李寄存', '24小时前台'],
        rooms: [
          Room(id: 'r1', name: '花园别墅', size: '88㎡', bedType: '1张大床', capacity: 2, price: 2680, cancellationPolicy: '入住前1天18:00前免费取消', breakfastIncluded: true, isRefundable: true),
          Room(id: 'r2', name: '泳池别墅', size: '120㎡', bedType: '1张大床', capacity: 2, price: 3680, cancellationPolicy: '限时免费取消', breakfastIncluded: true, isRefundable: true),
          Room(id: 'r3', name: '双床景观房', size: '45㎡', bedType: '2张单人床', capacity: 2, price: 1880, cancellationPolicy: '不可取消', breakfastIncluded: true, isRefundable: false),
        ],
        latitude: 39.908,
        longitude: 116.397,
      ),
      Hotel(
        id: '2',
        name: '泸沽湖里格半岛酒店',
        rating: 4.7,
        price: 680,
        star: 4,
        tagBadge: '热门',
        discountAmount: 50,
        images: [
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800',
          'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
        ],
        tags: ['湖景', '早餐'],
        location: '云南省丽江市宁蒗县泸沽湖里格村',
        facilities: ['免费WiFi', '停车场', '餐厅', '观景台', '行李寄存'],
        rooms: [
          Room(id: 'r1', name: '湖景大床房', size: '35㎡', bedType: '1张大床', capacity: 2, price: 680, cancellationPolicy: '限时免费取消', breakfastIncluded: true, isRefundable: true),
          Room(id: 'r2', name: '湖景家庭房', size: '50㎡', bedType: '1大1小床', capacity: 3, price: 980, cancellationPolicy: '限时免费取消', breakfastIncluded: true, isRefundable: true),
        ],
        latitude: 39.918,
        longitude: 116.405,
      ),
      Hotel(
        id: '3',
        name: '三亚亚龙湾万豪度假酒店',
        rating: 4.8,
        price: 1280,
        star: 5,
        tagBadge: '高端',
        images: ['https://images.unsplash.com/photo-1578681994506-b8f463449011?w=800'],
        tags: ['海景', '亲子'],
        location: '亚龙湾国家旅游度假区',
        facilities: ['免费WiFi', '停车场', '早餐', '泳池'],
        rooms: [
          Room(id: 'r1', name: '海景大床房', size: '42㎡', bedType: '1张大床', capacity: 2, price: 1280, cancellationPolicy: '限时免费取消', breakfastIncluded: true, isRefundable: true),
        ],
        latitude: 39.902,
        longitude: 116.410,
      ),
      Hotel(
        id: '4',
        name: '西双版纳告庄西双景客栈',
        rating: 4.5,
        price: 320,
        star: 3,
        tagBadge: '舒适',
        discountAmount: 30,
        images: [],
        tags: ['傣式', '夜市'],
        location: '景洪市告庄西双景',
        facilities: ['免费WiFi', '早餐'],
        rooms: [
          Room(id: 'r1', name: '傣式大床房', size: '28㎡', bedType: '1张大床', capacity: 2, price: 320, cancellationPolicy: '不可取消', breakfastIncluded: true, isRefundable: false),
        ],
        latitude: 39.915,
        longitude: 116.388,
      ),
      Hotel(
        id: '5',
        name: '喀什古城民宿',
        rating: 4.6,
        price: 280,
        star: 3,
        tagBadge: '舒适',
        images: [],
        tags: ['民族风', '含早'],
        location: '喀什市吾斯塘博依路',
        facilities: ['免费WiFi', '早餐'],
        rooms: [
          Room(id: 'r1', name: '标准间', size: '25㎡', bedType: '双床', capacity: 2, price: 280, cancellationPolicy: '限时免费取消', breakfastIncluded: true, isRefundable: true),
        ],
        latitude: 39.472,
        longitude: 75.989,
      ),
      Hotel(
        id: '6',
        name: '大理洱海海景酒店',
        rating: 4.7,
        price: 520,
        star: 4,
        tagBadge: '热门',
        images: [],
        tags: ['洱海', '拍照'],
        location: '大理市海东镇',
        facilities: ['免费WiFi', '停车场', '早餐'],
        rooms: [
          Room(id: 'r1', name: '洱海景观房', size: '38㎡', bedType: '1张大床', capacity: 2, price: 520, cancellationPolicy: '限时免费取消', breakfastIncluded: false, isRefundable: true),
        ],
        latitude: 25.698,
        longitude: 100.162,
      ),
      Hotel(
        id: '7',
        name: '桂林阳朔西街精品酒店',
        rating: 4.4,
        price: 380,
        star: 4,
        tagBadge: '舒适',
        discountAmount: 40,
        images: [],
        tags: ['西街', '漓江'],
        location: '阳朔县西街',
        facilities: ['免费WiFi', '早餐'],
        rooms: [
          Room(id: 'r1', name: '西街观景房', size: '30㎡', bedType: '1张大床', capacity: 2, price: 380, cancellationPolicy: '限时免费取消', breakfastIncluded: true, isRefundable: true),
        ],
        latitude: 39.922,
        longitude: 116.392,
      ),
      Hotel(
        id: '8',
        name: '杭州西湖国宾馆',
        rating: 4.9,
        price: 1880,
        star: 5,
        tagBadge: '高端',
        images: [],
        tags: ['西湖', '园林'],
        location: '西湖区杨公堤',
        facilities: ['免费WiFi', '停车场', '早餐', '园林'],
        rooms: [
          Room(id: 'r1', name: '湖景套房', size: '65㎡', bedType: '1张大床', capacity: 2, price: 1880, cancellationPolicy: '限时免费取消', breakfastIncluded: true, isRefundable: true),
        ],
        latitude: 30.248,
        longitude: 120.132,
      ),
      Hotel(
        id: '9',
        name: '成都宽窄巷子客栈',
        rating: 4.3,
        price: 260,
        star: 3,
        tagBadge: '舒适',
        images: [],
        tags: ['老成都', '美食'],
        location: '青羊区宽窄巷子',
        facilities: ['免费WiFi', '早餐'],
        rooms: [
          Room(id: 'r1', name: '特色大床房', size: '22㎡', bedType: '1张大床', capacity: 2, price: 260, cancellationPolicy: '不可取消', breakfastIncluded: false, isRefundable: false),
        ],
      ),
      Hotel(
        id: '10',
        name: '西安大雁塔亚朵酒店',
        rating: 4.6,
        price: 420,
        star: 4,
        tagBadge: '热门',
        discountAmount: 60,
        images: [],
        tags: ['阅读', '地铁'],
        location: '雁塔区大雁塔北广场',
        facilities: ['免费WiFi', '停车场', '早餐', '阅读'],
        rooms: [
          Room(id: 'r1', name: '高级大床房', size: '32㎡', bedType: '1张大床', capacity: 2, price: 420, cancellationPolicy: '限时免费取消', breakfastIncluded: true, isRefundable: true),
        ],
        latitude: 34.222,
        longitude: 108.956,
      ),
    ];
  }
}
