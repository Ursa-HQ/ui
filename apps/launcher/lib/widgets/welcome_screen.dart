/// UrsaHQ Welcome Screen
///
/// The landing page shown when no service is selected in the launcher shell.
/// Displays branding, season toggle, and a service card grid.
library;

import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';

import '../config/services.dart' show launcherServices;

/// Welcome/dashboard content shown at the root path.
class WelcomeScreen extends StatelessWidget {
  final UrsaColors c;
  final ValueChanged<Season>? onSeasonChanged;
  final bool sidebarCollapsed;
  final void Function(String path) onNavigate;

  /// Live status overrides from health checks.
  final Map<String, ServiceStatus>? statusOverrides;

  const WelcomeScreen({
    super.key,
    required this.c,
    this.onSeasonChanged,
    this.sidebarCollapsed = false,
    required this.onNavigate,
    this.statusOverrides,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: c.backgroundCanvas,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 48,
            vertical: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: c.accent9.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.dashboard_customize_outlined,
                  size: 32,
                  color: c.accent9,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'UrsaHQ',
                style: UrsaTypography.displayLarge?.copyWith(
                  color: c.textHighContrast,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Home Server Control Center',
                style: UrsaTypography.bodyLarge?.copyWith(
                  color: c.textLowContrast,
                ),
              ),
              const SizedBox(height: 32),
              // Season indicator
              GestureDetector(
                onTap: () {
                  final seasons = Season.values;
                  final currentSeason = seasons.firstWhere(
                    (s) => s.emoji == c.seasonEmoji,
                    orElse: () => Season.winter,
                  );
                  final idx = seasons.indexOf(currentSeason);
                  final next = seasons[(idx + 1) % seasons.length];
                  onSeasonChanged?.call(next);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      c.seasonEmoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      c.seasonLabel,
                      style: UrsaTypography.labelMedium?.copyWith(
                        color: c.textLowContrast,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.refresh,
                      size: 14,
                      color: c.textLowContrast,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Service grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: launcherServices
                    .where((s) => s.id != 'homepage')
                    .map((service) => _ServiceCard(
                          service: service,
                          statusOverride: statusOverrides?[service.path],
                          onNavigate: onNavigate,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A clickable card showing a service name and its status.
class _ServiceCard extends StatelessWidget {
  final ServiceEntry service;
  final ServiceStatus? statusOverride;
  final void Function(String path) onNavigate;

  const _ServiceCard({
    required this.service,
    this.statusOverride,
    required this.onNavigate,
  });

  ServiceStatus get _status => statusOverride ?? service.status;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;
    final status = _status;

    return Material(
      color: c.backgroundSubtle,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onNavigate(service.path),
        hoverColor: c.solidDefault.withValues(alpha: 0.3),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: c.borderSubtle),
          ),
          child: Column(
            children: [
              ServiceIcon(
                serviceId: service.id,
                iconSize: 28,
                color: c.accent9,
              ),
              const SizedBox(height: 10),
              Text(
                service.label,
                style: UrsaTypography.labelMedium?.copyWith(
                  color: c.textHighContrast,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatusIndicator(
                    status: status,
                    size: 6,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status.label,
                    style: UrsaTypography.labelSmall?.copyWith(
                      color: status.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
