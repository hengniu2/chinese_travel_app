import '../domain/tour_detail.dart';

TourDetail getTourDetail(String id) {
  return TourDetail(
    id: id,
    title: '丽江+泸沽湖5天4晚2-8人小包团',
    subtitle: '丽江奇妙之旅',
    city: '丽江市',
    price: 1880,
    days: 5,
    departureDate: DateTime(2025, 3, 15),
    type: '小包团',
    imageUrl: null,
    itinerary: [
      const ItineraryDay(
        day: 1,
        title: '出发地-丽江',
        description: '抵达丽江，专车接站后入住酒店，自由活动。可逛丽江古城、四方街。',
        meals: '晚餐自理',
        hotel: '丽江古城周边酒店',
        attractions: ['丽江古城'],
      ),
      const ItineraryDay(
        day: 2,
        title: '丽江-泸沽湖',
        description: '乘车前往泸沽湖，途经山路观景。抵达后环湖游览，走访摩梭人家。',
        meals: '含早午餐，晚餐自理',
        hotel: '泸沽湖湖畔酒店',
        attractions: ['泸沽湖', '里格半岛'],
      ),
      const ItineraryDay(
        day: 3,
        title: '泸沽湖全天',
        description: '乘猪槽船游湖，登里务比岛。下午可自选参加摩梭篝火晚会。',
        meals: '含早，午晚餐自理',
        hotel: '泸沽湖湖畔酒店',
        attractions: ['里务比岛'],
      ),
      const ItineraryDay(
        day: 4,
        title: '泸沽湖-丽江',
        description: '早餐后返程丽江，途中观景。下午抵达后自由活动。',
        meals: '含早午餐，晚餐自理',
        hotel: '丽江古城周边酒店',
        attractions: null,
      ),
      const ItineraryDay(
        day: 5,
        title: '丽江-出发地',
        description: '根据航班/列车时间送站，结束行程。',
        meals: '含早',
        hotel: null,
        attractions: null,
      ),
    ],
    highlights: [
      '2-8人小团，专车专导，节奏自由',
      '泸沽湖环湖+猪槽船体验，深度接触摩梭文化',
      '含4晚酒店，品质住宿',
      '丽江古城+泸沽湖经典联线，一次玩遍',
    ],
    costIncluded: [
      const CostItem(
        category: '交通',
        items: ['全程用车', '丽江-泸沽湖往返', '送机/送站'],
      ),
      const CostItem(
        category: '住宿',
        items: ['4晚酒店双人标准间'],
      ),
      const CostItem(
        category: '门票',
        items: ['泸沽湖大门票', '猪槽船游湖'],
      ),
      const CostItem(
        category: '餐食',
        items: ['部分早餐、午餐见行程'],
      ),
    ],
    costExcluded: [
      const CostItem(
        category: '交通',
        items: ['出发地至丽江大交通'],
      ),
      const CostItem(
        category: '餐食',
        items: ['行程标注自理的餐食'],
      ),
      const CostItem(
        category: '其他',
        items: ['个人消费', '旅游意外险'],
      ),
    ],
    hotels: [
      const HotelInfo(name: '丽江古城周边酒店', star: 4, roomType: '标准双人间', note: '或同级'),
      const HotelInfo(name: '泸沽湖湖畔酒店', star: 4, roomType: '湖景房', note: '2晚'),
    ],
    refundPolicy: '出发前7天以上取消，退还除已发生费用外的全款；出发前3-7天取消，扣除30%费用；出发前1-3天取消，扣除50%费用；出发当日或未参团，不予退款。具体以产品页及合同为准。',
    reviews: [
      const TourReview(
        userName: '旅行者A',
        rating: 5,
        content: '小团体验很好，司机兼导游很负责，泸沽湖景色绝美，值得推荐！',
        date: '2025-01-20',
      ),
      const TourReview(
        userName: '旅行者B',
        rating: 5,
        content: '行程安排合理，不赶路，住宿干净。',
        date: '2025-01-15',
      ),
    ],
  );
}
