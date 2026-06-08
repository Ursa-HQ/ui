/// UrsaApp — seasonal dark-themed MaterialApp wrapper.
///
/// Bakes in:
/// - `UrsaTheme.dark(season: getCurrentSeason())` — auto-detects the season
/// - `usePathUrlStrategy()` — clean /path/ URLs (no #)
/// - `debugShowCheckedModeBanner: false` — clean UI
/// - `FlutterError.onError` handler — logs to console
///
/// Two constructors:
/// - `UrsaApp(home:)` — for apps using standard Navigator
/// - `UrsaApp.router(routerConfig:)` — for apps using GoRouter

library;

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show usePathUrlStrategy;
import 'package:go_router/go_router.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';

/// A pre-configured MaterialApp with seasonal UrsaHQ dark theme.
///
/// Standard usage:
/// ```dart
/// void main() => runApp(const UrsaApp(home: MyHomeWidget()));
/// ```
///
/// With GoRouter:
/// ```dart
/// void main() => runApp(UrsaApp.router(routerConfig: _router));
/// ```
class UrsaApp extends StatelessWidget {
  /// App title (shown in tab/browser title).
  final String title;

  /// For [UrsaApp.new]: the root widget.
  final Widget? home;

  /// For [UrsaApp.router]: the GoRouter config.
  final GoRouter? routerConfig;

  /// Optional theme modifier.
  final ThemeData Function(ThemeData base)? themeBuilder;

  /// Standard Navigator routing.
  const UrsaApp({
    super.key,
    this.title = 'UrsaHQ',
    required this.home,
    this.themeBuilder,
  }) : routerConfig = null;

  /// GoRouter-based routing.
  const UrsaApp.router({
    super.key,
    this.title = 'UrsaHQ',
    required GoRouter routerConfig,
    this.themeBuilder,
  }) : home = null,
       routerConfig = routerConfig;

  @override
  Widget build(BuildContext context) {
    usePathUrlStrategy();

    FlutterError.onError = (details) {
      print('[UrsaApp] ERROR: ${details.exception}');
    };

    final season = getCurrentSeason();
    var theme = UrsaTheme.dark(season: season);
    final tb = themeBuilder;
    if (tb != null) {
      theme = tb(theme);
    }

    if (routerConfig != null) {
      return MaterialApp.router(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: theme,
        routerConfig: routerConfig,
      );
    }

    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: home,
    );
  }
}
