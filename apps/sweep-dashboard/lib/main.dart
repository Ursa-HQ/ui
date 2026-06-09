/// Sweep Pairs Dashboard — live status of multi-pair sweeps.
///
/// Views:
/// - **Status card** — current signal, pair progress, elapsed time
/// - **Signal list** — completed signals with expandable aggregate stats
/// - **Auto-refresh** — polls API every 5 seconds
///
/// Uses Ursa design system for theming (season-aware, M3).
/// API paths resolve relative to `<base href>` so proxying works.
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ursahq_design_system/ursahq_design_system.dart';

void main() {
  runApp(const SweepDashboardApp());
}

class SweepDashboardApp extends StatelessWidget {
  const SweepDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweep Pairs',
      darkTheme: UrsaTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const SweepDashboardPage(),
    );
  }
}

class SweepDashboardPage extends StatefulWidget {
  const SweepDashboardPage({super.key});

  @override
  State<SweepDashboardPage> createState() => _SweepDashboardPageState();
}

class _SweepDashboardPageState extends State<SweepDashboardPage> {
  SweepStatus? _status;
  List<String> _signals = [];
  Map<String, Map<String, dynamic>> _signalResults = {};
  bool _error = false;
  String _errorMsg = '';
  Timer? _timer;

  /// Build API URI relative to the document base href.
  /// Works correctly through launcher proxy (/_p/sweep/ → /api/sweep/...).
  Uri _apiUri(String path) => Uri.base.resolve('api/sweep/$path');

  @override
  void initState() {
    super.initState();
    _fetchAll();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _fetchAll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchAll() async {
    await Future.wait([_fetchStatus(), _fetchSignals()]);
  }

  Future<void> _fetchStatus() async {
    try {
      final res = await http.get(_apiUri('status'));
      if (res.statusCode == 200) {
        setState(() {
          _status = SweepStatus.fromJson(jsonDecode(res.body));
          _error = false;
        });
      }
    } catch (e) {
      if (!_error) {
        setState(() {
          _error = true;
          _errorMsg = e.toString();
        });
      }
    }
  }

  Future<void> _fetchSignals() async {
    try {
      final res = await http.get(_apiUri('signals'));
      if (res.statusCode == 200) {
        final list = List<String>.from(jsonDecode(res.body));
        setState(() => _signals = list);
      }
    } catch (_) {}
  }

  Future<void> _fetchSignalResult(String label) async {
    if (_signalResults.containsKey(label)) return;
    try {
      final res = await http.get(_apiUri('results/$label'));
      if (res.statusCode == 200) {
        setState(() => _signalResults[label] = jsonDecode(res.body));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<UrsaColors>()!;
    return Scaffold(
      backgroundColor: colors.backgroundCanvas,
      appBar: AppBar(
        title: const Text('Sweep Pairs'),
        actions: [
          if (_status != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: StatusChip(
                isRunning: _status!.totalPairsCompleted < _status!.totalPairs,
              ),
            ),
        ],
      ),
      body: _buildBody(colors),
    );
  }

  Widget _buildBody(UrsaColors colors) {
    if (_error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, color: colors.accent11, size: 48),
            const SizedBox(height: 16),
            Text(
              'Sweep API unreachable\n$_errorMsg',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textLowContrast),
            ),
          ],
        ),
      );
    }

    if (_status == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _fetchAll,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(_status!, colors),
            const SizedBox(height: 24),
            _buildMetricsRow(_status!, colors),
            const SizedBox(height: 24),
            _buildSignalList(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(SweepStatus s, UrsaColors colors) {
    final progress = s.totalPairs > 0
        ? s.pairsCompleted / s.totalPairs
        : s.totalSignals > 0
            ? s.currentSignalIdx / s.totalSignals
            : 0.0;

    return Card(
      color: colors.solidDefault,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.currentSignalLabel,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.textHighContrast,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: colors.borderSubtle,
                valueColor: AlwaysStoppedAnimation<Color>(colors.accent9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Signal ${s.currentSignalIdx + 1}/${s.totalSignals}  •  '
              'Pair ${s.pairsCompleted}/${s.totalPairs}  •  '
              '${s.totalPairsCompleted + s.totalPairsFailed} total',
              style: TextStyle(color: colors.textLowContrast, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow(SweepStatus s, UrsaColors colors) {
    return Row(
      children: [
        _metricTile('Completed', '${s.totalPairsCompleted}', Colors.greenAccent),
        _metricTile('Failed', '${s.totalPairsFailed}', Colors.redAccent),
        _metricTile('Elapsed', _formatDuration(s.elapsedSecs), Colors.amberAccent),
        _metricTile('Signals', '${s.totalSignals}', colors.accent9),
      ],
    );
  }

  Widget _metricTile(String label, String value, Color color) {
    return Expanded(
      child: Card(
        color: Theme.of(context).extension<UrsaColors>()!.solidDefault,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      color: Theme.of(context)
                          .extension<UrsaColors>()!
                          .textLowContrast,
                      fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignalList(UrsaColors colors) {
    if (_signals.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Completed Signals (${_signals.length})',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.textHighContrast)),
        const SizedBox(height: 8),
        ..._signals.reversed.map((label) => _signalTile(label, colors)),
      ],
    );
  }

  Widget _signalTile(String label, UrsaColors colors) {
    return Card(
      color: colors.solidDefault,
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Text(label,
            style:
                TextStyle(color: colors.textHighContrast, fontSize: 14)),
        iconColor: colors.textLowContrast,
        collapsedIconColor: colors.textLowContrast,
        onExpansionChanged: (expanded) {
          if (expanded) _fetchSignalResult(label);
        },
        children: [
          if (_signalResults.containsKey(label))
            ..._buildResultRows(_signalResults[label]!, colors)
          else
            const Padding(
              padding: EdgeInsets.all(12),
              child:
                  SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildResultRows(
      Map<String, dynamic> result, UrsaColors colors) {
    final entries = result.entries.take(15).toList();
    return entries.map((e) {
      final val = e.value is num ? _formatNum(e.value as num) : '${e.value}';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(e.key,
                style:
                    TextStyle(color: colors.textLowContrast, fontSize: 12)),
            Text(val,
                style:
                    const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      );
    }).toList();
  }

  String _formatDuration(double secs) {
    final h = (secs ~/ 3600).toInt();
    final m = ((secs % 3600) ~/ 60).toInt();
    final s = (secs % 60).toInt();
    return '${h}h ${m}m ${s}s';
  }

  String _formatNum(num n) {
    if (n is double) return n.toStringAsFixed(2);
    return n.toString();
  }
}

// ── Model ─────────────────────────────────────────────────────

class SweepStatus {
  final double startedAt;
  final double elapsedSecs;
  final int totalSignals;
  final int currentSignalIdx;
  final String currentSignalLabel;
  final int totalPairs;
  final int pairsCompleted;
  final int pairsFailed;
  final String lastPairName;
  final double lastPairElapsedS;
  final int totalPairsCompleted;
  final int totalPairsFailed;
  final String resultsDir;

  SweepStatus({
    required this.startedAt,
    required this.elapsedSecs,
    required this.totalSignals,
    required this.currentSignalIdx,
    required this.currentSignalLabel,
    required this.totalPairs,
    required this.pairsCompleted,
    required this.pairsFailed,
    required this.lastPairName,
    required this.lastPairElapsedS,
    required this.totalPairsCompleted,
    required this.totalPairsFailed,
    required this.resultsDir,
  });

  factory SweepStatus.fromJson(Map<String, dynamic> j) => SweepStatus(
        startedAt: (j['started_at'] ?? 0).toDouble(),
        elapsedSecs: (j['elapsed_secs'] ?? 0).toDouble(),
        totalSignals: (j['total_signals'] ?? 0).toInt(),
        currentSignalIdx: (j['current_signal_idx'] ?? 0).toInt(),
        currentSignalLabel: j['current_signal_label'] ?? '',
        totalPairs: (j['total_pairs'] ?? 0).toInt(),
        pairsCompleted: (j['pairs_completed'] ?? 0).toInt(),
        pairsFailed: (j['pairs_failed'] ?? 0).toInt(),
        lastPairName: j['last_pair_name'] ?? '',
        lastPairElapsedS: (j['last_pair_elapsed_s'] ?? 0).toDouble(),
        totalPairsCompleted: (j['total_pairs_completed'] ?? 0).toInt(),
        totalPairsFailed: (j['total_pairs_failed'] ?? 0).toInt(),
        resultsDir: j['results_dir'] ?? '',
      );
}

// ── Widgets ────────────────────────────────────────────────────

class StatusChip extends StatelessWidget {
  final bool isRunning;
  const StatusChip({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<UrsaColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isRunning
            ? Colors.green.withValues(alpha: 0.12)
            : colors.accent9.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isRunning ? Colors.greenAccent : colors.accent9,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isRunning ? 'RUNNING' : 'DONE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isRunning ? Colors.greenAccent : colors.accent9,
            ),
          ),
        ],
      ),
    );
  }
}
