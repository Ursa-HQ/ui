/// Models matching the trading engine HTTP API responses.

class StatusResponse {
  final String lifecycle;
  final String balance;
  final String drawdownPct;
  final String realizedPnl;
  final String peakBalance;
  final int uptimeSecs;
  final int driftCount;
  final int ghostCount;
  final int? lastDriftTs;
  final int nConfigs;

  StatusResponse({
    required this.lifecycle,
    required this.balance,
    required this.drawdownPct,
    required this.realizedPnl,
    required this.peakBalance,
    required this.uptimeSecs,
    required this.driftCount,
    required this.ghostCount,
    this.lastDriftTs,
    required this.nConfigs,
  });

  factory StatusResponse.fromJson(Map<String, dynamic> json) {
    return StatusResponse(
      lifecycle: json['lifecycle'] as String,
      balance: json['balance'] as String,
      drawdownPct: json['drawdown_pct'] as String,
      realizedPnl: json['realized_pnl'] as String,
      peakBalance: json['peak_balance'] as String,
      uptimeSecs: (json['uptime_secs'] as num).toInt(),
      driftCount: (json['drift_count'] as num).toInt(),
      ghostCount: (json['ghost_count'] as num).toInt(),
      lastDriftTs: json['last_drift_ts'] as int?,
      nConfigs: (json['n_configs'] as num).toInt(),
    );
  }

  bool get isRunning => lifecycle == 'running';
  bool get isPaused => lifecycle == 'paused';
}

class ConfigMetrics {
  final int id;
  final int magic;
  final String symbol;
  final String signal;
  final bool inPosition;
  final String positionSide;
  final String lotSize;
  final String entry;
  final String tp;
  final String sl;
  final String pnlUnrealized;
  final String pnlRealized;
  final bool barsWarm;
  final int warmBars;

  ConfigMetrics({
    required this.id,
    required this.magic,
    required this.symbol,
    required this.signal,
    required this.inPosition,
    required this.positionSide,
    required this.lotSize,
    required this.entry,
    required this.tp,
    required this.sl,
    required this.pnlUnrealized,
    required this.pnlRealized,
    required this.barsWarm,
    required this.warmBars,
  });

  factory ConfigMetrics.fromJson(Map<String, dynamic> json) {
    return ConfigMetrics(
      id: (json['id'] as num).toInt(),
      magic: (json['magic'] as num).toInt(),
      symbol: json['symbol'] as String,
      signal: json['signal'] as String,
      inPosition: json['in_position'] as bool,
      positionSide: json['position_side'] as String,
      lotSize: json['lot_size'] as String,
      entry: json['entry'] as String,
      tp: json['tp'] as String,
      sl: json['sl'] as String,
      pnlUnrealized: json['pnl_unrealized'] as String,
      pnlRealized: json['pnl_realized'] as String,
      barsWarm: json['bars_warm'] as bool,
      warmBars: (json['warm_bars'] as num).toInt(),
    );
  }

  bool get hasPosition => inPosition;
  bool get isLong => positionSide == 'long';
  bool get isShort => positionSide == 'short';

  double get unrealizedPnlValue => double.tryParse(pnlUnrealized) ?? 0.0;
  double get realizedPnlValue => double.tryParse(pnlRealized) ?? 0.0;
}

class MetricsSnapshot {
  final int ts;
  final int uptimeSecs;
  final String lifecycle;
  final String balance;
  final String drawdownPct;
  final String realizedPnl;
  final String peakBalance;
  final AuditCounters audit;
  final List<ConfigMetrics> configs;
  final int pendingOrderCount;

  MetricsSnapshot({
    required this.ts,
    required this.uptimeSecs,
    required this.lifecycle,
    required this.balance,
    required this.drawdownPct,
    required this.realizedPnl,
    required this.peakBalance,
    required this.audit,
    required this.configs,
    required this.pendingOrderCount,
  });

  factory MetricsSnapshot.fromJson(Map<String, dynamic> json) {
    return MetricsSnapshot(
      ts: (json['ts'] as num).toInt(),
      uptimeSecs: (json['uptime_secs'] as num).toInt(),
      lifecycle: json['lifecycle'] as String,
      balance: json['balance'] as String,
      drawdownPct: json['drawdown_pct'] as String,
      realizedPnl: json['realized_pnl'] as String,
      peakBalance: json['peak_balance'] as String,
      audit: AuditCounters.fromJson(json['audit'] as Map<String, dynamic>),
      configs: (json['configs'] as List)
          .map((c) => ConfigMetrics.fromJson(c as Map<String, dynamic>))
          .toList(),
      pendingOrderCount: (json['pending_order_count'] as num).toInt(),
    );
  }
}

class AuditCounters {
  final int driftCount;
  final int ghostCount;
  final int? lastDriftTs;

  AuditCounters({
    required this.driftCount,
    required this.ghostCount,
    this.lastDriftTs,
  });

  factory AuditCounters.fromJson(Map<String, dynamic> json) {
    return AuditCounters(
      driftCount: (json['drift_count'] as num).toInt(),
      ghostCount: (json['ghost_count'] as num).toInt(),
      lastDriftTs: json['last_drift_ts'] as int?,
    );
  }
}
