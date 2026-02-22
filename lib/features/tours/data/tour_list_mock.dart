import '../domain/tour_item.dart';

List<TourItem> getTourList([TourFilters? filters]) {
  final raw = _rawTours;
  if (filters == null) return raw;
  return raw.where((t) {
    if (filters.city != null && filters.city!.isNotEmpty && t.city != filters.city) return false;
    if (filters.priceMin != null && t.price < filters.priceMin!) return false;
    if (filters.priceMax != null && t.price > filters.priceMax!) return false;
    if (filters.daysMin != null && t.days < filters.daysMin!) return false;
    if (filters.daysMax != null && t.days > filters.daysMax!) return false;
    if (filters.departureFrom != null && t.departureDate.isBefore(filters.departureFrom!)) return false;
    if (filters.departureTo != null && t.departureDate.isAfter(filters.departureTo!)) return false;
    if (filters.type != null && filters.type!.isNotEmpty && t.type != filters.type) return false;
    return true;
  }).toList();
}

final _rawTours = [
  TourItem(
    id: '1',
    title: '丽江+泸沽湖5天4晚2-8人小包团',
    subtitle: '丽江奇妙之旅',
    city: '丽江市',
    price: 1880,
    days: 5,
    departureDate: DateTime(2025, 3, 15),
    type: '小包团',
    imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
    tags: ['含4晚酒店'],
    hotelNights: 4,
    mealCount: null,
    confirmLabel: null,
  ),
  TourItem(
    id: '2',
    title: '西双版纳+傣族园+野象谷+基诺山雨林徒步5天4晚2-8人小包团',
    subtitle: '西双版纳奇妙之旅',
    city: '西双版纳',
    price: 2180,
    days: 5,
    departureDate: DateTime(2025, 3, 18),
    type: '小包团',
    imageUrl: 'https://images.unsplash.com/photo-1528181304800-259b08848526?w=400',
    tags: ['含4晚酒店', '含3次正餐'],
    hotelNights: 4,
    mealCount: 3,
    confirmLabel: '立即确认',
  ),
  TourItem(
    id: '3',
    title: '丽江+香格里拉5天4晚2-8人小包团',
    subtitle: '丽江奇妙之旅',
    city: '丽江市',
    price: 1780,
    days: 5,
    departureDate: DateTime(2025, 3, 22),
    type: '小包团',
    imageUrl: 'https://images.unsplash.com/photo-1504280390367-361c6d9f38f4?w=400',
    tags: ['含4晚酒店'],
    hotelNights: 4,
    confirmLabel: null,
  ),
  TourItem(
    id: '4',
    title: '丽江6天5晚跟团游',
    subtitle: 'Deepseek说丽江-丽大泸6天(18成人小团)',
    city: '丽江市',
    price: 5299,
    days: 6,
    departureDate: DateTime(2025, 3, 10),
    type: '跟团游',
    imageUrl: 'https://images.unsplash.com/photo-1478131143081-80f7f84ca84d?w=400',
    tags: ['含5晚酒店', '含6次正餐'],
    hotelNights: 5,
    mealCount: 6,
    confirmLabel: '成团保障',
  ),
  TourItem(
    id: '5',
    title: '喀什地区+塔什库尔干7天6晚跟团游',
    subtitle: '多巴胺南疆-蓝冰极幻冬季拼车7日',
    city: '喀什',
    price: 4080,
    days: 7,
    departureDate: DateTime(2025, 3, 20),
    type: '跟团游',
    imageUrl: 'https://images.unsplash.com/photo-1547981609-4b6bfe67ca0b?w=400',
    tags: ['含6晚酒店'],
    hotelNights: 6,
    confirmLabel: '24小时内确认',
  ),
  TourItem(
    id: '6',
    title: '三亚5天4晚自由行',
    subtitle: '海岛度假·酒店任选',
    city: '三亚市',
    price: 2580,
    days: 5,
    departureDate: DateTime(2025, 3, 25),
    type: '自由行',
    imageUrl: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=400',
    tags: ['含4晚酒店'],
    hotelNights: 4,
  ),
];

List<String> get mockCities => ['不限', '丽江市', '西双版纳', '喀什', '三亚市'];
List<String> get mockTypes => ['不限', '跟团游', '小包团', '自由行'];
