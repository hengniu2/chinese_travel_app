import 'package:dio/dio.dart';

/// 从 Dio 异常中解析后端返回的 message，供 UI 展示
String messageFromDioException(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic> && data['message'] != null) {
    return data['message'] as String;
  }
  if (e.response?.statusCode != null) {
    switch (e.response!.statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未登录或登录已过期';
      case 403:
        return '无权限';
      case 404:
        return '资源不存在';
      case 409:
        return '冲突（如手机号已注册）';
      case 500:
        return '服务器错误，请稍后重试';
    }
  }
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return '网络超时，请检查网络';
  }
  if (e.type == DioExceptionType.connectionError) {
    return '无法连接服务器，请检查网络';
  }
  return e.message ?? '请求失败';
}
