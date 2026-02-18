import '../domain/hotel_item.dart';

List<HotelItem> getHotelList(HotelFilters filters) {
  final raw = _mockHotels;
  var list = raw.where((h) {
    if (filters.star != null && h.star != filters.star) return false;
    if (filters.priceMin != null && h.price < filters.priceMin!) return false;
    if (filters.priceMax != null && h.price > filters.priceMax!) return false;
    return true;
  }).toList();

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

final List<HotelItem> _mockHotels = [
  const HotelItem(
    id: '1',
    name: '丽江古城悦榕庄',
    star: 5,
    price: 2680,
    address: '古城区束河街道',
    score: 4.9,
    tags: ['温泉', '接站'],
  ),
  const HotelItem(
    id: '2',
    name: '泸沽湖里格半岛酒店',
    star: 4,
    price: 680,
    address: '宁蒗县泸沽湖里格村',
    score: 4.7,
    tags: ['湖景', '早餐'],
  ),
  const HotelItem(
    id: '3',
    name: '三亚亚龙湾万豪度假酒店',
    star: 5,
    price: 1280,
    address: '亚龙湾国家旅游度假区',
    score: 4.8,
    tags: ['海景', '亲子'],
  ),
  const HotelItem(
    id: '4',
    name: '西双版纳告庄西双景客栈',
    star: 3,
    price: 320,
    address: '景洪市告庄西双景',
    score: 4.5,
    tags: ['傣式', '夜市'],
  ),
  const HotelItem(
    id: '5',
    name: '喀什古城民宿',
    star: 3,
    price: 280,
    address: '喀什市吾斯塘博依路',
    score: 4.6,
    tags: ['民族风', '含早'],
  ),
  const HotelItem(
    id: '6',
    name: '大理洱海海景酒店',
    star: 4,
    price: 520,
    address: '大理市海东镇',
    score: 4.7,
    tags: ['洱海', '拍照'],
  ),
  const HotelItem(
    id: '7',
    name: '桂林阳朔西街精品酒店',
    star: 4,
    price: 380,
    address: '阳朔县西街',
    score: 4.4,
    tags: ['西街', '漓江'],
  ),
  const HotelItem(
    id: '8',
    name: '杭州西湖国宾馆',
    star: 5,
    price: 1880,
    address: '西湖区杨公堤',
    score: 4.9,
    tags: ['西湖', '园林'],
  ),
  const HotelItem(
    id: '9',
    name: '成都宽窄巷子客栈',
    star: 3,
    price: 260,
    address: '青羊区宽窄巷子',
    score: 4.3,
    tags: ['老成都', '美食'],
  ),
  const HotelItem(
    id: '10',
    name: '西安大雁塔亚朵酒店',
    star: 4,
    price: 420,
    address: '雁塔区大雁塔北广场',
    score: 4.6,
    tags: ['阅读', '地铁'],
  ),
];
