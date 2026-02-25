import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_error.dart';

class ApiItineraryDto {
  const ApiItineraryDto({
    required this.id,
    required this.status,
    this.name,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String status; // DRAFT, CONFIRMED, COMPLETED, CANCELLED
  final String? name;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  static ApiItineraryDto fromJson(Map<String, dynamic> json) {
    return ApiItineraryDto(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      status: json['status'] as String? ?? 'DRAFT',
      name: json['name'] as String?,
      startDate: _parseDate(json['start_date'] ?? json['startDate']),
      endDate: _parseDate(json['end_date'] ?? json['endDate']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }
}

class ItineraryListResponse {
  const ItineraryListResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });
  final List<ApiItineraryDto> items;
  final int total;
  final int page;
  final int pageSize;
}

class ItineraryRepository {
  ItineraryRepository(this._dio);

  final Dio _dio;
  String get _prefix => '${AppConstants.apiPathPrefix}/itineraries';

  Future<ApiItineraryDto> create({
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (startDate != null) body['start_date'] = startDate.toIso8601String();
      if (endDate != null) body['end_date'] = endDate.toIso8601String();
      if (status != null) body['status'] = status;
      final res = await _dio.post<Map<String, dynamic>>('$_prefix/', data: body);
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiItineraryDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ItineraryListResponse> list({int page = 1, int pageSize = 20}) async {
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
          .map(ApiItineraryDto.fromJson)
          .toList();
      return ItineraryListResponse(
        items: items,
        total: (data['total'] as num?)?.toInt() ?? 0,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ApiItineraryDto> get(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiItineraryDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ApiItineraryDto> update(
    String id, {
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (startDate != null) body['start_date'] = startDate.toIso8601String();
      if (endDate != null) body['end_date'] = endDate.toIso8601String();
      if (status != null) body['status'] = status;
      final res = await _dio.patch<Map<String, dynamic>>('$_prefix/$id', data: body);
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiItineraryDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<void> delete(String id) async {
    try {
      await _dio.delete<dynamic>('$_prefix/$id');
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }
}
