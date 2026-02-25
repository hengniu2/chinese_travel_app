import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_error.dart';

/// Generic paginated response from catalog APIs
class CatalogPageResponse<T> {
  const CatalogPageResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
}

/// Catalog API: routes, companions, hotels, tickets, insurance (packages are in TourRepository)
class CatalogRepository {
  CatalogRepository(this._dio);

  final Dio _dio;
  String get _prefix => '${AppConstants.apiPathPrefix}/catalog';

  // ─── Routes ─────────────────────────────────────────────────────────────
  Future<CatalogPageResponse<Map<String, dynamic>>> getRoutes({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/routes',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList.whereType<Map<String, dynamic>>().toList();
      final total = (data['total'] as num?)?.toInt() ?? 0;
      return CatalogPageResponse(
        items: items,
        total: total,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<Map<String, dynamic>> getRoute(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/routes/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return data;
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  // ─── Companions ─────────────────────────────────────────────────────────
  Future<CatalogPageResponse<Map<String, dynamic>>> getCompanions({
    int page = 1,
    int pageSize = 20,
    List<String>? skills,
    List<String>? languages,
    List<String>? interests,
    String? location,
    double? minRate,
    double? maxRate,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
        if (location != null && location.isNotEmpty) 'location': location,
        if (minRate != null) 'min_rate': minRate,
        if (maxRate != null) 'max_rate': maxRate,
      };
      if (skills != null && skills.isNotEmpty) query['skills'] = skills;
      if (languages != null && languages.isNotEmpty) query['languages'] = languages;
      if (interests != null && interests.isNotEmpty) query['interests'] = interests;
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/companions',
        queryParameters: query,
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList.whereType<Map<String, dynamic>>().toList();
      final total = (data['total'] as num?)?.toInt() ?? 0;
      return CatalogPageResponse(
        items: items,
        total: total,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<Map<String, dynamic>> getCompanion(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/companions/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return data;
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  /// Companion availability slots (from, to as ISO date strings)
  Future<List<dynamic>> getCompanionAvailability(
    String companionId, {
    String? from,
    String? to,
  }) async {
    try {
      final query = <String, dynamic>{};
      if (from != null) query['from'] = from;
      if (to != null) query['to'] = to;
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/companions/$companionId/availability',
        queryParameters: query.isNotEmpty ? query : null,
      );
      final data = res.data?['data'];
      if (data is List) return data;
      if (data is Map && data['items'] is List) return data['items'] as List;
      return [];
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<CatalogPageResponse<Map<String, dynamic>>> getCompanionReviews(
    String companionId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/companions/$companionId/reviews',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList.whereType<Map<String, dynamic>>().toList();
      final total = (data['total'] as num?)?.toInt() ?? 0;
      return CatalogPageResponse(
        items: items,
        total: total,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<Map<String, dynamic>> getCompanionRating(String companionId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/companions/$companionId/rating',
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) return data;
      return {'average': 0.0, 'count': 0};
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  // ─── Hotels ─────────────────────────────────────────────────────────────
  Future<CatalogPageResponse<Map<String, dynamic>>> getHotels({
    int page = 1,
    int pageSize = 20,
    String? city,
    double? minPrice,
    double? maxPrice,
    int? minStar,
    String? sort,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
        if (city != null && city.isNotEmpty) 'city': city,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minStar != null) 'min_star': minStar,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      };
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/hotels',
        queryParameters: query,
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList.whereType<Map<String, dynamic>>().toList();
      final total = (data['total'] as num?)?.toInt() ?? 0;
      return CatalogPageResponse(
        items: items,
        total: total,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<Map<String, dynamic>> getHotel(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/hotels/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return data;
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  // ─── Tickets (attraction tickets) ───────────────────────────────────────
  Future<CatalogPageResponse<Map<String, dynamic>>> getTickets({
    int page = 1,
    int pageSize = 20,
    String? location,
    double? minPrice,
    double? maxPrice,
    String? ticketType,
    String? sort,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
        if (location != null && location.isNotEmpty) 'location': location,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (ticketType != null && ticketType.isNotEmpty) 'ticket_type': ticketType,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      };
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/tickets',
        queryParameters: query,
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList.whereType<Map<String, dynamic>>().toList();
      final total = (data['total'] as num?)?.toInt() ?? 0;
      return CatalogPageResponse(
        items: items,
        total: total,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<Map<String, dynamic>> getTicket(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/tickets/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return data;
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  // ─── Insurance ──────────────────────────────────────────────────────────
  Future<CatalogPageResponse<Map<String, dynamic>>> getInsuranceList({
    int page = 1,
    int pageSize = 20,
    String? insuranceType,
    double? minPrice,
    double? maxPrice,
    String? sort,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
        if (insuranceType != null && insuranceType.isNotEmpty) 'insurance_type': insuranceType,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      };
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/insurance',
        queryParameters: query,
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList.whereType<Map<String, dynamic>>().toList();
      final total = (data['total'] as num?)?.toInt() ?? 0;
      return CatalogPageResponse(
        items: items,
        total: total,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<Map<String, dynamic>> getInsurance(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/insurance/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return data;
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }
}
