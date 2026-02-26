import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_error.dart';

/// Order list/detail from API (raw-like DTO)
class ApiOrderDto {
  const ApiOrderDto({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    this.items = const [],
    this.notes,
    this.updatedAt,
  });

  final String id;
  final String status; // PENDING, PAID, CONFIRMED, FULFILLED, CANCELLED, REFUNDED
  final double totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime createdAt;
  final List<ApiOrderItemDto> items;
  final String? notes;
  final DateTime? updatedAt;

  static ApiOrderDto fromJson(Map<String, dynamic> json) {
    final id = json['id'] ?? json['_id']?.toString() ?? '';
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final items = itemsList
        .whereType<Map<String, dynamic>>()
        .map(ApiOrderItemDto.fromJson)
        .toList();
    final createdAt = _parseDate(json['createdAt']);
    final updatedAt = _parseDate(json['updatedAt']);
    return ApiOrderDto(
      id: id.toString(),
      status: json['status'] as String? ?? 'PENDING',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      paymentMethod: json['payment_method'] as String? ?? '',
      paymentStatus: json['payment_status'] as String? ?? 'PENDING',
      createdAt: createdAt ?? DateTime.now(),
      items: items,
      notes: json['notes'] as String?,
      updatedAt: updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    return null;
  }
}

class ApiOrderItemDto {
  const ApiOrderItemDto({
    required this.itemType,
    required this.refId,
    this.quantity = 1,
    this.unitPrice = 0,
    this.title,
  });

  final String itemType; // PACKAGE, COMPANION, HOTEL, TICKET, INSURANCE
  final String refId;
  final int quantity;
  final double unitPrice;
  final String? title;

  static ApiOrderItemDto fromJson(Map<String, dynamic> json) {
    final ref = json['ref_id'];
    return ApiOrderItemDto(
      itemType: json['item_type'] as String? ?? '',
      refId: ref is Map ? (ref['_id'] ?? ref['id'])?.toString() ?? '' : ref?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unit_price'] as num?)?.toDouble() ?? 0,
      title: json['title'] as String?,
    );
  }
}

class OrderListResponse {
  const OrderListResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });
  final List<ApiOrderDto> items;
  final int total;
  final int page;
  final int pageSize;
}

class OrderRepository {
  OrderRepository(this._dio);

  final Dio _dio;
  String get _prefix => '${AppConstants.apiPathPrefix}/orders';

  Future<ApiOrderDto> create({
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    String? companionId,
    String? itineraryId,
    String? notes,
  }) async {
    try {
      final body = <String, dynamic>{
        'items': items,
        'payment_method': paymentMethod,
        if (companionId != null) 'companion_id': companionId,
        if (itineraryId != null) 'itinerary_id': itineraryId,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };
      final res = await _dio.post<Map<String, dynamic>>('$_prefix/', data: body);
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiOrderDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<OrderListResponse> list({
    int page = 1,
    int pageSize = 20,
    String? itineraryId,
  }) async {
    try {
      final query = <String, dynamic>{'page': page, 'pageSize': pageSize};
      if (itineraryId != null) query['itinerary_id'] = itineraryId;
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/', queryParameters: query);
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final orderItems = itemsList
          .whereType<Map<String, dynamic>>()
          .map(ApiOrderDto.fromJson)
          .toList();
      return OrderListResponse(
        items: orderItems,
        total: (data['total'] as num?)?.toInt() ?? 0,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ApiOrderDto> get(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiOrderDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ApiOrderDto> update(String id, {List<Map<String, dynamic>>? items, String? notes, String? companionId}) async {
    try {
      final body = <String, dynamic>{};
      if (items != null) body['items'] = items;
      if (notes != null) body['notes'] = notes;
      if (companionId != null) body['companion_id'] = companionId;
      final res = await _dio.patch<Map<String, dynamic>>('$_prefix/$id', data: body);
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiOrderDto.fromJson(data);
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

  Future<ApiOrderDto> confirmPayment(String id, {String? externalId}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_prefix/$id/confirm-payment',
        data: externalId != null ? {'external_id': externalId} : null,
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiOrderDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<Map<String, dynamic>> createAgreement(String orderId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>('$_prefix/$orderId/agreement');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return data;
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<Map<String, dynamic>?> getAgreement(String orderId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/$orderId/agreement');
      final data = res.data?['data'];
      if (data is Map<String, dynamic>) return data;
      return null;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw Exception(messageFromDioException(e));
    }
  }
}
