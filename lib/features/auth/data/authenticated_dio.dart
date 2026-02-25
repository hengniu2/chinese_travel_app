import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../../../../core/constants/app_constants.dart';
import 'token_storage.dart';
import '../providers/auth_provider.dart';

/// 带认证与 401 刷 token 的 Dio，供全应用 API 请求使用（登录/注册等用 [dioClientProvider]）
final authenticatedDioProvider = Provider<Dio>((ref) {
  final storage = ref.read(tokenStorageProvider);
  final markExpired = () => ref.read(authProvider.notifier).markExpired();

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
      sendTimeout: const Duration(seconds: 90),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        // 刷新 token 的请求不附加 Authorization
        if (options.path.contains('/auth/refresh')) {
          return handler.next(options);
        }
        final token = await storage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (err, handler) async {
        if (err.response?.statusCode != 401) {
          return handler.next(err);
        }
        if (err.requestOptions.path.contains('/auth/refresh')) {
          await storage.clear();
          markExpired();
          return handler.next(err);
        }
        final refreshToken = await storage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          await storage.clear();
          markExpired();
          return handler.next(err);
        }
        try {
          final refreshDio = Dio(
            BaseOptions(
              baseUrl: AppConstants.apiBaseUrl,
              connectTimeout: const Duration(seconds: 90),
              receiveTimeout: const Duration(seconds: 90),
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
            ),
          );
          final res = await refreshDio.post<Map<String, dynamic>>(
            '${AppConstants.apiPathPrefix}/auth/refresh',
            data: {'refresh_token': refreshToken},
          );
          final data = res.data;
          if (data == null ||
              data['data'] is! Map ||
              (data['data'] as Map)['access_token'] == null ||
              (data['data'] as Map)['refresh_token'] == null) {
            await storage.clear();
            markExpired();
            return handler.next(err);
          }
          final newData = data['data'] as Map<String, dynamic>;
          final access = newData['access_token'] as String;
          final refresh = newData['refresh_token'] as String;
          await storage.saveTokens(access, refresh);
          err.requestOptions.headers['Authorization'] = 'Bearer $access';
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (_) {
          await storage.clear();
          markExpired();
          return handler.next(err);
        }
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => Logger().d(obj),
    ),
  );

  return dio;
});
