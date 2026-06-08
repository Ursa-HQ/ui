/// Models matching the dukascopy-dl HTTP API responses.

/// Current download status from /api/dl/status.
class DlStatus {
  final bool running;
  final String currentPair;
  final int currentYear;
  final int pairsCompleted;
  final int pairsTotal;
  final int okHours;
  final int totalBytes;
  final double startedAt;
  final double elapsedSecs;

  DlStatus({
    required this.running,
    required this.currentPair,
    required this.currentYear,
    required this.pairsCompleted,
    required this.pairsTotal,
    required this.okHours,
    required this.totalBytes,
    required this.startedAt,
    required this.elapsedSecs,
  });

  factory DlStatus.fromJson(Map<String, dynamic> json) {
    return DlStatus(
      running: json['running'] as bool,
      currentPair: json['current_pair'] as String? ?? '',
      currentYear: (json['current_year'] as num?)?.toInt() ?? 0,
      pairsCompleted: (json['pairs_completed'] as num?)?.toInt() ?? 0,
      pairsTotal: (json['pairs_total'] as num?)?.toInt() ?? 0,
      okHours: (json['ok_hours'] as num?)?.toInt() ?? 0,
      totalBytes: (json['total_bytes'] as num?)?.toInt() ?? 0,
      startedAt: (json['started_at'] as num?)?.toDouble() ?? 0.0,
      elapsedSecs: (json['elapsed_secs'] as num?)?.toDouble() ?? 0.0,
    );
  }

  double get progressPct =>
      pairsTotal > 0 ? (pairsCompleted / pairsTotal) * 100.0 : 0.0;

  String get elapsedFormatted {
    final totalSecs = elapsedSecs.toInt();
    final h = totalSecs ~/ 3600;
    final m = (totalSecs % 3600) ~/ 60;
    final s = totalSecs % 60;
    if (h > 0) return '${h}h ${m}m ${s}s';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  String get totalBytesFormatted {
    if (totalBytes < 1024) return '${totalBytes} B';
    if (totalBytes < 1024 * 1024) return '${(totalBytes / 1024).toStringAsFixed(1)} KB';
    return '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool get isIdle => !running && pairsCompleted == 0;
  bool get isComplete => !running && pairsCompleted > 0 && pairsCompleted == pairsTotal;
}

/// Verification report from /api/dl/verify/:pair.
class VerifyReport {
  final String pair;
  final String status;
  final String ts;
  final int totalTicks;
  final int hoursWithData;
  final int expectedHours;
  final double coveragePct;
  final Map<String, int> gaps;
  final DensityBuckets density;
  final SpreadStats spreads;

  VerifyReport({
    required this.pair,
    required this.status,
    required this.ts,
    required this.totalTicks,
    required this.hoursWithData,
    required this.expectedHours,
    required this.coveragePct,
    required this.gaps,
    required this.density,
    required this.spreads,
  });

  factory VerifyReport.fromJson(Map<String, dynamic> json) {
    return VerifyReport(
      pair: json['pair'] as String,
      status: json['status'] as String,
      ts: json['ts'] as String,
      totalTicks: (json['total_ticks'] as num).toInt(),
      hoursWithData: (json['hours_with_data'] as num).toInt(),
      expectedHours: (json['expected_hours'] as num).toInt(),
      coveragePct: (json['coverage_pct'] as num).toDouble(),
      gaps: (json['gaps'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toInt())),
      density: DensityBuckets.fromJson(json['density'] as Map<String, dynamic>),
      spreads: SpreadStats.fromJson(json['spreads'] as Map<String, dynamic>),
    );
  }

  String get coverageFormatted => '${coveragePct.toStringAsFixed(1)}%';
  String get tickFormatted {
    if (totalTicks < 1000) return '$totalTicks';
    if (totalTicks < 1_000_000) return '${(totalTicks / 1000).toStringAsFixed(1)}K';
    return '${(totalTicks / 1_000_000).toStringAsFixed(1)}M';
  }
}

class DensityBuckets {
  final int perfect60;
  final int good55;
  final int ok45;
  final int thin30;
  final int sparse;

  DensityBuckets({
    required this.perfect60,
    required this.good55,
    required this.ok45,
    required this.thin30,
    required this.sparse,
  });

  factory DensityBuckets.fromJson(Map<String, dynamic> json) {
    return DensityBuckets(
      perfect60: (json['perfect60'] as num).toInt(),
      good55: (json['good55'] as num).toInt(),
      ok45: (json['ok45'] as num).toInt(),
      thin30: (json['thin30'] as num).toInt(),
      sparse: (json['sparse'] as num).toInt(),
    );
  }
}

class SpreadStats {
  final int checked;
  final int negative;
  final double meanPips;
  final double medianPips;

  SpreadStats({
    required this.checked,
    required this.negative,
    required this.meanPips,
    required this.medianPips,
  });

  factory SpreadStats.fromJson(Map<String, dynamic> json) {
    return SpreadStats(
      checked: (json['checked'] as num).toInt(),
      negative: (json['negative'] as num).toInt(),
      meanPips: (json['mean_pips'] as num).toDouble(),
      medianPips: (json['median_pips'] as num).toDouble(),
    );
  }
}
