/// 应用常量（无业务逻辑）
class AppConstants {
  AppConstants._();

  static const String defaultLocale = 'zh';
  static const String fallbackLocale = 'en';

  /// 后端 API 基础地址（生产：Render 部署）
  /// 本地调试可覆盖：flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://travel-china-api.onrender.com',
  );

  /// API 路径前缀（与 backend /api 一致）
  static const String apiPathPrefix = '/api';
}
