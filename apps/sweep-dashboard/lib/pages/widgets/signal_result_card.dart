/// Card showing aggregate stats for a completed signal.
library;

import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import '../../models/sweep_data.dart';

class SignalResultCard extends StatelessWidget {
  final SignalAggregateStats result;
  final UrsaColors c;

  const SignalResultCard({super.key, required this.result, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: c.backgroundSubtle,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: c.borderSubtle),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Signal label
          Row(
            children: [
              Icon(Icons.analytics_outlined, size: 16, color: c.accent9),
              const SizedBox(width: 6),
              Text(
                result.label,
                style: UrsaTypography.titleSmall
                    ?.copyWith(color: c.textHighContrast),
              ),
              const Spacer(),
              Text(
                '${result.profitable}/${result.totalValid} profitable',
                style: UrsaTypography.bodySmall
                    ?.copyWith(color: Colors.greenAccent),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stats grid
          Row(
            children: [
              _StatCell(
                label: 'PnL Mean',
                value: '\$${result.pnlMean.toStringAsFixed(0)}',
                c: c,
              ),
              const SizedBox(width: 12),
              _StatCell(
                label: 'PnL Median',
                value: '\$${result.pnlMedian.toStringAsFixed(0)}',
                c: c,
              ),
              const SizedBox(width: 12),
              _StatCell(
                label: 'Score p50',
                value: result.scoreP50.toStringAsFixed(1),
                c: c,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatCell(
                label: 'Win Rate',
                value: '${result.wrMeanPct.toStringAsFixed(1)}%',
                c: c,
              ),
              const SizedBox(width: 12),
              _StatCell(
                label: 'Profitable',
                value: '${result.pnlProfitablePct.toStringAsFixed(0)}%',
                c: c,
              ),
              const SizedBox(width: 12),
              _StatCell(
                label: 'DD < 10%',
                value: '${result.ddUnder10}',
                c: c,
              ),
            ],
          ),

          // Bias breakdown
          if (result.biasBreakdown.isNotEmpty) ...[
            const Divider(height: 20, color: Colors.white12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: result.biasBreakdown.entries.map((e) {
                final entry = e.value;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: c.backgroundCanvas,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${e.key}: ${entry.count} '
                    '(${entry.profitablePct.toStringAsFixed(0)}% prof)',
                    style: UrsaTypography.bodySmall?.copyWith(
                        color: c.textLowContrast, fontSize: 10),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final UrsaColors c;

  const _StatCell({
    required this.label,
    required this.value,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: c.backgroundCanvas,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: UrsaTypography.bodySmall
                  ?.copyWith(color: c.textLowContrast, fontSize: 10),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: UrsaTypography.bodyMedium
                  ?.copyWith(color: c.textHighContrast),
            ),
          ],
        ),
      ),
    );
  }
}
