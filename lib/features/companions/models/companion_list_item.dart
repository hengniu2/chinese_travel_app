/// 陪游列表项（发现页 / 卡片用）
class CompanionListItem {
  const CompanionListItem({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.completedOrders,
    required this.pricePerDay,
    required this.avatarUrl,
    required this.tags,
    this.languages,
    this.responseTime,
    required this.isOnline,
    required this.isVerified,
  });

  final String id;
  final String name;
  final int age;
  final String city;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int completedOrders;
  final double pricePerDay;
  final String avatarUrl;
  final List<String> tags;
  final List<String>? languages;
  final String? responseTime;
  final bool isOnline;
  final bool isVerified;
}
