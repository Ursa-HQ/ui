/// SeasonAwareApp — extends [UrsaApp] with cross-frame season sync.
///
/// When loaded inside the UrsaHQ launcher iframe, the parent sends the
/// season via two mechanisms to avoid race conditions:
///
/// 1. **Query parameter** (reliable, no race): The iframe URL includes
///    `?ursaSeason=summer`. [SeasonAwareApp] reads this from
///    `window.location.search` in [initState] before any widget build.
///
/// 2. **postMessage** (real-time updates): After the iframe loads, the
///    launcher sends `{'ursaSeason': 'winter'}` via `postMessage` on
///    every season toggle, keeping the child in sync without reloading.
///
/// When loaded standalone (outside the launcher), it falls back to
/// [getCurrentSeason()] (date-based auto-detection), behaving exactly
/// like [UrsaApp].
///
/// Usage:
/// ```dart
/// void main() => runApp(const SeasonAwareApp(home: WikiShell()));
/// ```
///
/// With GoRouter:
/// ```dart
/// void main() => runApp(SeasonAwareApp.router(routerConfig: _router));
/// ```

library;

import 'dart:html' show window, Event, MessageEvent;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';

import 'ursa_app.dart';

/// A seasonal [UrsaApp] that syncs its theme with the launcher parent frame.
///
/// Use this instead of [UrsaApp] for any Flutter SPA that may be loaded
/// in the UrsaHQ launcher iframe. The season is propagated in real-time
/// without reloading the iframe.
class SeasonAwareApp extends StatefulWidget {
  /// App title (shown in tab/browser title).
  final String title;

  /// The root widget (for standard Navigator routing).
  final Widget? home;

  /// The GoRouter config (for [SeasonAwareApp.router] constructor).
  final GoRouter? routerConfig;

  /// Optional theme modifier.
  final ThemeData Function(ThemeData base)? themeBuilder;

  /// Standard Navigator routing.
  const SeasonAwareApp({
    super.key,
    this.title = 'UrsaHQ',
    required this.home,
    this.themeBuilder,
  }) : routerConfig = null;

  /// GoRouter-based routing.
  const SeasonAwareApp.router({
    super.key,
    this.title = 'UrsaHQ',
    required GoRouter routerConfig,
    this.themeBuilder,
  }) : home = null,
       routerConfig = routerConfig;

  @override
  State<SeasonAwareApp> createState() => _SeasonAwareAppState();
}

class _SeasonAwareAppState extends State<SeasonAwareApp> {
  Season _season = _initSeason();

  /// Reads the initial season from URL query param `?ursaSeason=summer`
  /// (set by the launcher iframe parent) or falls back to [getCurrentSeason()].
  static Season _initSeason() {
    if (kIsWeb) {
      try {
        final params = Uri.base.queryParameters;
        final name = params['ursaSeason'];
        if (name != null) {
          return Season.values.firstWhere(
            (s) => s.name == name,
            orElse: () => getCurrentSeason(),
          );
        }
      } catch (_) {
        // Ignore parse errors and fall through to date-based detection.
      }
    }
    return getCurrentSeason();
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      window.addEventListener('message', _handleMessage);
    }
  }

  void _handleMessage(Event event) {
    if (event is MessageEvent && event.data is Map && (event.data as Map)['ursaSeason'] is String) {
      final name = (event.data as Map)['ursaSeason'] as String;
      final season = Season.values.firstWhere(
        (s) => s.name == name,
        orElse: () => getCurrentSeason(),
      );
      if (season != _season) {
        setState(() => _season = season);
      }
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      window.removeEventListener('message', _handleMessage);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UrsaApp.withSeason(
      title: widget.title,
      home: widget.home,
      routerConfig: widget.routerConfig,
      themeBuilder: widget.themeBuilder,
      season: _season,
    );
  }
}
