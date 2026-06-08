/// Card showing the current sweep progress — signal, pairs, ETA, last pair.
library;

import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import '../../models/sweep_data.dart';

class SweepProgressCard extends StatelessWidget {
  final SweepStatus status;
  final UrsaColors c;

  const SweepProgressCard({super.key, required this.status, required this.c});

  @override
  Widget build(BuildContext context) {
    final progress = status.signalProgress;

    return Container(
      decoration: BoxDecoration(
        color: c.backgroundSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.borderSubtle),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.radar, color: c.accent9, size: 20),
              const SizedBox(width: 8),
              Text(
                status.currentSignalLabel,
                style: UrsaTypography.titleSmall
                    ?.copyWith(color: c.textHighContrast),
              ),
              const Spacer(),
              _StatusBadge(
                label:
                    '${status.currentSignalIdx + 1}/${status.totalSignals}',
                c: c,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: c.backgroundCanvas,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 0.9
                    ? Colors.green
                    : progress >= 0.5
                        ? Colors.amber
                        : c.accent9,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Pair count and timing
          Text(
            'Pairs: ${status.pairsCompleted}/${status.totalPairs} '
            '(${(progress * 100).toStringAsFixed(0)}%)',
            style: UrsaTypography.bodyMedium
                ?.copyWith(color: c.textHighContrast),
          ),
          const SizedBox(height: 4),

          // Failed count
          if (status.pairsFailed > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    '${status.pairsFailed} failed',
                    style: UrsaTypography.bodySmall
                        ?.copyWith(color: Colors.orange),
                  ),
                ],
              ),
            ),

          // Elapsed + last pair
          Text(
            'Elapsed: ${status.elapsedFormatted}',
            style: UrsaTypography.bodySmall
                ?.copyWith(color: c.textLowContrast),
          ),
          const SizedBox(height: 4),

          // Cumulative across signals
          Text(
            'Total: ${status.totalPairsCompleted} pairs completed, '
            '${status.totalPairsFailed} failed',
            style: UrsaTypography.bodySmall
                ?.copyWith(color: c.textLowContrast),
          ),

          if (status.lastPairName.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: c.backgroundCanvas,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 14, color: Colors.greenAccent),
                  const SizedBox(width: 6),
                  Text(
                    'Last: ${status.lastPairName} '
                    '(${status.lastPairElapsedS.toStringAsFixed(0)}s)',
                    style: UrsaTypography.bodySmall
                        ?.copyWith(color: c.textLowContrast),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final UrsaColors c;

  const _StatusBadge({required this.label, required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.accent9.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Signal $label',
        style: UrsaTypography.bodySmall
            ?.copyWith(color: c.accent9, fontSize: 11),
      ),
    );
  }
}
