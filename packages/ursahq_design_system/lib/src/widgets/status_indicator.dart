/// UrsaHQ Service Status Indicator
///
/// Three states: up (green), degraded (orange), down (red).
/// Compact circle with optional pulse animation for `up` state.
library;

import 'package:flutter/material.dart';

import '../theme/ursa_colors.dart';

/// Service health status
enum ServiceStatus {
  up,
  degraded,
  down,
  unknown;

  Color get color => switch (this) {
    ServiceStatus.up => UrsaStatusColors.success,
    ServiceStatus.degraded => UrsaStatusColors.warning,
    ServiceStatus.down => UrsaStatusColors.error,
    ServiceStatus.unknown => UrsaStatusColors.unknown,
  };

  String get label => switch (this) {
    ServiceStatus.up => 'Online',
    ServiceStatus.degraded => 'Degraded',
    ServiceStatus.down => 'Offline',
    ServiceStatus.unknown => 'Unknown',
  };
}

/// A small colored circle indicating service health.
///
/// [size] defaults to 8dp. Set [pulse] true for animated ping effect
/// when status is [ServiceStatus.up].
class StatusIndicator extends StatefulWidget {
  final ServiceStatus status;
  final double size;
  final bool pulse;

  const StatusIndicator({
    super.key,
    required this.status,
    this.size = 8,
    this.pulse = false,
  });

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _pulseController;
  Animation<double>? _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initPulse();
  }

  @override
  void didUpdateWidget(StatusIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isUp = widget.status == ServiceStatus.up && widget.pulse;
    final wasUp = oldWidget.status == ServiceStatus.up && oldWidget.pulse;
    if (isUp != wasUp) {
      if (isUp && _pulseController != null) {
        _pulseController!.repeat();
      } else {
        _pulseController?.stop();
        _pulseController?.reset();
      }
    }
  }

  void _initPulse() {
    if (widget.status == ServiceStatus.up && widget.pulse) {
      _pulseController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      );
      _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController!, curve: Curves.easeInOut),
      );
      _pulseController!.repeat();
    }
  }

  @override
  void dispose() {
    _pulseController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPulse = _pulseAnimation != null;

    return AnimatedBuilder(
      animation: _pulseAnimation ?? const AlwaysStoppedAnimation(0),
      builder: (context, child) {
        return SizedBox(
          width: widget.size * 2,
          height: widget.size * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (hasPulse)
                Container(
                  width: widget.size * 2 * (1 + (_pulseAnimation?.value ?? 0) * 0.6),
                  height: widget.size * 2 * (1 + (_pulseAnimation?.value ?? 0) * 0.6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.status.color.withValues(alpha: 0.15 * (1 - (_pulseAnimation?.value ?? 0))),
                  ),
                ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.status.color,
                  boxShadow: hasPulse
                      ? [
                          BoxShadow(
                            color: widget.status.color.withValues(alpha: 0.4),
                            blurRadius: widget.size * 0.5,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
