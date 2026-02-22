/// 陪游详情（展示用模型）
class CompanionDetail {
  const CompanionDetail({
    required this.id,
    required this.name,
    required this.avatar,
    required this.images,
    required this.age,
    required this.city,
    required this.bio,
    required this.skillTags,
    required this.serviceDesc,
    required this.packages,
    required this.reviews,
    this.rating,
    this.reviewCount,
    this.isVerified = false,
    this.responseHint,
    this.experienceYears,
    this.completedOrders,
    this.isOnline = true,
    this.languages,
    this.responseTime,
    this.acceptRate,
  });

  final String id;
  final String name;
  final String avatar;
  final List<String> images;
  final int age;
  final String city;
  final String bio;
  final List<String> skillTags;
  final String serviceDesc;
  final List<CompanionPackage> packages;
  final List<CompanionReview> reviews;
  /// 展示用评分，null 则从 reviews 计算
  final double? rating;
  /// 展示用评价数，null 则取 reviews.length
  final int? reviewCount;
  final bool isVerified;
  /// 如 "响应很快"、"接单率98%"
  final String? responseHint;
  /// 陪游经验年数，如 3 → "3年陪游经验"
  final int? experienceYears;
  /// 已完成订单数，如 356 → "已服务 356次"
  final int? completedOrders;
  /// 是否在线，用于显示 在线/忙碌
  final bool isOnline;
  /// 语言，如 ["中文", "English"]
  final List<String>? languages;
  /// 平均回复，如 "5分钟内"
  final String? responseTime;
  /// 接单率，如 "98%"
  final String? acceptRate;
}

class CompanionPackage {
  const CompanionPackage({
    required this.name,
    required this.desc,
    required this.price,
    required this.unit,
  });

  final String name;
  final String desc;
  final double price;
  final String unit;
}

class CompanionReview {
  const CompanionReview({
    required this.userName,
    required this.avatar,
    required this.rating,
    required this.content,
    required this.date,
  });

  final String userName;
  final String avatar;
  final double rating;
  final String content;
  final String date;
}
