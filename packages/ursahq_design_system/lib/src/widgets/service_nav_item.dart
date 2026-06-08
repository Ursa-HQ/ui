/// UrsaHQ Service Nav Item
///
/// A single row in the sidebar: status dot + icon + label.
/// Highlights when [isActive] is true.
/// When [compact] is true, shows only the status dot + icon (no label),
/// with a tooltip for accessibility.
library;

import 'package:flutter/material.dart';

import '../theme/ursa_colors.dart';
import '../theme/ursa_typography.dart';
import 'service_icon.dart';
import 'status_indicator.dart';

/// A nav item for the sidebar, combining status indicator + icon + label.
class ServiceNavItem extends StatelessWidget {
  final String serviceId;
  final String label;
  final String path;
  final ServiceStatus status;
  final bool isActive;
  final bool compact;
  final VoidCallback onTap;

  const ServiceNavItem({
    super.key,
    required this.serviceId,
    required this.label,
    required this.path,
    this.status = ServiceStatus.unknown,
    this.isActive = false,
    this.compact = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).extension<UrsaColors>()!;

    return Material(
      color: isActive
          ? c.interactiveDefault.withValues(alpha: 0.5)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        hoverColor: c.solidDefault.withValues(alpha: 0.3),
        child: compact
            ? _CompactContent(c: c, serviceId: serviceId, status: status, label: label, isActive: isActive)
            : _FullContent(c: c, serviceId: serviceId, status: status, label: label, isActive: isActive),
      ),
    );
  }
}

/// Full content: status dot + icon + label.
class _FullContent extends StatelessWidget {
  final UrsaColors c;
  final String serviceId;
  final ServiceStatus status;
  final String label;
  final bool isActive;

  const _FullContent({
    required this.c,
    required this.serviceId,
    required this.status,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          // Status dot
          StatusIndicator(status: status, size: 6, pulse: status == ServiceStatus.up),
          const SizedBox(width: 10),
          // Service icon
          ServiceIcon(
            serviceId: serviceId,
            iconSize: 18,
            color: isActive ? c.accent9 : c.textLowContrast,
          ),
          const SizedBox(width: 10),
          // Label
          Expanded(
            child: Text(
              label,
              style: UrsaTypography.labelMedium?.copyWith(
                color: isActive ? c.textHighContrast : c.textLowContrast,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact content: status dot + icon only, with tooltip.
class _CompactContent extends StatelessWidget {
  final UrsaColors c;
  final String serviceId;
  final ServiceStatus status;
  final String label;
  final bool isActive;

  const _CompactContent({
    required this.c,
    required this.serviceId,
    required this.status,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      preferBelow: false,
      waitDuration: const Duration(milliseconds: 400),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusIndicator(status: status, size: 5, pulse: status == ServiceStatus.up),
            const SizedBox(width: 6),
            ServiceIcon(
              serviceId: serviceId,
              iconSize: 20,
              color: isActive ? c.accent9 : c.textLowContrast,
            ),
          ],
        ),
      ),
    );
  }
}
