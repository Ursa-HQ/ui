/// Main sweep dashboard page — auto-refreshes every 15s.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import '../models/sweep_data.dart';
import '../services/sweep_api.dart';
import 'widgets/sweep_progress_card.dart';
import 'widgets/signal_result_card.dart';

class SweepDashboardPage extends StatefulWidget {
  const SweepDashboardPage({super.key});

  @override
  State<SweepDashboardPage> createState() => _SweepDashboardPageState();
}

class _SweepDashboardPageState extends State<SweepDashboardPage> {
  SweepDashboardData? _data;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshTimer =
        Timer.periodic(const Duration(seconds: 15), (_) => _loadData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await SweepApi.fetchAll();
      if (!mounted) return;
      setState(() {
        _data = data;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = UrsaColors.dark(Season.winter);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sweep Pairs',
            style: UrsaTypography.titleLarge
                ?.copyWith(color: c.textHighContrast)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadData,
          ),
        ],
      ),
      body: _buildBody(context, c),
    );
  }

  Widget _buildBody(BuildContext context, UrsaColors c) {
    if (_error != null && _data?.status == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text('Sweep offline',
                style: UrsaTypography.titleMedium
                    ?.copyWith(color: c.textHighContrast)),
            const SizedBox(height: 8),
            Text(_error!,
                style: UrsaTypography.bodySmall
                    ?.copyWith(color: c.textLowContrast)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_data?.status == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final status = _data!.status!;
    final results = _data!.completedResults;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current progress card
          SweepProgressCard(status: status, c: c),

          const SizedBox(height: 20),

          // Completed signals section
          if (results.isNotEmpty) ...[
            Text(
              'Completed Signals (${results.length})',
              style: UrsaTypography.titleSmall
                  ?.copyWith(color: c.textLowContrast),
            ),
            const SizedBox(height: 8),
            ...results.map(
              (r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SignalResultCard(result: r, c: c),
              ),
            ),
          ],

          // Auto-refresh note
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Auto-refreshes every 15s',
              style: UrsaTypography.bodySmall
                  ?.copyWith(color: c.textLowContrast),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
