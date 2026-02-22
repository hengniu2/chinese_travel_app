import 'package:flutter/material.dart';

import 'colors.dart';
import 'gradients.dart';
import 'radius.dart';
import 'shadows.dart';
import 'spacing.dart';
import 'typography.dart';

/// OTA Design System — Main theme
/// Cartoon-style, Youthful, Premium, Yellow-focused, OTA-level commercial
///
/// Use: `OtaTheme.light` or `OtaTheme.dark` as your app ThemeData.
/// Export tokens via: OtaColors, OtaShadows, OtaRadius, OtaSpacing, OtaGradients, OtaTypography.
class OtaTheme {
  OtaTheme._();

  static ThemeData get light {
    final colorScheme = _lightColorScheme;
    final textTheme = _lightTextTheme;
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: OtaColors.background,
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: OtaColors.border,
        thickness: 1,
      ),
    );
  }

  static ThemeData get dark {
    final colorScheme = _darkColorScheme;
    final textTheme = _darkTextTheme;
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: OtaColors.neutral900,
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(colorScheme),
      elevatedButtonTheme: _elevatedButtonThemeDark(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: OtaColors.neutral800,
        thickness: 1,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Color schemes
  // ─────────────────────────────────────────────────────────────────────────
  static ColorScheme get _lightColorScheme => ColorScheme.light(
        primary: OtaColors.primary,
        onPrimary: OtaColors.neutral900,
        primaryContainer: OtaColors.tertiaryYellow,
        onPrimaryContainer: OtaColors.neutral900,
        secondary: OtaColors.secondaryYellow,
        onSecondary: OtaColors.neutral900,
        error: OtaColors.accentRed,
        onError: OtaColors.neutral0,
        surface: OtaColors.surface,
        onSurface: OtaColors.textPrimary,
        onSurfaceVariant: OtaColors.textSecondary,
        outline: OtaColors.border,
      );

  static ColorScheme get _darkColorScheme => ColorScheme.dark(
        primary: OtaColors.primary,
        onPrimary: OtaColors.neutral900,
        primaryContainer: OtaColors.neutral800,
        onPrimaryContainer: OtaColors.tertiaryYellow,
        secondary: OtaColors.secondaryYellow,
        onSecondary: OtaColors.neutral900,
        error: OtaColors.accentRed,
        onError: OtaColors.neutral0,
        surface: OtaColors.neutral900,
        onSurface: OtaColors.neutral0,
        onSurfaceVariant: OtaColors.neutral500,
        outline: OtaColors.neutral800,
      );

  // ─────────────────────────────────────────────────────────────────────────
  // Text themes (Chinese-optimized)
  // ─────────────────────────────────────────────────────────────────────────
  static TextTheme get _lightTextTheme => TextTheme(
        displayLarge: OtaTypography.h1(OtaColors.textPrimary),
        headlineLarge: OtaTypography.h1(OtaColors.textPrimary),
        headlineMedium: OtaTypography.h2(OtaColors.textPrimary),
        headlineSmall: OtaTypography.h2(OtaColors.textPrimary),
        titleLarge: OtaTypography.h3(OtaColors.textPrimary),
        titleMedium: OtaTypography.h3(OtaColors.textPrimary),
        titleSmall: OtaTypography.label(OtaColors.textPrimary),
        bodyLarge: OtaTypography.body(OtaColors.textSecondary),
        bodyMedium: OtaTypography.body(OtaColors.textSecondary),
        bodySmall: OtaTypography.bodySmall(OtaColors.textSecondary),
        labelLarge: OtaTypography.label(OtaColors.textPrimary),
        labelMedium: OtaTypography.caption(OtaColors.textTertiary),
        labelSmall: OtaTypography.overline(OtaColors.textTertiary),
      );

  static TextTheme get _darkTextTheme => TextTheme(
        displayLarge: OtaTypography.h1(OtaColors.neutral0),
        headlineLarge: OtaTypography.h1(OtaColors.neutral0),
        headlineMedium: OtaTypography.h2(OtaColors.neutral0),
        headlineSmall: OtaTypography.h2(OtaColors.neutral0),
        titleLarge: OtaTypography.h3(OtaColors.neutral0),
        titleMedium: OtaTypography.h3(OtaColors.neutral0),
        titleSmall: OtaTypography.label(OtaColors.neutral0),
        bodyLarge: OtaTypography.body(OtaColors.neutral100),
        bodyMedium: OtaTypography.body(OtaColors.neutral100),
        bodySmall: OtaTypography.bodySmall(OtaColors.neutral500),
        labelLarge: OtaTypography.label(OtaColors.neutral0),
        labelMedium: OtaTypography.caption(OtaColors.neutral500),
        labelSmall: OtaTypography.overline(OtaColors.neutral500),
      );

  // ─────────────────────────────────────────────────────────────────────────
  // Component themes
  // ─────────────────────────────────────────────────────────────────────────
  static AppBarTheme _appBarTheme(ColorScheme colorScheme) => AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: OtaTypography.h2(colorScheme.onSurface),
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
      );

  static CardThemeData _cardTheme(ColorScheme colorScheme) => CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        shadowColor: const Color(0xFF000000),
        shape: RoundedRectangleBorder(
          borderRadius: OtaRadius.mediumRadius,
        ),
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
      );

  static ElevatedButtonThemeData _elevatedButtonTheme() => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OtaColors.primary,
          foregroundColor: OtaColors.neutral900,
          disabledBackgroundColor: OtaColors.neutral500,
          disabledForegroundColor: OtaColors.neutral0,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(48),
          padding: EdgeInsets.symmetric(
            horizontal: OtaSpacing.xs,
            vertical: OtaSpacing.xxs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: OtaRadius.mediumRadius,
          ),
          textStyle: OtaTypography.button(OtaColors.neutral900),
        ),
      );

  static ElevatedButtonThemeData _elevatedButtonThemeDark() => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: OtaColors.primary,
          foregroundColor: OtaColors.neutral900,
          disabledBackgroundColor: OtaColors.neutral800,
          disabledForegroundColor: OtaColors.neutral500,
          elevation: 0,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(48),
          padding: EdgeInsets.symmetric(
            horizontal: OtaSpacing.xs,
            vertical: OtaSpacing.xxs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: OtaRadius.mediumRadius,
          ),
          textStyle: OtaTypography.button(OtaColors.neutral900),
        ),
      );

  static TextButtonThemeData _textButtonTheme() => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: OtaColors.primary,
          disabledForegroundColor: OtaColors.neutral500,
          padding: EdgeInsets.symmetric(
            horizontal: OtaSpacing.xs,
            vertical: OtaSpacing.xxs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: OtaRadius.smallRadius,
          ),
          textStyle: OtaTypography.label(),
        ),
      );

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colorScheme) => InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: OtaSpacing.xs,
          vertical: OtaSpacing.xxs,
        ),
        border: OutlineInputBorder(
          borderRadius: OtaRadius.smallRadius,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: OtaRadius.smallRadius,
          borderSide: BorderSide(color: OtaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: OtaRadius.smallRadius,
          borderSide: BorderSide(color: OtaColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: OtaRadius.smallRadius,
          borderSide: const BorderSide(color: OtaColors.accentRed),
        ),
        hintStyle: OtaTypography.body(OtaColors.textTertiary),
        labelStyle: OtaTypography.label(OtaColors.textSecondary),
      );
}
