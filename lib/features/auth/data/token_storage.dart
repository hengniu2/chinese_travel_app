import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Token 本地存储（Secure）
class TokenStorage {
  TokenStorage() : _storage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static const _keyToken = 'auth_token';
  static const _keyExpiry = 'auth_token_expiry';

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token, {DateTime? expiry}) async {
    await _storage.write(key: _keyToken, value: token);
    if (expiry != null) {
      await _storage.write(key: _keyExpiry, value: expiry.toIso8601String());
    }
  }

  Future<String?> getToken() => _storage.read(key: _keyToken);

  Future<DateTime?> getTokenExpiry() async {
    final s = await _storage.read(key: _keyExpiry);
    if (s == null) return null;
    return DateTime.tryParse(s);
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyExpiry);
  }
}
