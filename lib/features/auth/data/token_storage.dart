import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token 本地存储（Secure）- 存 access_token 与 refresh_token
class TokenStorage {
  TokenStorage() : _storage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static const _keyToken = 'auth_token';
  static const _keyRefreshToken = 'auth_refresh_token';
  static const _keyExpiry = 'auth_token_expiry';

  final FlutterSecureStorage _storage;

  /// 保存双 token（后端返回 access_token + refresh_token）
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: _keyToken, value: accessToken);
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  /// 兼容旧用法：仅保存 access token（可选过期时间）
  Future<void> saveToken(String token, {DateTime? expiry}) async {
    await _storage.write(key: _keyToken, value: token);
    if (expiry != null) {
      await _storage.write(key: _keyExpiry, value: expiry.toIso8601String());
    }
  }

  Future<String?> getToken() => _storage.read(key: _keyToken);

  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  Future<DateTime?> getTokenExpiry() async {
    final s = await _storage.read(key: _keyExpiry);
    if (s == null) return null;
    return DateTime.tryParse(s);
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyExpiry);
  }
}
