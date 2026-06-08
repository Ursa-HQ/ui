import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import '../../models/trading_data.dart';

/// Top-level account status summary card.
class StatusCard extends StatelessWidget {
  final StatusResponse status;
  final AuditCounters audit;
  final UrsaColors c;

  const StatusCard({
    super.key,
    required this.status,
    required this.audit,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final lifecycleColor = status.isRunning
        ? Colors.greenAccent
        : status.isPaused
            ? Colors.orangeAccent
            : Colors.redAccent;

    final balance = double.tryParse(status.balance) ?? 0.0;
    final pnl = double.tryParse(status.realizedPnl) ?? 0.0;
    final dd = double.tryParse(status.drawdownPct) ?? 0.0;
    final hours = status.uptimeSecs ~/ 3600;
    final minutes = (status.uptimeSecs % 3600) ~/ 60;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: lifecycleColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  status.lifecycle.toUpperCase(),
                  style: UrsaTypography.labelLarge?.copyWith(
                    color: lifecycleColor,
                    letterSpacing: 1.5,
                  ),
                ),
                const Spacer(),
                Text(
                  '${hours}h ${minutes}m',
                  style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _MetricTile(label: 'Balance', value: '\$$balance',
                    style: UrsaTypography.displayMedium, c: c),
                const Spacer(),
                _MetricTile(label: 'Realized P&L', value: '\$$pnl',
                    color: pnl >= 0 ? Colors.greenAccent : Colors.redAccent,
                    style: UrsaTypography.headlineMedium, c: c),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetricTile(label: 'Drawdown', value: '${dd.toStringAsFixed(1)}%',
                    color: dd > 5 ? Colors.redAccent : Colors.yellowAccent,
                    style: UrsaTypography.titleMedium, c: c),
                const SizedBox(width: 32),
                _MetricTile(label: 'Configs', value: '${status.nConfigs}',
                    style: UrsaTypography.titleMedium, c: c),
                const SizedBox(width: 32),
                _MetricTile(label: 'Drift/Ghost',
                    value: '${audit.driftCount}/${audit.ghostCount}',
                    style: UrsaTypography.titleMedium, c: c),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final TextStyle? style;
  final UrsaColors c;

  const _MetricTile({
    required this.label,
    required this.value,
    this.color,
    this.style,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: UrsaTypography.labelSmall?.copyWith(color: c.textLowContrast)),
        const SizedBox(height: 2),
        Text(value, style: style?.copyWith(color: color) ?? style),
      ],
    );
  }
}
