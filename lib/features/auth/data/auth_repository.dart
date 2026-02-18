import 'token_storage.dart';

/// 登录/注册结果
class AuthResult {
  const AuthResult({required this.token, this.expiry});
  final String token;
  final DateTime? expiry;
}

/// 认证仓库（当前为本地模拟，后续对接后端）
class AuthRepository {
  AuthRepository(this._tokenStorage);

  final TokenStorage _tokenStorage;

  /// 密码登录
  Future<AuthResult> loginByPassword(String phone, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (phone.length < 11 || password.length < 6) {
      throw Exception('手机号或密码格式不正确');
    }
    final expiry = DateTime.now().add(const Duration(days: 7));
    return AuthResult(token: 'token_${phone}_${DateTime.now().millisecondsSinceEpoch}', expiry: expiry);
  }

  /// 验证码登录
  Future<AuthResult> loginByCode(String phone, String code) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (phone.length < 11 || code.length < 4) {
      throw Exception('手机号或验证码格式不正确');
    }
    final expiry = DateTime.now().add(const Duration(days: 7));
    return AuthResult(token: 'token_${phone}_${DateTime.now().millisecondsSinceEpoch}', expiry: expiry);
  }

  /// 发送验证码
  Future<void> sendCode(String phone) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (phone.length < 11) throw Exception('请输入正确手机号');
  }

  /// 注册
  Future<AuthResult> register(String phone, String code, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (phone.length < 11 || code.length < 4 || password.length < 6) {
      throw Exception('请填写完整且格式正确');
    }
    final expiry = DateTime.now().add(const Duration(days: 7));
    return AuthResult(token: 'token_${phone}_${DateTime.now().millisecondsSinceEpoch}', expiry: expiry);
  }

  /// 忘记密码 - 重置
  Future<void> resetPassword(String phone, String code, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (phone.length < 11 || code.length < 4 || newPassword.length < 6) {
      throw Exception('请填写完整且格式正确');
    }
  }

  /// 登出（仅清本地）
  Future<void> logout() => _tokenStorage.clear();

  /// 读取本地 Token
  Future<String?> getStoredToken() => _tokenStorage.getToken();

  /// 读取过期时间
  Future<DateTime?> getTokenExpiry() => _tokenStorage.getTokenExpiry();

  /// 是否已过期
  Future<bool> isTokenExpired() async {
    final expiry = await _tokenStorage.getTokenExpiry();
    if (expiry == null) return false;
    return DateTime.now().isAfter(expiry);
  }

  /// 持久化登录结果
  Future<void> persistAuth(AuthResult result) async {
    await _tokenStorage.saveToken(result.token, expiry: result.expiry);
  }
}
