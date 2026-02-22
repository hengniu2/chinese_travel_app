import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../data/token_storage.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(tokenStorageProvider);
  return AuthRepository(storage);
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
    if (token != null && !expired) {
      state = AuthState(token: token, status: AuthStatus.authenticated);
    } else {
      if (token != null && expired) await repo.logout();
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

  Future<void> loginByCode(String phone, String code) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.loginByCode(phone, code);
      await repo.persistAuth(result);
      state = AuthState(token: result.token, status: AuthStatus.authenticated);
    } catch (e) {
      state = AuthState(status: AuthStatus.initial);
      rethrow;
    }
  }

  Future<void> register(String phone, String code, String password) async {
    state = AuthState(status: AuthStatus.loading);
    try {
      final repo = ref.read(authRepositoryProvider);
      final result = await repo.register(phone, code, password);
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
