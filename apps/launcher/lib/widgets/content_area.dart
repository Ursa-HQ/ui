/// UrsaHQ Content Area
///
/// Renders the main content based on the currently selected service.
/// For third-party services → iframe. For native UIs → Flutter widget.
/// When no service is selected → welcome/home screen.
library;

import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';

import 'iframe_content.dart';
import 'welcome_screen.dart';

/// Possible content states for the main area.
enum ContentState {
  /// Show the UrsaHQ welcome/home screen.
  home,

  /// Show a third-party service in an iframe.
  iframe,

  /// Show a native Flutter UI.
  native,
}

/// The main content area of the launcher shell.
///
/// Switches between welcome screen, iframe content, and native Flutter UIs
/// based on the currently active service.
class ContentArea extends StatelessWidget {
  /// The currently active service, or null for home.
  final ServiceEntry? activeService;

  /// The theme colors (passed through for the welcome screen).
  final UrsaColors c;

  /// Callback when the season changes from the welcome screen.
  final ValueChanged<Season>? onSeasonChanged;

  /// Whether the sidebar is collapsed (for welcome screen layout).
  final bool sidebarCollapsed;

  /// Callback when a service card is clicked on the welcome screen.
  final void Function(String path) onNavigate;

  /// Live status overrides from health checks.
  final Map<String, ServiceStatus>? statusOverrides;

  /// Current season — forwarded to [IframeContent] for postMessage sync.
  final Season? season;

  const ContentArea({
    super.key,
    required this.activeService,
    required this.c,
    this.onSeasonChanged,
    this.sidebarCollapsed = false,
    required this.onNavigate,
    this.statusOverrides,
    this.season,
  });

  ContentState get _state {
    if (activeService == null) return ContentState.home;
    switch (activeService!.type) {
      case ServiceType.thirdParty:
        return ContentState.iframe;
      case ServiceType.native:
        return ContentState.native;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case ContentState.home:
        return WelcomeScreen(
          c: c,
          onSeasonChanged: onSeasonChanged,
          sidebarCollapsed: sidebarCollapsed,
          onNavigate: onNavigate,
          statusOverrides: statusOverrides,
        );

      case ContentState.iframe:
        return IframeContent(
          url: activeService!.proxyPath ?? activeService!.path,
          label: activeService!.label,
          season: season,
        );

      case ContentState.native:
        return _NativePlaceholder(
          c: c,
          label: activeService!.label,
        );
    }
  }
}

/// Placeholder for native Flutter UIs that haven't been built yet.
class _NativePlaceholder extends StatelessWidget {
  final UrsaColors c;
  final String label;

  const _NativePlaceholder({required this.c, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: c.backgroundCanvas,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 48,
              color: c.textLowContrast,
            ),
            const SizedBox(height: 12),
            Text(
              '$label UI Coming Soon',
              style: UrsaTypography.bodyLarge?.copyWith(
                color: c.textHighContrast,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A native Flutter UI is being built for this service.',
              style: UrsaTypography.bodySmall?.copyWith(
                color: c.textLowContrast,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
