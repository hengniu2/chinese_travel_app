import '../models/companion_detail.dart';

/// Maps API responses (profile + rating + reviews + availability) to [CompanionDetail].
/// Backend profile: user_id, display_name, bio, avatar_url, skills, languages, interests,
/// location, service_cities, hourly_rate, daily_rate, experience_years, portfolio_urls.
CompanionDetail companionDetailFromApi({
  required Map<String, dynamic> profile,
  Map<String, dynamic>? rating,
  List<dynamic>? reviewItems,
  List<dynamic>? availabilitySlots,
}) {
  final id = _extractId(profile['user_id']) ?? _extractId(profile['_id']) ?? '';
  final name = profile['display_name'] as String? ?? '陪游';
  final avatar = profile['avatar_url'] as String? ?? '';
  final portfolioUrls = profile['portfolio_urls'] as List<dynamic>? ?? [];
  final images = portfolioUrls
      .map((e) => e.toString().trim())
      .where((s) => s.isNotEmpty)
      .toList();
  final imageList = images.isNotEmpty ? images : (avatar.isNotEmpty ? [avatar] : <String>[]);
  final bio = profile['bio'] as String? ?? '';
  final skills = (profile['skills'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
  final languages = (profile['languages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
  final interests = (profile['interests'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
  final skillTags = skills.isNotEmpty ? skills : interests;
  final location = profile['location'] as String? ?? '';
  final serviceCities = (profile['service_cities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
  final city = serviceCities.isNotEmpty ? serviceCities.first : location;
  final hourlyRate = (profile['hourly_rate'] as num?)?.toDouble() ?? 0;
  final dailyRate = (profile['daily_rate'] as num?)?.toDouble();
  final experienceYears = (profile['experience_years'] as num?)?.toInt() ?? 0;

  final avg = (rating != null ? (rating['average'] as num?)?.toDouble() : null) ?? 0.0;
  final count = (rating != null ? (rating['count'] as num?)?.toInt() : null) ?? 0;

  final reviewList = <CompanionReview>[];
  if (reviewItems != null) {
    for (final r in reviewItems) {
      if (r is! Map<String, dynamic>) continue;
      final authorId = r['author_id'];
      final authorStr = authorId is Map ? (_extractId(authorId) ?? '') : authorId?.toString() ?? '';
      final userName = authorStr.length >= 4 ? '用户${authorStr.substring(authorStr.length - 4)}' : '用户';
      final createdAt = r['createdAt'];
      String dateStr = '';
      if (createdAt != null) {
        if (createdAt is DateTime) dateStr = '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
        else if (createdAt is String) dateStr = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
      }
      reviewList.add(CompanionReview(
        userName: userName,
        avatar: '',
        rating: (r['rating'] as num?)?.toDouble() ?? 0,
        content: r['content'] as String? ?? '',
        date: dateStr,
        hasImage: false,
      ));
    }
  }

  final packages = <CompanionPackage>[];
  if (dailyRate != null && dailyRate > 0) {
    packages.add(CompanionPackage(
      name: '一日陪游（8小时）',
      desc: '含路线规划与讲解',
      price: dailyRate,
      unit: '/人',
    ));
  }
  if (hourlyRate > 0) {
    packages.add(CompanionPackage(
      name: '按小时计费',
      desc: '灵活预约时长',
      price: hourlyRate,
      unit: '/小时',
    ));
  }
  if (packages.isEmpty) {
    packages.add(const CompanionPackage(name: '定制服务', desc: '联系商议', price: 0, unit: '/人'));
  }

  List<CompanionAvailabilitySlot>? slots;
  if (availabilitySlots != null && availabilitySlots.isNotEmpty) {
    slots = [];
    for (final s in availabilitySlots) {
      if (s is! Map<String, dynamic>) continue;
      final dateVal = s['date'];
      DateTime? date;
      if (dateVal is DateTime) date = dateVal;
      else if (dateVal is String) date = DateTime.tryParse(dateVal);
      if (date != null) {
        slots.add(CompanionAvailabilitySlot(
          date: date,
          status: s['status'] as String? ?? 'AVAILABLE',
          slotStart: s['slot_start'] as String?,
          slotEnd: s['slot_end'] as String?,
        ));
      }
    }
  }

  return CompanionDetail(
    id: id,
    name: name,
    avatar: avatar.isEmpty ? 'https://via.placeholder.com/400' : avatar,
    images: imageList,
    age: 0,
    city: city.isEmpty ? '—' : city,
    bio: bio.isEmpty ? '暂无介绍' : bio,
    skillTags: skillTags,
    serviceDesc: bio.isNotEmpty ? '· 根据您的需求定制行程\n· 专业讲解与陪同' : '· 联系陪游了解服务详情',
    packages: packages,
    reviews: reviewList,
    rating: avg,
    reviewCount: count,
    isVerified: true,
    responseHint: '响应及时',
    experienceYears: experienceYears,
    completedOrders: null,
    isOnline: true,
    languages: languages.isEmpty ? null : languages,
    responseTime: null,
    acceptRate: null,
    availabilitySlots: slots,
  );
}

String? _extractId(dynamic v) {
  if (v == null) return null;
  if (v is String) return v;
  if (v is Map) return (v['_id'] ?? v['id'])?.toString();
  return v.toString();
}
