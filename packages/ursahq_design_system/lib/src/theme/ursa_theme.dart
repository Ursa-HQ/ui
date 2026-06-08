import 'package:flutter/material.dart';

import 'ursa_colors.dart';
import 'ursa_season.dart';

/// Builds Material 3 ThemeData mapped to the current season's Radix palette.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: UrsaTheme.light(season: Season.spring),
///   darkTheme: UrsaTheme.dark(season: Season.spring),
/// )
/// ```
class UrsaTheme {
  UrsaTheme._(); // prevent instantiation

  /// Light mode with winter (slate/sky) — convenient default.
  static ThemeData get lightTheme => UrsaTheme.light();

  /// Dark mode with winter (slate/sky) — convenient default.
  static ThemeData get darkTheme => UrsaTheme.dark();

  /// Build a light-mode ThemeData for the given [season].
  static ThemeData light({Season season = Season.winter}) {
    final a = RadixColors.accentLight(season);
    final g = RadixColors.grayLight(season);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: g.c1,
      colorScheme: ColorScheme.light(
        primary: a.c9,
        onPrimary: a.contrast,
        primaryContainer: a.c11,
        secondary: g.c8,
        surface: g.c1,
        surfaceContainerLowest: g.c1,
        surfaceContainerLow: g.c2,
        surfaceContainer: g.c3,
        surfaceContainerHigh: g.c4,
        surfaceContainerHighest: g.c5,
        onSurface: g.c12,
        onSurfaceVariant: g.c11,
        outline: g.c7,
        outlineVariant: g.c6,
      ),
      dividerColor: g.c3,
      dividerTheme: DividerThemeData(
        color: g.c3,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: g.c2,
        foregroundColor: g.c12,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: g.c1,
        indicatorColor: a.c9.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((_) =>
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
      extensions: [UrsaColors.light(season)],
    );
  }

  /// Build a dark-mode ThemeData for the given [season].
  static ThemeData dark({Season season = Season.winter}) {
    final a = RadixColors.accentDark(season);
    final g = RadixColors.grayDark(season);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: g.c1,
      colorScheme: ColorScheme.dark(
        primary: a.c9,
        onPrimary: a.contrast,
        primaryContainer: a.c11,
        secondary: g.c8,
        surface: g.c1,
        surfaceContainerLowest: g.c1,
        surfaceContainerLow: g.c2,
        surfaceContainer: g.c3,
        surfaceContainerHigh: g.c4,
        surfaceContainerHighest: g.c5,
        onSurface: g.c12,
        onSurfaceVariant: g.c11,
        outline: g.c7,
        outlineVariant: g.c6,
      ),
      dividerColor: g.c3,
      dividerTheme: DividerThemeData(
        color: g.c3,
        thickness: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: g.c2,
        foregroundColor: g.c12,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: g.c1,
        indicatorColor: a.c9.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((_) =>
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
      extensions: [UrsaColors.dark(season)],
    );
  }
}
