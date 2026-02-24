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
  final double? rating;
  final int? reviewCount;
  final bool isVerified;
  final String? responseHint;
  final int? experienceYears;
  final int? completedOrders;
  final bool isOnline;
  final List<String>? languages;
  final String? responseTime;
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
