import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../data/auth_repository.dart';
import '../data/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  final storage = ref.watch(tokenStorageProvider);
  return AuthRepository(dio, storage);
});

/// 认证状态：未登录 | 已登录 | 加载中 | 已失效
enum AuthStatus {
  initial,
  authenticated,
  loading,
  expired,
}

class AuthState {
  const AuthState({
    this.token,
    this.status = AuthStatus.initial,
  });
  final String? token;
  final AuthStatus status;

  bool get isAuthenticated => status == AuthStatus.authenticated && token != null;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  Future<void> init() async {
    state = AuthState(status: AuthStatus.loading);
    final repo = ref.read(authRepositoryProvider);
    final token = await repo.getStoredToken();
    final expired = await repo.isTokenExpired();
    if (token != null && token.isNotEmpty && !expired) {
      state = AuthState(token: token, status: AuthStatus.authenticated);
    } else {
      if (token != null) await repo.logout();
      state = const AuthState();
    }
  }

  Future<void> loginByPassword(String phone, String password) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.loginByPassword(phone, password);
      await repo.persistAuth(result);
      state = AuthState(token: result.token, status: AuthStatus.authenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.initial);
      rethrow;
    }
  }

  /// 验证码登录：仅验证手机，验证成功后需到登录页用密码登录（后端无验证码登录接口）
  Future<void> verifyPhoneOnly(String phone, String code) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.verifyPhone(phone, code);
  }

  /// 仅注册（不验证、不登录）；成功 201 后由 UI 跳转到手机验证页
  Future<void> registerOnly(String phone, String password) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.register(phone, password);
  }

  /// 注册：验证码 + 密码提交 → 验证手机并登录（用于其他入口如验证码登录后补全）
  Future<void> registerThenVerifyAndLogin(String phone, String code, String password) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.registerThenVerifyAndLogin(phone: phone, code: code, password: password);
      await repo.persistAuth(result);
      state = AuthState(token: result.token, status: AuthStatus.authenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.initial);
      rethrow;
    }
  }

  Future<void> sendCode(String phone) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.sendCode(phone);
  }

  Future<void> resetPassword(String phone, String code, String newPassword) async {
    final repo = ref.read(authRepositoryProvider);
    await repo.resetPassword(phone, code, newPassword);
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AuthState();
  }

  /// 标记 Token 失效（如接口返回 401 时调用，便于跳转登录）
  void markExpired() {
    state = AuthState(status: AuthStatus.expired);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// 用于 GoRouter 的 refreshListenable：auth 变化时触发 redirect 重新计算
/// 延迟到下一帧再通知，避免在 build 中刷新导致 _elements.contains(element) 断言失败
final authRefreshListenableProvider = Provider<Listenable>((ref) {
  final notifier = ValueNotifier(0);
  ref.listen(authProvider, (previous, next) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.value++;
    });
  });
  return notifier;
});
