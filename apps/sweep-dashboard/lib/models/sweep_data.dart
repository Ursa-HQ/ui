/// Models for the sweep pairs API responses.
library;

/// Current status of a running sweep.
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

  factory SweepStatus.fromJson(Map<String, dynamic> json) => SweepStatus(
        startedAt: (json['started_at'] as num).toDouble(),
        elapsedSecs: (json['elapsed_secs'] as num).toDouble(),
        totalSignals: json['total_signals'] as int,
        currentSignalIdx: json['current_signal_idx'] as int,
        currentSignalLabel: json['current_signal_label'] as String,
        totalPairs: json['total_pairs'] as int,
        pairsCompleted: json['pairs_completed'] as int,
        pairsFailed: json['pairs_failed'] as int,
        lastPairName: json['last_pair_name'] as String? ?? '',
        lastPairElapsedS: (json['last_pair_elapsed_s'] as num?)?.toDouble() ?? 0.0,
        totalPairsCompleted: json['total_pairs_completed'] as int? ?? 0,
        totalPairsFailed: json['total_pairs_failed'] as int? ?? 0,
        resultsDir: json['results_dir'] as String? ?? '',
      );

  /// Fraction of pairs completed in the current signal (0.0–1.0).
  double get signalProgress =>
      totalPairs > 0 ? pairsCompleted / totalPairs : 0.0;

  /// Formatted elapsed time string.
  String get elapsedFormatted {
    final h = (elapsedSecs ~/ 3600);
    final m = ((elapsedSecs % 3600) ~/ 60);
    final s = (elapsedSecs % 60).toInt();
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }
}

/// Aggregate stats for a completed signal.
class SignalAggregateStats {
  final String label;
  final int totalValid;
  final int profitable;
  final double pnlMean;
  final double pnlMedian;
  final double scoreP50;
  final double wrMeanPct;
  final double pnlProfitablePct;
  final Map<String, BiasEntry> biasBreakdown;
  // Optional DD brackets
  final int ddUnder10;
  final int dd10to20;
  final int dd20to30;

  SignalAggregateStats({
    required this.label,
    required this.totalValid,
    required this.profitable,
    required this.pnlMean,
    required this.pnlMedian,
    required this.scoreP50,
    required this.wrMeanPct,
    required this.pnlProfitablePct,
    this.biasBreakdown = const {},
    this.ddUnder10 = 0,
    this.dd10to20 = 0,
    this.dd20to30 = 0,
  });

  factory SignalAggregateStats.fromJson(
      String label, Map<String, dynamic> json) {
    final breakdown = <String, BiasEntry>{};
    if (json['bias_breakdown'] is Map) {
      for (final entry in (json['bias_breakdown'] as Map).entries) {
        final v = entry.value;
        if (v is Map) {
          breakdown[entry.key] = BiasEntry(
            count: (v['count'] as num).toInt(),
            profitable: (v['profitable'] as num).toInt(),
          );
        }
      }
    }

    return SignalAggregateStats(
      label: label,
      totalValid: (json['total_valid'] as num?)?.toInt() ?? 0,
      profitable: (json['profitable'] as num?)?.toInt() ?? 0,
      pnlMean: (json['pnl_mean'] as num?)?.toDouble() ?? 0.0,
      pnlMedian: (json['pnl_median'] as num?)?.toDouble() ?? 0.0,
      scoreP50: (json['score_p50'] as num?)?.toDouble() ?? 0.0,
      wrMeanPct: (json['wr_mean_pct'] as num?)?.toDouble() ?? 0.0,
      pnlProfitablePct:
          (json['pnl_profitable_pct'] as num?)?.toDouble() ?? 0.0,
      biasBreakdown: breakdown,
      ddUnder10:
          (json['dd_bracket_under10pct'] as num?)?.toInt() ?? 0,
      dd10to20: (json['dd_bracket_10to20'] as num?)?.toInt() ?? 0,
      dd20to30: (json['dd_bracket_20to30'] as num?)?.toInt() ?? 0,
    );
  }
}

class BiasEntry {
  final int count;
  final int profitable;

  BiasEntry({required this.count, required this.profitable});

  double get profitablePct => count > 0 ? profitable / count * 100 : 0;
}

/// All data fetched from the sweep API.
class SweepDashboardData {
  final SweepStatus? status;
  final List<String> signals;
  final List<SignalAggregateStats> completedResults;

  SweepDashboardData({
    this.status,
    this.signals = const [],
    this.completedResults = const [],
  });
}
