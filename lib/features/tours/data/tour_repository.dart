import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_error.dart';
import '../domain/tour_detail.dart';
import '../domain/tour_item.dart';

/// 列表响应
class TourListResponse {
  const TourListResponse({required this.items, required this.total, this.page = 1, this.pageSize = 20});
  final List<TourItem> items;
  final int total;
  final int page;
  final int pageSize;
}

/// 旅行团数据仓库（对接 /api/catalog/packages）
class TourRepository {
  TourRepository(this._dio);

  final Dio _dio;

  String get _prefix => '${AppConstants.apiPathPrefix}/catalog';

  /// 列表（支持分页与筛选）
  Future<TourListResponse> getList({
    int page = 1,
    int pageSize = 20,
    double? minPrice,
    double? maxPrice,
    int? minDays,
    int? maxDays,
    String? region,
    String? sort,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (minDays != null) 'min_days': minDays,
        if (maxDays != null) 'max_days': maxDays,
        if (region != null && region.isNotEmpty) 'region': region,
        if (sort != null && sort.isNotEmpty) 'sort': sort,
      };
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/packages',
        queryParameters: query,
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final total = (data['total'] as num?)?.toInt() ?? 0;
      final p = (data['page'] as num?)?.toInt() ?? 1;
      final ps = (data['pageSize'] as num?)?.toInt() ?? 20;
      final items = itemsList
          .whereType<Map<String, dynamic>>()
          .map(_packageToTourItem)
          .toList();
      return TourListResponse(items: items, total: total, page: p, pageSize: ps);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  /// 详情
  Future<TourDetail> getDetail(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/packages/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return _packageToTourDetail(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  static TourItem _packageToTourItem(Map<String, dynamic> p) {
    final id = p['_id']?.toString() ?? '';
    final name = _preferChineseText(
      p['name'] as String?,
      fallback: '精选旅行套餐',
    );
    final description = _preferChineseText(
      p['description'] as String?,
      fallback: '官方精选路线，安心出行',
    );
    final price = (p['price'] as num?)?.toDouble() ?? 0;
    final days = (p['duration_days'] as num?)?.toInt() ?? 0;
    final route = p['route_id'];
    String? imageUrl;
    String? region;
    if (route is Map<String, dynamic>) {
      imageUrl = route['cover_image'] as String?;
      region = _preferChineseText(
        route['region'] as String?,
        fallback: '国内',
      );
    }
    return TourItem(
      id: id,
      title: name,
      subtitle: description,
      city: region ?? '',
      price: price.toDouble(),
      days: days,
      departureDate: DateTime.now().add(const Duration(days: 30)),
      type: '跟团游',
      imageUrl: imageUrl,
      tags: [],
    );
  }

  static TourDetail _packageToTourDetail(Map<String, dynamic> p) {
    final id = p['_id']?.toString() ?? '';
    final name = _preferChineseText(
      p['name'] as String?,
      fallback: '精选旅行套餐',
    );
    final description = _preferChineseText(
      p['description'] as String?,
      fallback: '官方精选路线，安心出行',
    );
    final price = (p['price'] as num?)?.toDouble() ?? 0;
    final days = (p['duration_days'] as num?)?.toInt() ?? 0;
    final route = p['route_id'] as Map<String, dynamic>?;
    String? imageUrl;
    String? region;
    if (route != null) {
      imageUrl = route['cover_image'] as String?;
      region = _preferChineseText(
        route['region'] as String?,
        fallback: '国内',
      );
    }
    return TourDetail(
      id: id,
      title: name,
      subtitle: description,
      city: region ?? '',
      price: price.toDouble(),
      days: days,
      departureDate: DateTime.now().add(const Duration(days: 30)),
      type: '跟团游',
      itinerary: [],
      highlights: description.isNotEmpty ? [description] : [],
      costIncluded: [],
      costExcluded: [],
      hotels: [],
      refundPolicy: '请以订单及合同为准。',
      reviews: [],
      imageUrl: imageUrl,
    );
  }

  /// Prefer Chinese display text in UI.
  /// If backend text is English-only, use localized Chinese fallback.
  static String _preferChineseText(String? value, {required String fallback}) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return fallback;
    final hasChinese = RegExp(r'[\u4e00-\u9fff]').hasMatch(text);
    final hasLatin = RegExp(r'[A-Za-z]').hasMatch(text);
    if (!hasChinese && hasLatin) return fallback;
    return text;
  }
}
