/// UrsaHQ Launcher — Main Entry Point
///
/// Single-tab Flutter web SPA that serves as the navigation shell
/// for all UrsaHQ home server services.
///
/// Third-party services load in an iframe within the content area,
/// keeping the sidebar/chrome persistently visible. Native Flutter
/// UIs render directly as widgets. The address bar is updated via
/// pushState for direct linkability — refreshing at a subpath loads
/// the service directly via nginx (shell is available at /).
library;

import 'dart:async';
import 'dart:html' show window;

import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';

import 'config/services.dart';
import 'services/health_checker.dart';
import 'widgets/content_area.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const UrsaLauncherApp());
}

class UrsaLauncherApp extends StatefulWidget {
  const UrsaLauncherApp({super.key});

  @override
  State<UrsaLauncherApp> createState() => _UrsaLauncherAppState();
}

class _UrsaLauncherAppState extends State<UrsaLauncherApp> {
  Season _season = getCurrentSeason();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UrsaHQ',
      debugShowCheckedModeBanner: false,
      theme: UrsaTheme.dark(season: _season),
      home: LauncherShell(
        onSeasonChanged: (season) => setState(() => _season = season),
        season: _season,
      ),
    );
  }
}

/// The main launcher shell — sidebar on the left, content area on the right.
///
/// Manages [activeService] state, URL history via pushState/popstate,
/// and sidebar collapse state persisted to localStorage.
class LauncherShell extends StatefulWidget {
  final ValueChanged<Season>? onSeasonChanged;
  final Season season;

  const LauncherShell({super.key, this.onSeasonChanged, required this.season});

  @override
  State<LauncherShell> createState() => _LauncherShellState();
}

class _LauncherShellState extends State<LauncherShell> {
  /// The currently active service, or null for the home/welcome screen.
  ServiceEntry? _activeService;

  /// Whether the sidebar is collapsed (icon-only).
  bool _isSidebarCollapsed = false;

  /// All registered services, keyed by path for lookup.
  late final Map<String, ServiceEntry> _servicesByPath;

  /// Live status overrides from health checks.
  /// Keyed by service path, e.g. '/sonarr/' → ServiceStatus.up.
  Map<String, ServiceStatus> _statusOverrides = {};

  /// Periodic health check timer.
  Timer? _healthCheckTimer;

  @override
  void initState() {
    super.initState();

    // Build path lookup
    _servicesByPath = {for (final s in launcherServices) s.path: s};

    // Restore sidebar state from localStorage
    _isSidebarCollapsed = window.localStorage['ursahq_sidebar_collapsed'] == 'true';

    // Check if we arrived at a service subpath (e.g. direct link to /dozzle/)
    // If so, show it in the shell. If not, show the welcome screen.
    final initialPath = window.location.pathname ?? '/';
    if (initialPath != '/' && initialPath.isNotEmpty) {
      final normalized = initialPath.endsWith('/') ? initialPath : '$initialPath/';
      final service = _servicesByPath[normalized];
      if (service != null) {
        _activeService = service;
      }
    }

    // Listen for browser back/forward navigation
    window.onPopState.listen((_) {
      if (!mounted) return;
      final path = window.location.pathname ?? '/';
      final normalized = path.endsWith('/') ? path : '$path/';
      setState(() {
        if (normalized == '/' || normalized.isEmpty) {
          _activeService = null;
        } else {
          _activeService = _servicesByPath[normalized];
        }
      });
    });

    // Start periodic health checks
    _runHealthCheck();
    _healthCheckTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _runHealthCheck(),
    );
  }

  @override
  void dispose() {
    _healthCheckTimer?.cancel();
    super.dispose();
  }

  /// Probe all services and update live status overrides.
  Future<void> _runHealthCheck() async {
    final results = await checkAllServices(launcherServices);
    if (!mounted) return;
    setState(() {
      _statusOverrides = results;
    });
  }

  /// Navigate to a service by path.
  ///
  /// For subpath paths (e.g. /dozzle/), updates the URL via pushState
  /// and shows the service in the content area. For root (/), clears
  /// the active service to show the welcome screen.
  /// For services with an [externalUrl], navigates the full page away
  /// from the shell (the service handles its own auth/routing).
  void _navigateTo(String path) {
    final normalized = path.endsWith('/') ? path : '$path/';

    if (normalized == '/' || normalized.isEmpty) {
      window.history.pushState(null, '', '/');
      setState(() => _activeService = null);
      return;
    }

    final service = _servicesByPath[normalized];

    // External URL — navigate full page away from the shell
    if (service != null && service.externalUrl != null) {
      window.location.assign(service.externalUrl!);
      return;
    }

    // Local subpath — show in iframe within the shell
    if (service != null) {
      window.history.pushState({'service': service.id}, '', normalized);
      setState(() => _activeService = service);
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
    window.localStorage['ursahq_sidebar_collapsed'] = _isSidebarCollapsed.toString();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;
    // Build the active path string for sidebar highlighting
    final activePath = _activeService?.path ?? '/';

    return Scaffold(
      body: Row(
        children: [
          UrsaSidebar(
            services: launcherServices,
            activePath: activePath,
            isCollapsed: _isSidebarCollapsed,
            onToggle: _toggleSidebar,
            onNavigate: _navigateTo,
            statusOverrides: _statusOverrides,
          ),
          Expanded(
            child: ContentArea(
              activeService: _activeService,
              c: c,
              onSeasonChanged: widget.onSeasonChanged,
              sidebarCollapsed: _isSidebarCollapsed,
              onNavigate: _navigateTo,
              statusOverrides: _statusOverrides,
              season: widget.season,
            ),
          ),
        ],
      ),
    );
  }
}
