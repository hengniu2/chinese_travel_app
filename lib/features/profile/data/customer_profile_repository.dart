import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_error.dart';

/// Customer profile from API (display_name, avatar_url, contact_email)
class CustomerProfileDto {
  const CustomerProfileDto({
    required this.userId,
    this.displayName = '',
    this.avatarUrl = '',
    this.contactEmail = '',
  });

  final String userId;
  final String displayName;
  final String avatarUrl;
  final String contactEmail;

  static CustomerProfileDto fromJson(Map<String, dynamic> json) {
    final uid = json['user_id'];
    final uidStr = uid is Map ? (uid['_id'] ?? uid['id'])?.toString() ?? '' : uid?.toString() ?? '';
    return CustomerProfileDto(
      userId: uidStr,
      displayName: json['display_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      contactEmail: json['contact_email'] as String? ?? '',
    );
  }
}

class CustomerProfileRepository {
  CustomerProfileRepository(this._dio);

  final Dio _dio;
  String get _prefix => '${AppConstants.apiPathPrefix}/customer';

  Future<CustomerProfileDto> getProfile() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('$_prefix/profile');
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return CustomerProfileDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  Future<CustomerProfileDto> updateProfile({
    String? displayName,
    String? avatarUrl,
    String? contactEmail,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (displayName != null) body['display_name'] = displayName;
      if (avatarUrl != null) body['avatar_url'] = avatarUrl;
      if (contactEmail != null) body['contact_email'] = contactEmail;
      final res = await _dio.patch<Map<String, dynamic>>(
        '$_prefix/profile',
        data: body,
      );
      final data = res.data?['data'];
      if (data is! Map<String, dynamic>) throw Exception('Invalid response');
      return CustomerProfileDto.fromJson(data);
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }
}
