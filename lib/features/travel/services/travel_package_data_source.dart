import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/models.dart';

/// Data source for travel packages (mock or API). Used by repository.
abstract class TravelPackageDataSource {
  Future<List<TravelPackage>> getPackages();
  Future<TravelPackage?> getPackageById(String id);
}

class MockTravelPackageDataSource implements TravelPackageDataSource {
  @override
  Future<List<TravelPackage>> getPackages() async {
    return _mockPackages;
  }

  @override
  Future<TravelPackage?> getPackageById(String id) async {
    try {
      return _mockPackages.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

List<TravelPackage> get _mockPackages => [
      TravelPackage(
        id: '1',
        title: '江南水乡经典线',
        subtitle: '苏州杭州乌镇5日',
        heroImages: [
          'https://picsum.photos/seed/jiangnan1/800/500',
          'https://picsum.photos/seed/jiangnan2/800/500',
          'https://picsum.photos/seed/jiangnan3/800/500',
        ],
        departureCity: '上海',
        destinations: ['苏州', '杭州', '乌镇'],
        durationDays: 5,
        durationNights: 4,
        price: 3280,
        originalPrice: 3680,
        tags: ['热卖', '品质团'],
        themes: ['文化', '古镇'],
        groupSize: '2-8人',
        rating: 4.8,
        reviewsCount: 128,
        itinerary: [
          const ItineraryDay(
            dayNumber: 1,
            title: '上海-苏州',
            description:
                '早上从上海出发，乘高铁至苏州。下午游览中国四大名园之一的拙政园，赏江南园林精华，小桥流水，一步一景。傍晚入住苏州酒店，可自行逛平江路。',
            highlights: ['拙政园', '平江路'],
            images: ['https://picsum.photos/seed/suzhou1/600/400'],
            mealsIncluded: '晚餐',
            hotelInfo: '苏州城区四星酒店（含早）',
          ),
          const ItineraryDay(
            dayNumber: 2,
            title: '苏州-乌镇',
            description:
                '上午游览虎丘，下午乘车前往乌镇西栅。漫步水乡古街，体验摇橹船，夜宿乌镇景区内客栈，感受枕水人家的宁静。',
            highlights: ['虎丘', '乌镇西栅'],
            images: ['https://picsum.photos/seed/wuzhen1/600/400'],
            mealsIncluded: '早、中、晚餐',
            hotelInfo: '乌镇西栅景区内精品客栈',
          ),
          const ItineraryDay(
            dayNumber: 3,
            title: '乌镇-杭州',
            description:
                '早餐后前往杭州，游览西湖十景之断桥、白堤、苏堤，下午自由活动可选灵隐寺或河坊街。',
            highlights: ['西湖', '断桥', '苏堤'],
            images: ['https://picsum.photos/seed/hangzhou1/600/400'],
            mealsIncluded: '早、午餐',
            hotelInfo: '杭州西湖边四星酒店',
          ),
          const ItineraryDay(
            dayNumber: 4,
            title: '杭州深度',
            description:
                '全天杭州：上午龙井问茶或九溪烟树，下午宋城演艺（可选）或西湖泛舟，晚上可自费观看《最忆是杭州》演出。',
            highlights: ['龙井', '九溪'],
            images: ['https://picsum.photos/seed/hangzhou2/600/400'],
            mealsIncluded: '早、晚餐',
            hotelInfo: '杭州西湖边四星酒店',
          ),
          const ItineraryDay(
            dayNumber: 5,
            title: '杭州-返程',
            description: '早餐后自由活动，根据返程交通时间送站，结束行程。',
            highlights: [],
            images: [],
            mealsIncluded: '早餐',
            hotelInfo: '—',
          ),
        ],
        costBreakdown: const CostBreakdown(
          included: [
            '4晚住宿（双人标准间）',
            '行程所列正餐（见每日说明）',
            '所列景点首道大门票',
            '当地用车及导游',
            '旅游意外险',
          ],
          excluded: [
            '往返出发地大交通',
            '单房差（约¥480/人）',
            '行程外个人消费',
            '景区内小交通及自费项目',
          ],
          optionalAddOns: [
            '单房差 ¥480',
            '杭州《最忆是杭州》演出 ¥298',
            '灵隐寺门票+讲解 ¥75',
          ],
        ),
        policies: '出发前7天可免费取消。',
        faq: [
          const FaqItem(question: '成团人数？', answer: '2人起订，8人封顶。'),
        ],
        visaInfo: '国内行程，持有效身份证即可。外籍人士请持有效签证及居留许可。',
        insuranceInfo:
            '已含旅行社责任险及旅游意外险（具体保额以保单为准）。建议根据自身需要另行购买个人旅游意外险。',
        cancellationPolicy:
            '出发前7天（含）以上取消，全额退款；3–7天取消，扣10%团费；1–3天取消，扣30%；出发当日或行程中退出，恕不退款。',
        importantNotes:
            '行程顺序可能根据天气、交通等调整，景点不变。儿童价适用于1.2米以下、不占床；1.2米以上按成人价。',
        reviews: const [
          PackageReview(
            authorName: '张女士',
            rating: 5,
            content: '行程安排很舒服，导游讲解到位，乌镇夜景特别美，值得推荐。',
            date: '2024-01-15',
          ),
          PackageReview(
            authorName: '李先生',
            rating: 4.5,
            content: '江南水乡一次看够，住宿和餐食都不错，唯一就是西湖那天人有点多。',
            date: '2024-01-08',
          ),
          PackageReview(
            authorName: '王女士',
            rating: 5,
            content: '带爸妈去的，他们非常满意。节奏适中，不赶，品质团体验好。',
            date: '2024-01-02',
          ),
        ],
        bookingsLast7Days: 23,
        remainingCapacity: 4,
        verifiedLocalPartner: true,
      ),
      TravelPackage(
        id: '2',
        title: '北京文化深度游',
        subtitle: '故宫长城颐和园4日',
        heroImages: [
          'https://picsum.photos/seed/beijing1/800/500',
          'https://picsum.photos/seed/beijing2/800/500',
        ],
        departureCity: '北京',
        destinations: ['北京'],
        durationDays: 4,
        durationNights: 3,
        price: 2580,
        originalPrice: 2880,
        tags: ['热门'],
        themes: ['文化', '历史'],
        groupSize: '2-6人',
        rating: 4.9,
        reviewsCount: 96,
        itinerary: const [],
        costBreakdown: const CostBreakdown(
          included: ['住宿', '部分餐饮', '门票', '用车'],
          excluded: ['大交通', '个人消费'],
          optionalAddOns: ['单房差'],
        ),
        policies: '出发前5天可免费取消。',
        faq: const [],
        visaInfo: '国内行程，持有效身份证即可。',
        insuranceInfo: '已含旅行社责任险及旅游意外险。',
        cancellationPolicy: '出发前5天以上取消全额退款；3–5天扣10%；1–3天扣30%。',
        importantNotes: '故宫需实名预约，请提前配合提供证件信息。',
        reviews: const [
          PackageReview(
            authorName: '刘先生',
            rating: 5,
            content: '故宫和长城都去了，讲解专业，不虚此行。',
            date: '2024-01-10',
          ),
        ],
        bookingsLast7Days: 12,
        remainingCapacity: 8,
        verifiedLocalPartner: true,
      ),
      TravelPackage(
        id: '3',
        title: '云南自然风光',
        subtitle: '丽江大理香格里拉6日',
        heroImages: [
          'https://picsum.photos/seed/yunnan1/800/500',
          'https://picsum.photos/seed/yunnan2/800/500',
          'https://picsum.photos/seed/yunnan3/800/500',
        ],
        departureCity: '昆明',
        destinations: ['丽江', '大理', '香格里拉'],
        durationDays: 6,
        durationNights: 5,
        price: 4580,
        originalPrice: 4980,
        tags: ['品质团'],
        themes: ['自然', '摄影'],
        groupSize: '4-12人',
        rating: 4.7,
        reviewsCount: 204,
        itinerary: const [],
        costBreakdown: const CostBreakdown(
          included: ['住宿', '部分餐饮', '门票', '用车', '导游'],
          excluded: ['往返机票', '个人消费'],
          optionalAddOns: ['单房差', '氧气瓶'],
        ),
        policies: null,
        faq: const [],
        visaInfo: '国内行程，持有效身份证即可。',
        insuranceInfo: '已含旅行社责任险及旅游意外险。高原行程请确认身体状况。',
        cancellationPolicy: '出发前7天可免费取消；3–7天扣10%；1–3天扣30%。',
        importantNotes: '香格里拉海拔较高，建议备防高反药物；早晚温差大，注意保暖。',
        reviews: const [],
        bookingsLast7Days: 31,
        remainingCapacity: null,
        verifiedLocalPartner: true,
      ),
    ];

final travelPackageDataSourceProvider =
    Provider<TravelPackageDataSource>((ref) {
  return MockTravelPackageDataSource();
});
