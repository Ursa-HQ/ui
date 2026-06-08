/// Service Configuration for the UrsaHQ Launcher
///
/// Defines all services available in the launcher sidebar.
/// Uses subpath routing under your-domain.example.com for services on this host.
/// Services on other machines (NUC, etc.) use externalUrl for full-page
/// navigation to their existing subdomains.
///
/// The [type] field determines whether the service renders in an iframe
/// (thirdParty) or as a native Flutter widget (native).
/// The [externalUrl] field, when set, navigates away from the shell to
/// the given URL (used for services on separate hosts).
library;

import 'package:ursahq_design_system/ursahq_design_system.dart';

/// All home server services shown in the launcher sidebar.
List<ServiceEntry> get launcherServices => [
  // ═══════════════════════════════════════════════════════
  // HOME
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'homepage',
    label: 'Home',
    path: '/',
    status: ServiceStatus.up,
    type: ServiceType.thirdParty,
  ),

  // ═══════════════════════════════════════════════════════
  // MEDIA & ENTERTAINMENT
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'jellyfin',
    label: 'Jellyfin',
    path: '/jellyfin/',
    proxyPath: '/_p/jellyfin/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'sonarr',
    label: 'Sonarr',
    path: '/sonarr/',
    proxyPath: '/_p/sonarr/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'radarr',
    label: 'Radarr',
    path: '/radarr/',
    proxyPath: '/_p/radarr/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'prowlarr',
    label: 'Prowlarr',
    path: '/prowlarr/',
    proxyPath: '/_p/prowlarr/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'qbittorrent',
    label: 'qBittorrent',
    path: '/qbittorrent/',
    proxyPath: '/_p/qbittorrent/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'sabnzbd',
    label: 'SABnzbd',
    path: '/sabnzbd/',
    proxyPath: '/_p/sabnzbd/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'jellyseerr',
    label: 'Jellyseerr',
    path: '/jellyseerr/',
    proxyPath: '/_p/jellyseerr/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'bazarr',
    label: 'Bazarr',
    path: '/bazarr/',
    proxyPath: '/_p/bazarr/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'immich',
    label: 'Immich',
    path: '/immich/',
    externalUrl: 'https://immich.mg3.net',
    proxyPath: '/_p/immich/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),
  const ServiceEntry(
    id: 'rdtclient',
    label: 'RDTClient',
    path: '/rdtclient/',
    externalUrl: 'https://rdtclient.mg3.net',
    proxyPath: '/_p/rdtclient/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.media,
  ),

  // ═══════════════════════════════════════════════════════
  // MONITORING & INFRASTRUCTURE
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'grafana',
    label: 'Grafana',
    path: '/grafana/',
    proxyPath: '/_p/grafana/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.monitoring,
  ),
  const ServiceEntry(
    id: 'prometheus',
    label: 'Prometheus',
    path: '/prometheus/',
    proxyPath: '/_p/prometheus/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.monitoring,
  ),
  const ServiceEntry(
    id: 'cadvisor',
    label: 'cAdvisor',
    path: '/cadvisor/',
    proxyPath: '/_p/cadvisor/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.monitoring,
  ),
  const ServiceEntry(
    id: 'dozzle',
    label: 'Dozzle',
    path: '/dozzle/',
    proxyPath: '/_p/dozzle/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.monitoring,
  ),
  const ServiceEntry(
    id: 'portainer',
    label: 'Portainer',
    path: '/portainer/',
    proxyPath: '/_p/portainer/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.monitoring,
  ),
  const ServiceEntry(
    id: 'nodes',
    label: 'Nodes',
    path: '/nodes/',
    externalUrl: 'https://nodes.mg3.net',
    proxyPath: '/_p/nodes/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.monitoring,
  ),

  // ═══════════════════════════════════════════════════════
  // NETWORK & SECURITY
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'adguard',
    label: 'AdGuard Home',
    path: '/adguard/',
    proxyPath: '/_p/adguard/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.network,
  ),

  // ═══════════════════════════════════════════════════════
  // AI & TOOLS
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'open-webui',
    label: 'Open WebUI',
    path: '/open-webui/',
    proxyPath: '/_p/open-webui/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.ai,
  ),
  const ServiceEntry(
    id: 'obsidian',
    label: 'Obsidian',
    path: '/obsidian/',
    externalUrl: 'https://obsidian.mg3.net',
    proxyPath: '/_p/obsidian/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.ai,
  ),

  // ═══════════════════════════════════════════════════════
  // DOCUMENTATION & STORAGE
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'bookstack',
    label: 'BookStack',
    path: '/bookstack/',
    proxyPath: '/_p/bookstack/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.storage,
  ),
  const ServiceEntry(
    id: 'couchdb',
    label: 'CouchDB',
    path: '/couchdb/',
    proxyPath: '/_p/couchdb/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.storage,
  ),
  const ServiceEntry(
    id: 'minio',
    label: 'MinIO Console',
    path: '/minio/',
    proxyPath: '/_p/minio/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.storage,
  ),

  // ═══════════════════════════════════════════════════════
  // ADMIN
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'nginx-proxy-manager',
    label: 'NPM Proxy',
    path: '/npm/',
    proxyPath: '/_p/npm/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.admin,
  ),
  const ServiceEntry(
    id: 'adminer',
    label: 'Adminer',
    path: '/adminer/',
    externalUrl: 'https://adminer.mg3.net',
    proxyPath: '/_p/adminer/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.admin,
  ),

  // ═══════════════════════════════════════════════════════
  // GAMING
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'monifactory',
    label: 'Monifactory',
    path: '/monifactory/',
    externalUrl: 'https://moni.mg3.net',
    proxyPath: '/_p/monifactory/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.gaming,
  ),
  const ServiceEntry(
    id: 'forge-servers',
    label: 'Minecraft Forge',
    path: '/forge-servers/',
    externalUrl: 'https://forge-admin.example.com/',
    proxyPath: '/_p/forge-servers/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.gaming,
  ),
  const ServiceEntry(
    id: 'homepage-legacy',
    label: 'Homepage (Legacy)',
    path: '/homepage/',
    proxyPath: '/_p/homepage/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.gaming,
  ),

  // ═══════════════════════════════════════════════════════
  // TRADING
  // ═══════════════════════════════════════════════════════
  const ServiceEntry(
    id: 'mt5-bridge',
    label: 'MT5 Bridge',
    path: '/mt5-bridge/',
    proxyPath: '/_p/mt5-bridge/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.trading,
  ),
  const ServiceEntry(
    id: 'trading',
    label: 'Trading Engine',
    path: '/trading/',
    proxyPath: '/_p/trading/',
    status: ServiceStatus.up,
    type: ServiceType.thirdParty,
    category: ServiceCategory.trading,
  ),
  const ServiceEntry(
    id: 'sweep',
    label: 'Sweep Pairs',
    path: '/sweep/',
    proxyPath: '/_p/sweep/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.trading,
  ),
  const ServiceEntry(
    id: 'data-dl',
    label: 'Data Downloader',
    path: '/dl/',
    proxyPath: '/_p/dl/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.trading,
  ),
  const ServiceEntry(
    id: 'subgen',
    label: 'Subtitle Gen',
    path: '/subgen/',
    proxyPath: '/_p/subgen/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.trading,
  ),
  const ServiceEntry(
    id: 'forge-admin',
    label: 'Forge Admin',
    path: '/forge-admin/',
    proxyPath: '/_p/forge-admin/',
    status: ServiceStatus.unknown,
    type: ServiceType.thirdParty,
    category: ServiceCategory.trading,
  ),
];
