import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import '../../models/trading_data.dart';

/// Card showing per-config metrics (symbol, signal, position, P&L).
class ConfigCard extends StatelessWidget {
  final ConfigMetrics config;
  final UrsaColors c;

  const ConfigCard({super.key, required this.config, required this.c});

  @override
  Widget build(BuildContext context) {
    final upnl = config.unrealizedPnlValue;
    final rpnl = config.realizedPnlValue;
    final totalPnl = upnl + rpnl;

    final pnlColor = totalPnl >= 0 ? Colors.greenAccent : Colors.redAccent;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: symbol + signal + position status
            Row(
              children: [
                Text(config.symbol,
                    style: UrsaTypography.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: c.textHighContrast,
                    )),
                const SizedBox(width: 8),
                _SignalBadge(label: config.signal, c: c),
                const Spacer(),
                if (config.hasPosition)
                  _PositionBadge(
                    side: config.positionSide,
                    isLong: config.isLong,
                    c: c,
                  )
                else
                  Text('FLAT',
                      style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast)),
              ],
            ),
            const SizedBox(height: 12),

            // P&L row
            Row(
              children: [
                _PnlLine(label: 'Unrealized', value: upnl, c: c),
                const SizedBox(width: 24),
                _PnlLine(label: 'Realized', value: rpnl, c: c),
                const SizedBox(width: 24),
                _PnlLine(label: 'Total', value: totalPnl, bold: true, c: c),
              ],
            ),
            const SizedBox(height: 8),

            // Details row (entry, lot size, warm bars)
            Row(
              children: [
                _DetailChip(label: 'Entry', value: config.entry, c: c),
                const SizedBox(width: 8),
                _DetailChip(label: 'Lot', value: config.lotSize.isEmpty ? '-' : config.lotSize, c: c),
                const SizedBox(width: 8),
                _DetailChip(
                  label: 'Bars',
                  value: '${config.warmBars}',
                  color: config.barsWarm ? null : Colors.orangeAccent,
                  c: c,
                ),
                const SizedBox(width: 8),
                if (config.tp.isNotEmpty)
                  _DetailChip(label: 'TP', value: config.tp, c: c),
                if (config.sl.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  _DetailChip(label: 'SL', value: config.sl, c: c),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SignalBadge extends StatelessWidget {
  final String label;
  final UrsaColors c;

  const _SignalBadge({required this.label, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.interactiveDefault,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
          style: UrsaTypography.labelSmall?.copyWith(color: c.accentContrast)),
    );
  }
}

class _PositionBadge extends StatelessWidget {
  final String side;
  final bool isLong;
  final UrsaColors c;

  const _PositionBadge({required this.side, required this.isLong, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isLong ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isLong ? Colors.greenAccent : Colors.redAccent,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isLong ? Icons.arrow_upward : Icons.arrow_downward,
            size: 12,
            color: isLong ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 2),
          Text(side.toUpperCase(),
              style: UrsaTypography.labelSmall?.copyWith(
                    color: isLong ? Colors.greenAccent : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  )),
        ],
      ),
    );
  }
}

class _PnlLine extends StatelessWidget {
  final String label;
  final double value;
  final bool bold;
  final UrsaColors c;

  const _PnlLine({
    required this.label,
    required this.value,
    this.bold = false,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: UrsaTypography.labelSmall?.copyWith(color: c.textLowContrast)),
        Text(
          value.toStringAsFixed(2),
          style: (bold ? UrsaTypography.titleSmall : UrsaTypography.bodyMedium)
              ?.copyWith(
            color: value >= 0 ? Colors.greenAccent : Colors.redAccent,
          ),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final UrsaColors c;

  const _DetailChip({
    required this.label,
    required this.value,
    this.color,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? c.textLowContrast;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.borderSubtle,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text('$label: $value',
          style: UrsaTypography.bodySmall?.copyWith(color: chipColor)),
    );
  }
}
