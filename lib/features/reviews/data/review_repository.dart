import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_error.dart';

/// Review target: COMPANION, MERCHANT, PACKAGE, HOTEL, TICKET
class ApiReviewDto {
  const ApiReviewDto({
    required this.id,
    required this.targetType,
    required this.targetId,
    required this.rating,
    required this.authorId,
    this.orderId,
    this.content = '',
    this.status = 'PENDING',
    this.createdAt,
  });

  final String id;
  final String targetType;
  final String targetId;
  final int rating;
  final String authorId;
  final String? orderId;
  final String content;
  final String status;
  final DateTime? createdAt;

  static ApiReviewDto fromJson(Map<String, dynamic> json) {
    final id = (json['id'] ?? json['_id'])?.toString() ?? '';
    final targetId = json['target_id'];
    final tid = targetId is Map ? (targetId['_id'] ?? targetId['id'])?.toString() : targetId?.toString() ?? '';
    final orderId = json['order_id'];
    final oid = orderId is Map ? (orderId['_id'] ?? orderId['id'])?.toString() : orderId?.toString();
    final authorId = json['author_id'];
    final aid = authorId is Map ? (authorId['_id'] ?? authorId['id'])?.toString() : authorId?.toString() ?? '';
    return ApiReviewDto(
      id: id,
      targetType: json['target_type'] as String? ?? '',
      targetId: tid ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      authorId: aid ?? '',
      orderId: oid,
      content: json['content'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDING',
      createdAt: _parseDate(json['createdAt']),
    );
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    return null;
  }
}

class ReviewListResponse {
  const ReviewListResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });
  final List<ApiReviewDto> items;
  final int total;
  final int page;
  final int pageSize;
}

class ReviewRepository {
  ReviewRepository(this._dio);

  final Dio _dio;
  String get _prefix => '${AppConstants.apiPathPrefix}/reviews';

  Future<ApiReviewDto> create({
    required String targetType,
    required String targetId,
    required int rating,
    String? orderId,
    String? content,
  }) async {
    try {
      final body = <String, dynamic>{
        'target_type': targetType,
        'target_id': targetId,
        'rating': rating,
        if (orderId != null) 'order_id': orderId,
        if (content != null && content.isNotEmpty) 'content': content,
      };
      final res = await _dio.post<Map<String, dynamic>>('$_prefix/', data: body);
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiReviewDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ReviewListResponse> listMy({int page = 1, int pageSize = 20}) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList
          .whereType<Map<String, dynamic>>()
          .map(ApiReviewDto.fromJson)
          .toList();
      return ReviewListResponse(
        items: items,
        total: (data['total'] as num?)?.toInt() ?? 0,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }
}
