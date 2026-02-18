import '../domain/hotel_detail.dart';

HotelDetail getHotelDetail(String id) {
  return _mockDetails[id] ?? _mockDetails['1']!;
}

final Map<String, HotelDetail> _mockDetails = {
  '1': const HotelDetail(
    id: '1',
    name: '丽江古城悦榕庄',
    star: 5,
    address: '云南省丽江市古城区束河街道悦榕路',
    score: 4.9,
    tags: ['温泉', '接站', '亲子'],
    rooms: [
      RoomType(
        id: 'r1',
        name: '花园别墅',
        price: 2680,
        stockStatus: RoomStockStatus.available,
        bedInfo: '1张大床',
        area: '88㎡',
        breakfast: '双早',
      ),
      RoomType(
        id: 'r2',
        name: '泳池别墅',
        price: 3680,
        stockStatus: RoomStockStatus.limited,
        bedInfo: '1张大床',
        area: '120㎡',
        remainingCount: 3,
        breakfast: '双早',
      ),
      RoomType(
        id: 'r3',
        name: '双床景观房',
        price: 1880,
        stockStatus: RoomStockStatus.soldOut,
        bedInfo: '2张单人床',
        area: '45㎡',
        breakfast: '双早',
      ),
    ],
    cancellationPolicy: '入住前1天18:00前免费取消；入住前1天18:00至入住当日12:00取消收取首晚房费50%；入住当日12:00后或未入住不予退款。',
    facilities: [
      '免费WiFi',
      '停车场',
      '游泳池',
      '温泉',
      '健身房',
      '餐厅',
      '酒吧',
      '接站服务',
      '行李寄存',
      '24小时前台',
    ],
    reviews: [
      HotelReview(
        userName: '游客A',
        rating: 5,
        content: '环境绝佳，服务贴心，别墅私密性好，温泉很舒服。',
        date: '2025-01-18',
        roomName: '花园别墅',
      ),
      HotelReview(
        userName: '游客B',
        rating: 5,
        content: '带爸妈来度假很满意，早餐丰富，离古城不远。',
        date: '2025-01-12',
        roomName: '泳池别墅',
      ),
      HotelReview(
        userName: '游客C',
        rating: 4,
        content: '设施略旧但整体干净，性价比在悦榕庄里不错。',
        date: '2025-01-05',
      ),
    ],
  ),
  '2': const HotelDetail(
    id: '2',
    name: '泸沽湖里格半岛酒店',
    star: 4,
    address: '云南省丽江市宁蒗县泸沽湖里格村',
    score: 4.7,
    tags: ['湖景', '早餐'],
    rooms: [
      RoomType(
        id: 'r1',
        name: '湖景大床房',
        price: 680,
        stockStatus: RoomStockStatus.available,
        bedInfo: '1张大床',
        area: '35㎡',
        breakfast: '双早',
      ),
      RoomType(
        id: 'r2',
        name: '湖景家庭房',
        price: 980,
        stockStatus: RoomStockStatus.limited,
        bedInfo: '1大1小床',
        area: '50㎡',
        remainingCount: 2,
        breakfast: '三早',
      ),
    ],
    cancellationPolicy: '入住前2天18:00前免费取消；之后取消收取首晚房费。',
    facilities: [
      '免费WiFi',
      '停车场',
      '餐厅',
      '观景台',
      '行李寄存',
    ],
    reviews: [
      HotelReview(
        userName: '旅行者',
        rating: 5,
        content: '推窗即湖，日出太美了，值得住。',
        date: '2025-01-20',
        roomName: '湖景大床房',
      ),
    ],
  ),
};
