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
