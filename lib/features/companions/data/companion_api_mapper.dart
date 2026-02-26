import '../models/companion_list_item.dart';

/// Map catalog API companion (Map) to CompanionListItem. Backend: display_name, avatar_url, location, service_cities, daily_rate, hourly_rate, experience_years, skills, languages, interests.
CompanionListItem companionListItemFromApi(Map<String, dynamic> json) {
  final id = (json['user_id'] is Map ? (json['user_id'] as Map)['_id'] ?? (json['user_id'] as Map)['id'] : json['user_id'])?.toString() ?? '';
  final name = json['display_name'] as String? ?? '陪游';
  final location = json['location'] as String? ?? '';
  final city = (json['service_cities'] as List?)?.isNotEmpty == true
      ? (json['service_cities'] as List).first.toString()
      : location;
  final dailyRate = (json['daily_rate'] as num?)?.toDouble();
  final hourlyRate = (json['hourly_rate'] as num?)?.toDouble() ?? 0;
  final pricePerDay = dailyRate ?? (hourlyRate * 8);
  final avatarUrl = json['avatar_url'] as String? ?? '';
  final skills = (json['skills'] as List?)?.map((e) => e.toString()).toList() ?? const [];
  final languages = (json['languages'] as List?)?.map((e) => e.toString()).toList() ?? const [];
  final interests = (json['interests'] as List?)?.map((e) => e.toString()).toList() ?? const [];
  final tags = skills.isNotEmpty ? skills : interests;
  return CompanionListItem(
    id: id,
    name: name,
    age: 0,
    city: city,
    experienceYears: (json['experience_years'] as num?)?.toInt() ?? 0,
    rating: 0,
    reviewCount: 0,
    completedOrders: 0,
    pricePerDay: pricePerDay,
    avatarUrl: avatarUrl.isEmpty ? 'https://via.placeholder.com/80' : avatarUrl,
    tags: tags,
    languages: languages.isEmpty ? null : languages,
    isOnline: false,
    isVerified: true,
  );
}
