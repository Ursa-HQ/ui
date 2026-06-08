import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import '../models/trading_data.dart';
import '../services/trading_api.dart';
import 'widgets/status_card.dart';
import 'widgets/config_card.dart';

/// Main trading dashboard page — auto-refreshes every 30s.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DashboardData? _data;
  String? _error;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) => _loadData());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await TradingApi.fetchAll();
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
        title: Text('UrsaHQ Trading',
          style: UrsaTypography.titleLarge?.copyWith(color: c.textHighContrast),
        ),
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
    if (_error != null && _data == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            Text('Failed to load engine data',
                style: UrsaTypography.titleMedium?.copyWith(color: c.textHighContrast)),
            const SizedBox(height: 8),
            Text(_error!, style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast)),
            const SizedBox(height: 16),
            FilledButton(onPressed: _loadData, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final data = _data!;
    final activeConfigs = data.configs.where((c) => c.hasPosition).toList();
    final inactiveConfigs = data.configs.where((c) => !c.hasPosition).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account status
          StatusCard(status: data.status, audit: data.metrics.audit, c: c),
          const SizedBox(height: 20),

          // Active positions section
          if (activeConfigs.isNotEmpty) ...[
            Text('Active Positions',
                style: UrsaTypography.titleSmall?.copyWith(color: c.textLowContrast)),
            const SizedBox(height: 8),
            ...activeConfigs.map((cfg) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ConfigCard(config: cfg, c: c),
                )),
            const SizedBox(height: 16),
          ],

          // All configs section
          Text('All Configs (${data.configs.length})',
              style: UrsaTypography.titleSmall?.copyWith(color: c.textLowContrast)),
          const SizedBox(height: 8),
          ...inactiveConfigs.map((cfg) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ConfigCard(config: cfg, c: c),
              )),

          // Loading indicator for next refresh
          const SizedBox(height: 8),
          Center(
            child: Text('Auto-refreshes every 30s',
                style: UrsaTypography.bodySmall?.copyWith(color: c.textLowContrast)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
