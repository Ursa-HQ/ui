import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import '../models/dl_data.dart';
import '../services/dl_api.dart';

/// Main DL dashboard page — auto-refreshes every 10s during active download, 60s when idle.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DlStatus? _status;
  String? _error;
  Timer? _refreshTimer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
    _startTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _refreshTimer?.cancel();
    final interval = (_status?.running == true) ? 10 : 60;
    _refreshTimer = Timer.periodic(Duration(seconds: interval), (_) => _loadStatus());
  }

  Future<void> _loadStatus() async {
    try {
      final status = await DlApi.fetchStatus();
      if (!mounted) return;
      setState(() {
        _status = status;
        _error = null;
        _loading = false;
      });
      _startTimer(); // Adjust refresh interval based on new status
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = UrsaColors.dark(Season.winter);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dukascopy Downloader',
          style: UrsaTypography.titleLarge?.copyWith(color: c.textHighContrast),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadStatus,
          ),
        ],
      ),
      body: _buildBody(context, c),
    );
  }

  Widget _buildBody(BuildContext context, UrsaColors c) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _status == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text('Failed to connect to downloader',
                style: UrsaTypography.titleMedium?.copyWith(color: c.textHighContrast)),
            const SizedBox(height: 8),
            Text(_error!, style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadStatus, child: const Text('Retry')),
          ],
        ),
      );
    }

    final status = _status!;

    return RefreshIndicator(
      onRefresh: _loadStatus,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status banner
          _StatusBanner(status: status, c: c),
          const SizedBox(height: 20),

          // Progress section
          _ProgressSection(status: status, c: c),
          const SizedBox(height: 20),

          // Stats grid
          _StatsGrid(status: status, c: c),
          const SizedBox(height: 16),

          // Refresh indicator
          Center(
            child: Text(
              status.running ? 'Auto-refreshes every 10s' : 'Auto-refreshes every 60s',
              style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Top status banner — running/idle/complete/error.
class _StatusBanner extends StatelessWidget {
  final DlStatus status;
  final UrsaColors c;

  const _StatusBanner({required this.status, required this.c});

  @override
  Widget build(BuildContext context) {
    final (icon, label, bgColor) = _deriveStatus();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: bgColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: UrsaTypography.titleSmall?.copyWith(color: c.textHighContrast)),
                if (status.running)
                  Text('${status.currentPair} (${status.currentYear})',
                      style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (IconData, String, Color) _deriveStatus() {
    if (status.isIdle) {
      return (Icons.cloud_outlined, 'Idle — waiting for download', Colors.grey);
    }
    if (status.isComplete) {
      return (Icons.check_circle_outline, 'Download complete', Colors.greenAccent);
    }
    if (status.running) {
      return (Icons.cloud_download_rounded, 'Downloading...', Colors.blueAccent);
    }
    return (Icons.warning_amber_rounded, 'Incomplete — ${status.pairsCompleted}/${status.pairsTotal}', Colors.orangeAccent);
  }
}

/// Progress bar and pair-year completion.
class _ProgressSection extends StatelessWidget {
  final DlStatus status;
  final UrsaColors c;

  const _ProgressSection({required this.status, required this.c});

  @override
  Widget build(BuildContext context) {
    final pct = status.progressPct;
    final progressColor = pct >= 100
        ? Colors.greenAccent
        : pct > 50
            ? Colors.blueAccent
            : Colors.orangeAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress',
                style: UrsaTypography.titleSmall?.copyWith(color: c.textLowContrast)),
            Text('${pct.toStringAsFixed(1)}%',
                style: UrsaTypography.titleMedium?.copyWith(color: c.textHighContrast)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct / 100.0,
            minHeight: 12,
            backgroundColor: c.backgroundSubtle.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation(progressColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${status.pairsCompleted} / ${status.pairsTotal} pair-years',
          style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast),
        ),
      ],
    );
  }
}

/// Stats grid — hours, bytes, elapsed.
class _StatsGrid extends StatelessWidget {
  final DlStatus status;
  final UrsaColors c;

  const _StatsGrid({required this.status, required this.c});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatTile(label: 'New Hours', value: '${status.okHours}', icon: Icons.schedule, c: c)),
        const SizedBox(width: 8),
        Expanded(child: _StatTile(label: 'Data Downloaded', value: status.totalBytesFormatted, icon: Icons.storage, c: c)),
        const SizedBox(width: 8),
        Expanded(child: _StatTile(label: 'Elapsed', value: status.elapsedFormatted, icon: Icons.timer, c: c)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final UrsaColors c;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: c.solidDefault.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: c.accent9, size: 20),
          const SizedBox(height: 8),
          Text(value,
              style: UrsaTypography.titleSmall?.copyWith(
                color: c.textHighContrast,
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 4),
          Text(label,
              style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
