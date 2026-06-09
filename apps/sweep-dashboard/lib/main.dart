/// Sweep Pairs Dashboard — live status of multi-pair sweeps.
///
/// Views:
/// - **Status card** — current signal, pair progress, elapsed time
/// - **Signal list** — completed signals with expandable aggregate stats
/// - **Auto-refresh** — polls /api/sweep/status every 5 seconds
library;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SweepDashboardApp());
}

class SweepDashboardApp extends StatelessWidget {
  const SweepDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweep Pairs',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        cardColor: const Color(0xFF161B22),
      ),
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

  static const _apiBase = '/api/sweep';

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
      final res = await http.get(Uri.parse('$_apiBase/status'));
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
      final res = await http.get(Uri.parse('$_apiBase/signals'));
      if (res.statusCode == 200) {
        final list = List<String>.from(jsonDecode(res.body));
        setState(() => _signals = list);
      }
    } catch (_) {}
  }

  Future<void> _fetchSignalResult(String label) async {
    if (_signalResults.containsKey(label)) return;
    try {
      final res = await http.get(Uri.parse('$_apiBase/results/$label'));
      if (res.statusCode == 200) {
        setState(() => _signalResults[label] = jsonDecode(res.body));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: const Text('Sweep Pairs'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_status != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: StatusChip(isRunning: _status!.totalPairsCompleted < _status!.totalPairs),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              'Sweep API unreachable\n$_errorMsg',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[400]),
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
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildMetricsRow(),
            const SizedBox(height: 24),
            _buildSignalList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final s = _status!;
    final progress = s.totalPairs > 0
        ? s.pairsCompleted / s.totalPairs
        : s.totalSignals > 0
            ? s.currentSignalIdx / s.totalSignals
            : 0.0;

    return Card(
      color: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.currentSignalLabel,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 12,
                backgroundColor: const Color(0xFF21262D),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF58A6FF)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Signal ${s.currentSignalIdx + 1}/${s.totalSignals}  •  '
              'Pair ${s.pairsCompleted}/${s.totalPairs}  •  '
              '${s.totalPairsCompleted + s.totalPairsFailed} total',
              style: TextStyle(color: Colors.grey[400], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsRow() {
    final s = _status!;
    return Row(
      children: [
        _metricTile('Completed', '${s.totalPairsCompleted}', Colors.greenAccent),
        _metricTile('Failed', '${s.totalPairsFailed}', Colors.redAccent),
        _metricTile('Elapsed', _formatDuration(s.elapsedSecs), Colors.amberAccent),
        _metricTile('Signals', '${s.totalSignals}', Colors.blueAccent),
      ],
    );
  }

  Widget _metricTile(String label, String value, Color color) {
    return Expanded(
      child: Card(
        color: const Color(0xFF161B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignalList() {
    if (_signals.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Completed Signals (${_signals.length})',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        ..._signals.reversed.map((label) => _signalTile(label)),
      ],
    );
  }

  Widget _signalTile(String label) {
    return Card(
      color: const Color(0xFF161B22),
      margin: const EdgeInsets.only(bottom: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        iconColor: Colors.grey,
        collapsedIconColor: Colors.grey,
        onExpansionChanged: (expanded) {
          if (expanded) _fetchSignalResult(label);
        },
        children: [
          if (_signalResults.containsKey(label))
            ..._buildResultRows(_signalResults[label]!)
          else
            const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildResultRows(Map<String, dynamic> result) {
    final entries = result.entries.take(15).toList();
    return entries.map((e) {
      final val = e.value is num ? _formatNum(e.value as num) : '${e.value}';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(e.key, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            Text(val, style: const TextStyle(color: Colors.white, fontSize: 12)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isRunning ? const Color(0x1F3FB950) : const Color(0x1F58A6FF),
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
              color: isRunning ? const Color(0xFF3FB950) : const Color(0xFF58A6FF),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isRunning ? 'RUNNING' : 'DONE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isRunning ? const Color(0xFF3FB950) : const Color(0xFF58A6FF),
            ),
          ),
        ],
      ),
    );
  }
}
