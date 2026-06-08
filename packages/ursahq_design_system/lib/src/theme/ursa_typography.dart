/// UrsaHQ Typography — system font tokens
library;

import 'package:flutter/material.dart';

abstract final class UrsaTypography {
  UrsaTypography._();

  // Font family — system default (Segoe UI on Windows, SF Pro on macOS, Noto on Linux)
  // Uses system font stack for zero bundle overhead
  static const String _font = 'system-ui, -apple-system, sans-serif';

  // Display — large headings
  static TextStyle? get displayLarge => _base(28, FontWeight.w600, 1.3);
  static TextStyle? get displayMedium => _base(24, FontWeight.w600, 1.3);

  // Headings
  static TextStyle? get headlineLarge => _base(22, FontWeight.w600, 1.35);
  static TextStyle? get headlineMedium => _base(18, FontWeight.w600, 1.35);
  static TextStyle? get headlineSmall => _base(16, FontWeight.w600, 1.4);

  // Title
  static TextStyle? get titleLarge => _base(16, FontWeight.w500, 1.4);
  static TextStyle? get titleMedium => _base(14, FontWeight.w500, 1.45);
  static TextStyle? get titleSmall => _base(13, FontWeight.w500, 1.45);

  // Body
  static TextStyle? get bodyLarge => _base(15, FontWeight.w400, 1.55);
  static TextStyle? get bodyMedium => _base(14, FontWeight.w400, 1.55);
  static TextStyle? get bodySmall => _base(12, FontWeight.w400, 1.5);

  // Label (buttons, chips, nav items)
  static TextStyle? get labelLarge => _base(14, FontWeight.w500, 1.4);
  static TextStyle? get labelMedium => _base(12, FontWeight.w500, 1.4);
  static TextStyle? get labelSmall => _base(11, FontWeight.w500, 1.35);

  // Monospace
  static TextStyle? get codeLarge => _mono(14, FontWeight.w400, 1.5);
  static TextStyle? get codeSmall => _mono(12, FontWeight.w400, 1.5);

  /// TextTheme for light mode (black-on-light) — mapped from our system token getters.
  static final TextTheme _blackTextTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  /// TextTheme for dark mode (white-on-dark) — same sizes, same weight.
  static final TextTheme _whiteTextTheme = TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );

  static TextStyle _base(double size, FontWeight weight, double height) {
    return TextStyle(
      fontFamily: _font,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: 0,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle _mono(double size, FontWeight weight, double height) {
    return TextStyle(
      fontFamily: 'ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, monospace',
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: -0.3,
    );
  }
}
