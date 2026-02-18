import 'package:flutter/material.dart';

/// 中国绿色旅行风主题色
const Color kAppPrimaryGreen = Color(0xFF3DBE6C);

/// 应用主题配置（无业务逻辑）
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kAppPrimaryGreen,
          brightness: Brightness.light,
          primary: kAppPrimaryGreen,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: kAppPrimaryGreen,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kAppPrimaryGreen,
            foregroundColor: Colors.white,
          ),
        ),
      );
}
