/// UrsaHQ Sidebar Navigation
///
/// Vertical sidebar containing the UrsaHQ branding at top, service nav items,
/// and a status summary at bottom. Supports a collapsible mode that shrinks
/// to icon-only width for space efficiency.
library;

import 'dart:html' show window;

import 'package:flutter/material.dart';

import '../theme/ursa_colors.dart';
import '../theme/ursa_typography.dart';
import 'service_nav_item.dart';
import 'status_indicator.dart';

/// Whether a service is served via iframe (third-party) or rendered natively.
enum ServiceType {
  /// Loaded via iframe — nginx proxies the subpath.
  thirdParty,

  /// Rendered as a Flutter widget directly in the shell.
  native,
}

/// Category grouping for sidebar sections.
enum ServiceCategory {
  media('Media & Entertainment'),
  monitoring('Monitoring & Infra'),
  network('Network & Security'),
  ai('AI & Tools'),
  storage('Docs & Storage'),
  admin('Admin'),
  gaming('Gaming'),
  trading('Trading');

  final String label;
  const ServiceCategory(this.label);
}

/// A single service entry for the launcher config.
class ServiceEntry {
  /// Unique identifier for the service.
  final String id;

  /// Display label shown in the sidebar.
  final String label;

  /// Local subpath for routing (e.g. /dozzle/).
  /// Used for sidebar highlighting and URL bar.
  final String path;

  /// Internal proxy path for iframe loading (e.g. /_p/dozzle/).
  /// When set, the iframe loads from this URL instead of [path].
  /// null means the iframe loads from [path] directly (backward compat).
  final String? proxyPath;

  /// External URL override. When set, the iframe loads this URL instead of [path].
  /// Used for services on other machines or with incompatible subpath routing.
  /// Example: 'https://sonarr.mg3.net'
  final String? externalUrl;

  /// Current service status indicator.
  final ServiceStatus status;

  /// Whether this is a third-party (iframe) or native (Flutter widget) service.
  final ServiceType type;

  /// Category grouping for sidebar section headers.
  /// When null, no section header is shown.
  final ServiceCategory? category;

  const ServiceEntry({
    required this.id,
    required this.label,
    required this.path,
    this.proxyPath,
    this.externalUrl,
    this.status = ServiceStatus.unknown,
    this.type = ServiceType.thirdParty,
    this.category,
  });
}

/// Width constants for the sidebar.
abstract final class SidebarWidth {
  SidebarWidth._();
  static const double expanded = 220;
  static const double collapsed = 56;
}

/// The sidebar navigation panel for the UrsaHQ launcher.
///
/// Set [isCollapsed] to toggle between icon-only and full label mode.
/// Provide an [onToggle] callback for a hamburger button in the header.
class UrsaSidebar extends StatelessWidget {
  final List<ServiceEntry> services;
  final String activePath;
  final bool isCollapsed;
  final VoidCallback? onToggle;
  final void Function(String path)? onNavigate;

  /// Live status overrides keyed by service [path].
  /// Overrides the hardcoded [ServiceEntry.status] for each service.
  /// When null or missing, falls back to the entry's status.
  final Map<String, ServiceStatus>? statusOverrides;

  const UrsaSidebar({
    super.key,
    required this.services,
    required this.activePath,
    this.isCollapsed = false,
    this.onToggle,
    this.onNavigate,
    this.statusOverrides,
  });

  double get _width => isCollapsed ? SidebarWidth.collapsed : SidebarWidth.expanded;

  void _navigateTo(String path) {
    if (onNavigate != null) {
      onNavigate!(path);
    } else {
      window.location.assign(path);
    }
  }

  /// Resolve the effective status for a service, using live overrides if available.
  ServiceStatus _statusFor(ServiceEntry service) =>
      statusOverrides?[service.path] ?? service.status;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;
    final upCount = services.where((s) => _statusFor(s) == ServiceStatus.up).length;
    final totalCount = services.length;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: _width,
      decoration: BoxDecoration(
        color: c.backgroundSubtle,
        border: Border(
          right: BorderSide(color: c.borderSubtle, width: 1),
        ),
      ),
      child: Column(
        children: [
          // ── Branding + Toggle ──
          Container(
            padding: EdgeInsets.fromLTRB(
              isCollapsed ? 12 : 14,
              16,
              isCollapsed ? 12 : 10,
              12,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: c.borderSubtle, width: 1),
              ),
            ),
            child: isCollapsed
                ? _CollapsedHeader(c: c, onToggle: onToggle)
                : _ExpandedHeader(c: c, onToggle: onToggle),
          ),

          // ── Service List ──
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: isCollapsed ? 4 : 8,
              ),
              children: () {
                final items = <Widget>[];
                ServiceCategory? lastCategory;

                for (final service in services) {
                  // Insert category header when category changes
                  if (!isCollapsed &&
                      service.category != null &&
                      service.category != lastCategory) {
                    items.add(
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 12, 10, 4),
                        child: Text(
                          service.category!.label,
                          style: UrsaTypography.labelSmall?.copyWith(
                            color: c.textLowContrast.withValues(alpha: 0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    );
                  }
                  lastCategory = service.category;

                  items.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: ServiceNavItem(
                        serviceId: service.id,
                        label: service.label,
                        path: service.path,
                        status: _statusFor(service),
                        isActive: service.path == '/'
                            ? activePath == '/' || activePath.isEmpty
                            : activePath.startsWith(service.path),
                        compact: isCollapsed,
                        onTap: () => _navigateTo(service.path),
                      ),
                    ),
                  );
                }

                return items;
              }(),
            ),
          ),

          // ── Status Summary ──
          if (!isCollapsed)
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: c.borderSubtle, width: 1),
                ),
              ),
              child: Row(
                children: [
                  StatusIndicator(status: ServiceStatus.up, size: 6),
                  const SizedBox(width: 8),
                  Text(
                    '$upCount / $totalCount online',
                    style: UrsaTypography.labelSmall?.copyWith(
                      color: c.textLowContrast,
                    ),
                  ),
                ],
              ),
            )
          else
            // Collapsed status — just the count as a tooltip
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: c.borderSubtle, width: 1),
                ),
              ),
              child: Tooltip(
                message: '$upCount / $totalCount online',
                child: Center(
                  child: StatusIndicator(status: ServiceStatus.up, size: 6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Header shown when sidebar is expanded — logo + text label + toggle button.
class _ExpandedHeader extends StatelessWidget {
  final UrsaColors c;
  final VoidCallback? onToggle;

  const _ExpandedHeader({required this.c, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Logo
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: c.accent9,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            'U',
            style: TextStyle(
              color: c.accentContrast,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Branding text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'UrsaHQ',
                style: UrsaTypography.titleSmall?.copyWith(
                  color: c.textHighContrast,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Home Server',
                style: UrsaTypography.labelSmall?.copyWith(
                  color: c.textLowContrast,
                ),
              ),
            ],
          ),
        ),
        // Toggle button
        if (onToggle != null)
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onToggle,
              hoverColor: c.solidDefault.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.chevron_left,
                  size: 18,
                  color: c.textLowContrast,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Header shown when sidebar is collapsed — just the logo + expand toggle.
class _CollapsedHeader extends StatelessWidget {
  final UrsaColors c;
  final VoidCallback? onToggle;

  const _CollapsedHeader({required this.c, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: c.accent9,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            'U',
            style: TextStyle(
              color: c.accentContrast,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        if (onToggle != null) ...[
          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onToggle,
              hoverColor: c.solidDefault.withValues(alpha: 0.3),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: c.textLowContrast,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
