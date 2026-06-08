/// UrsaHQ Service Icon Widget
///
/// Displays a Material icon for a service name, with fallback.
/// Provides a consistent icon + label presentation across the launcher.
library;

import 'package:flutter/material.dart';

import '../theme/ursa_colors.dart';

/// Maps a service identifier string to a Material icon.
IconData _iconForService(String id) {
  return switch (id.toLowerCase()) {
    'jellyfin'       => Icons.movie_outlined,
    'plex'           => Icons.movie_outlined,
    'grafana'        => Icons.bar_chart_outlined,
    'adguard'        => Icons.shield_outlined,
    'adguard home'   => Icons.shield_outlined,
    'dozzle'         => Icons.terminal_outlined,
    'portainer'      => Icons.inventory_2_outlined,
    'mt5-bridge'     => Icons.show_chart_outlined,
    'mt5'            => Icons.show_chart_outlined,
    'trading'        => Icons.trending_up_outlined,
    'trading-engine' => Icons.trending_up_outlined,
    'subgen'         => Icons.closed_caption_outlined,
    'forge'          => Icons.games_outlined,
    'forge-admin'    => Icons.games_outlined,
    'homepage'       => Icons.home_outlined,
    'home'           => Icons.home_outlined,
    'dashboard'      => Icons.dashboard_outlined,
    'immich'         => Icons.photo_library_outlined,
    'ollama'         => Icons.psychology_outlined,
    _                => Icons.circle_outlined,
  };
}

/// A styled icon + optional label for a service.
class ServiceIcon extends StatelessWidget {
  final String serviceId;
  final String? label;
  final double iconSize;
  final Color? color;

  const ServiceIcon({
    super.key,
    required this.serviceId,
    this.label,
    this.iconSize = 22,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ??
        Theme.of(context).extension<UrsaColors>()?.textLowContrast ??
        const Color(0xFF8B949E);

    final icon = Icon(
      _iconForService(serviceId),
      size: iconSize,
      color: iconColor,
    );

    if (label == null) return icon;

    return Tooltip(
      message: label!,
      child: icon,
    );
  }
}
