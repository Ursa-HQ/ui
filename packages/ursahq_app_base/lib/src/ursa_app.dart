/// UrsaApp — seasonal dark-themed MaterialApp wrapper.
///
/// Bakes in:
/// - `UrsaTheme.dark(season: getCurrentSeason())` — auto-detects the season
/// - `usePathUrlStrategy()` — clean /path/ URLs (no #)
/// - `debugShowCheckedModeBanner: false` — clean UI
/// - `FlutterError.onError` handler — logs to console
///
/// Two public constructors:
/// - `UrsaApp(home:)` — for apps using standard Navigator
/// - `UrsaApp.router(routerConfig:)` — for apps using GoRouter
///
/// Internal:
/// - `UrsaApp._withSeason(...)` — used by [SeasonAwareApp] to pass a
///   dynamically-received season instead of auto-detecting.

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

  /// Season override — when set, used instead of [getCurrentSeason()].
  /// Used internally by [SeasonAwareApp] after receiving a postMessage.
  final Season? season;

  /// Standard Navigator routing.
  const UrsaApp({
    super.key,
    this.title = 'UrsaHQ',
    required this.home,
    this.themeBuilder,
  }) : routerConfig = null,
       season = null;

  /// GoRouter-based routing.
  const UrsaApp.router({
    super.key,
    this.title = 'UrsaHQ',
    required GoRouter routerConfig,
    this.themeBuilder,
  }) : home = null,
       routerConfig = routerConfig,
       season = null;

  /// Internal: accepts an explicit [season] instead of auto-detecting.
  /// Used by [SeasonAwareApp] for cross-frame season sync.
  const UrsaApp._withSeason({
    super.key,
    this.title = 'UrsaHQ',
    this.home,
    this.routerConfig,
    this.themeBuilder,
    required this.season,
  });

  @override
  Widget build(BuildContext context) {
    usePathUrlStrategy();

    FlutterError.onError = (details) {
      print('[UrsaApp] ERROR: ${details.exception}');
    };

    final effectiveSeason = season ?? getCurrentSeason();
    var theme = UrsaTheme.dark(season: effectiveSeason);
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
