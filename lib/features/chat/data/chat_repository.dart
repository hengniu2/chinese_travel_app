import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_error.dart';

class ApiConversationDto {
  const ApiConversationDto({
    required this.id,
    required this.participants,
    this.orderId,
    this.updatedAt,
  });

  final String id;
  final List<String> participants; // user ids
  final String? orderId;
  final DateTime? updatedAt;

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  static ApiConversationDto fromJson(Map<String, dynamic> json) {
    final parts = json['participants'] as List<dynamic>? ?? [];
    final ids = parts.map((p) {
      if (p is Map) return (p['_id'] ?? p['id'])?.toString() ?? '';
      return p?.toString() ?? '';
    }).where((s) => s.isNotEmpty).toList();
    final orderId = json['order_id'];
    final oid = orderId is Map ? (orderId['_id'] ?? orderId['id'])?.toString() : orderId?.toString();
    return ApiConversationDto(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      participants: ids,
      orderId: oid,
      updatedAt: _parseDate(json['updatedAt']),
    );
  }
}

class ApiMessageDto {
  const ApiMessageDto({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.type,
    required this.content,
    this.readAt,
    this.createdAt,
  });

  final String id;
  final String conversationId;
  final String senderId;
  final String type; // TEXT, IMAGE, FILE, SYSTEM
  final String content;
  final DateTime? readAt;
  final DateTime? createdAt;

  static DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  static ApiMessageDto fromJson(Map<String, dynamic> json) {
    final convId = json['conversation_id'];
    final cid = (convId is Map ? (convId['_id'] ?? convId['id'])?.toString() : convId?.toString()) ?? '';
    final senderId = json['sender_id'];
    final sid = (senderId is Map ? (senderId['_id'] ?? senderId['id'])?.toString() : senderId?.toString()) ?? '';
    return ApiMessageDto(
      id: (json['id'] ?? json['_id'])?.toString() ?? '',
      conversationId: cid,
      senderId: sid,
      type: json['type'] as String? ?? 'TEXT',
      content: json['content'] as String? ?? '',
      readAt: _parseDate(json['read_at'] ?? json['readAt']),
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

class ConversationListResponse {
  const ConversationListResponse({
    required this.items,
    required this.total,
    this.page = 1,
    this.pageSize = 20,
  });
  final List<ApiConversationDto> items;
  final int total;
  final int page;
  final int pageSize;
}

class ChatRepository {
  ChatRepository(this._dio);

  final Dio _dio;
  String get _prefix => '${AppConstants.apiPathPrefix}/chat';

  Future<ApiConversationDto> createConversation({
    required String otherUserId,
    String? orderId,
  }) async {
    try {
      final body = <String, dynamic>{
        'other_user_id': otherUserId,
        if (orderId != null) 'order_id': orderId,
      };
      final res = await _dio.post<Map<String, dynamic>>('$_prefix/conversations', data: body);
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiConversationDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ConversationListResponse> listConversations({
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/conversations',
        queryParameters: {'page': page, 'pageSize': pageSize},
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      final itemsList = data['items'] as List<dynamic>? ?? [];
      final items = itemsList
          .whereType<Map<String, dynamic>>()
          .map(ApiConversationDto.fromJson)
          .toList();
      return ConversationListResponse(
        items: items,
        total: (data['total'] as num?)?.toInt() ?? 0,
        page: (data['page'] as num?)?.toInt() ?? page,
        pageSize: (data['pageSize'] as num?)?.toInt() ?? pageSize,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ApiConversationDto> getConversation(String id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/conversations/$id');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiConversationDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<List<ApiMessageDto>> listMessages(
    String conversationId, {
    int limit = 50,
    DateTime? before,
  }) async {
    try {
      final query = <String, dynamic>{'limit': limit};
      if (before != null) query['before'] = before.toIso8601String();
      final res = await _dio.get<Map<String, dynamic>>(
        '$_prefix/conversations/$conversationId/messages',
        queryParameters: query,
      );
      final data = res.data?['data'];
      if (data is! List) return [];
      return (data as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(ApiMessageDto.fromJson)
          .toList();
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<ApiMessageDto> sendMessage(
    String conversationId, {
    String content = '',
    String type = 'TEXT',
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_prefix/conversations/$conversationId/messages',
        data: {'content': content, 'type': type},
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return ApiMessageDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }
}
