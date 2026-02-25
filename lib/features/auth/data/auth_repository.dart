import 'package:dio/dio.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/api_error.dart';
import 'token_storage.dart';

/// 登录/注册成功后的 token 结果
class AuthResult {
  const AuthResult({
    required this.token,
    this.refreshToken,
    this.expiry,
  });
  final String token;
  final String? refreshToken;
  final DateTime? expiry;
}

/// 认证仓库（对接 travel_china_api）
class AuthRepository {
  AuthRepository(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  String get _apiPrefix => AppConstants.apiPathPrefix;

  /// 密码登录 → 保存双 token
  Future<AuthResult> loginByPassword(String phone, String password) async {
    if (phone.length < 11 || password.length < 6) {
      throw Exception('手机号或密码格式不正确');
    }
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '$_apiPrefix/auth/login',
        data: {
          'phone_number': phone.trim(),
          'password': password,
        },
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      if (data == null || data['access_token'] == null || data['refresh_token'] == null) {
        throw Exception('登录返回数据异常');
      }
      return AuthResult(
        token: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  /// 验证码仅用于验证手机（后端无“验证码登录”接口）；验证成功后需再调密码登录
  Future<void> verifyPhone(String phone, String code) async {
    if (phone.length < 11 || code.length < 4) {
      throw Exception('请填写正确手机号和验证码');
    }
    try {
      await _dio.post(
        '$_apiPrefix/auth/verify-phone',
        data: {
          'phone_number': phone.trim(),
          'code': code.trim(),
        },
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  /// 发送验证码（注册后或验证码登录前）
  Future<void> sendCode(String phone) async {
    if (phone.length < 11) throw Exception('请输入正确手机号');
    try {
      await _dio.post(
        '$_apiPrefix/auth/send-phone-code',
        data: {'phone_number': phone.trim()},
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  /// 注册（角色 CUSTOMER）→ 需再验证手机后登录
  Future<void> register(String phone, String password) async {
    if (phone.length < 11 || password.length < 6) {
      throw Exception('请填写正确手机号和密码（至少6位）');
    }
    try {
      await _dio.post<Map<String, dynamic>>(
        '$_apiPrefix/auth/register',
        data: {
          'role': 'CUSTOMER',
          'phone_number': phone.trim(),
          'password': password,
        },
      );
    } on DioException catch (e) {
      throw Exception(messageFromDioException(e));
    }
  }

  /// 注册并发送验证码（注册页「获取验证码」：先注册再发码；若已注册则仅重新发码）
  Future<void> registerAndSendCode(String phone, String password) async {
    try {
      await register(phone, password);
    } on Exception catch (e) {
      if (e.toString().contains('409') || e.toString().toLowerCase().contains('already registered')) {
        await sendCode(phone);
        return;
      }
      rethrow;
    }
    await sendCode(phone);
  }

  /// 注册流程：验证手机 → 登录 → 返回 [AuthResult]
  Future<AuthResult> registerThenVerifyAndLogin({
    required String phone,
    required String code,
    required String password,
  }) async {
    await verifyPhone(phone, code);
    return loginByPassword(phone, password);
  }

  /// 忘记密码：后端暂未提供接口
  Future<void> resetPassword(String phone, String code, String newPassword) async {
    throw UnimplementedError('重置密码接口尚未开放，请联系客服');
  }

  /// 登出（可先调后端再清本地；后端为无状态 JWT，仅客户端丢弃 token）
  Future<void> logout() async {
    try {
      final token = await _tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        await _dio.post('$_apiPrefix/auth/logout', options: Options(headers: {'Authorization': 'Bearer $token'}));
      }
    } catch (_) {
      // 忽略登出接口错误，仍清本地
    }
    await _tokenStorage.clear();
  }

  Future<String?> getStoredToken() => _tokenStorage.getToken();

  Future<DateTime?> getTokenExpiry() => _tokenStorage.getTokenExpiry();

  Future<bool> isTokenExpired() async {
    final expiry = await _tokenStorage.getTokenExpiry();
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry);
  }

  /// 持久化登录结果（双 token 或单 token）
  Future<void> persistAuth(AuthResult result) async {
    if (result.refreshToken != null && result.refreshToken!.isNotEmpty) {
      await _tokenStorage.saveTokens(result.token, result.refreshToken!);
    } else {
      await _tokenStorage.saveToken(result.token, expiry: result.expiry);
    }
  }
}
