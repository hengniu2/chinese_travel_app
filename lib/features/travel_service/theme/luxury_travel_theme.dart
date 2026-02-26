import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Luxury Travel Service theme: warm cream background, primary gold, muted olive,
/// soft shadows, elegant serif-style headers. No bright yellow; reduced saturation.
class LuxuryTravelTheme {
  LuxuryTravelTheme._();

  // ─── Color palette ───────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8F6F1);
  static const Color primaryGold = Color(0xFFC6A769);
  static const Color primaryGoldLight = Color(0xFFD4BC8A);
  static const Color primaryGoldDark = Color(0xFFA68B52);
  /// Pale gold for selected chip/segment backgrounds
  static const Color primaryGoldPale = Color(0xFFF5F0E4);
  static const Color darkText = Color(0xFF1E1E1E);
  static const Color secondaryOlive = Color(0xFF7A8F6A);
  static const Color secondaryOliveMuted = Color(0xFF9AA88A);
  static const Color cardBackground = Color(0xFFFFFEFB);
  static const Color surfaceMuted = Color(0xFFEFEDE8);
  static const Color textSecondary = Color(0xFF5C5C5C);
  static const Color textTertiary = Color(0xFF8E8E8E);
  static const Color border = Color(0xFFE8E6E1);
  static const Color divider = Color(0xFFEEECE7);
  static const Color price = Color(0xFFB85C38);
  static const Color success = Color(0xFF6B8E6B);
  static const Color error = Color(0xFFC45C5C);

  /// Gradient colors for Travel Service FABs (beautiful, distinct).
  static const List<Color> gradientConcierge = [
    Color(0xFFB8985C),
    Color(0xFFD4BC8A),
    Color(0xFFE8D4A8),
  ];
  static const List<Color> gradientOrder = [
    Color(0xFF5A8F6E),
    Color(0xFF7AAF85),
    Color(0xFF9AC99E),
  ];
  static const List<Color> gradientHome = [
    Color(0xFFC96B45),
    Color(0xFFE08B65),
    Color(0xFFE8A080),
  ];

  // ─── Luxury spacing (no overcrowded layout) ───────────────────────────────
  static const double spacingXs = 6;
  static const double spacingSm = 12;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  /// Soft shadow: rgba(0,0,0,0.08)
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.08),
          offset: const Offset(0, 4),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get softShadowMedium => [
        BoxShadow(
          color: const Color(0xFF000000).withValues(alpha: 0.08),
          offset: const Offset(0, 6),
          blurRadius: 24,
          spreadRadius: 0,
        ),
      ];

  // ─── Typography hierarchy ─────────────────────────────────────────────────
  // Strong contrast, proper line height, luxury spacing. No overcrowded text.

  /// DisplayLarge — Hero / page titles. 28px, bold, line height 1.28.
  static TextStyle displayLarge([Color? color]) =>
      GoogleFonts.notoSerifSc(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.28,
        letterSpacing: 0.2,
        color: color ?? darkText,
      );

  /// HeadlineMedium — Section titles, card headings. 20px, semibold, line height 1.35.
  static TextStyle headlineMedium([Color? color]) =>
      GoogleFonts.notoSansSc(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: 0.15,
        color: color ?? darkText,
      );

  /// TitleSmall — Labels, list titles, small headings. 15px, medium, line height 1.4.
  static TextStyle titleSmall([Color? color]) =>
      GoogleFonts.notoSansSc(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
        color: color ?? darkText,
      );

  /// BodyMedium — Body copy. 15px, regular, line height 1.55 (generous, not overcrowded).
  static TextStyle bodyMedium([Color? color]) =>
      GoogleFonts.notoSansSc(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.55,
        letterSpacing: 0.1,
        color: color ?? textSecondary,
      );

  /// Caption — Secondary info, hints, metadata. 13px, regular, line height 1.45.
  static TextStyle caption([Color? color]) =>
      GoogleFonts.notoSansSc(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.45,
        letterSpacing: 0.05,
        color: color ?? textTertiary,
      );

  /// Button label (semibold, for CTAs).
  static TextStyle buttonLabel([Color? color]) =>
      GoogleFonts.notoSansSc(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.2,
        color: color ?? darkText,
      );

  // ─── Legacy aliases (prefer displayLarge / headlineMedium / etc.) ─────────
  static TextStyle largeTitle([Color? color]) => displayLarge(color);
  static TextStyle sectionHeader([Color? color]) => headlineMedium(color);
  static TextStyle body([Color? color]) => bodyMedium(color);
  static TextStyle bodyLarge([Color? color]) => bodyMedium(color ?? darkText);

  // ─── Full ThemeData ─────────────────────────────────────────────────────
  static ThemeData get theme {
    const colorScheme = ColorScheme.light(
      primary: primaryGold,
      onPrimary: darkText,
      primaryContainer: Color(0xFFF5F0E4),
      onPrimaryContainer: primaryGoldDark,
      secondary: secondaryOlive,
      onSecondary: Colors.white,
      surface: cardBackground,
      onSurface: darkText,
      onSurfaceVariant: textSecondary,
      outline: border,
      error: error,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: darkText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: darkText,
        unselectedLabelColor: textTertiary,
        labelStyle: headlineMedium(darkText).copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: bodyMedium(textTertiary).copyWith(fontSize: 16),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryGold, width: 3),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: primaryGold,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardBackground,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: headlineMedium(darkText).copyWith(fontSize: 18),
      ),
      dividerTheme: const DividerThemeData(color: divider, thickness: 1),
      textTheme: TextTheme(
        displayLarge: displayLarge(),
        headlineLarge: displayLarge(),
        headlineMedium: headlineMedium(),
        titleLarge: headlineMedium(),
        titleMedium: titleSmall(),
        titleSmall: titleSmall(),
        bodyLarge: bodyMedium(darkText),
        bodyMedium: bodyMedium(),
        bodySmall: caption(),
        labelLarge: buttonLabel(),
      ),
    );
  }
}

// ─── Example usage ─────────────────────────────────────────────────────────
// 1. In router: wrap Travel Service routes with Theme(data: LuxuryTravelTheme.theme, child: YourPage()).
// 2. In widgets: use LuxuryTravelTheme.background, .primaryGold, .darkText, .softShadow, .largeTitle(), etc.
// 3. When wrapped, Theme.of(context).colorScheme.primary is gold; buttons/cards/tabs use theme defaults.
