/// UrsaHQ Sweep Pairs Dashboard
///
/// Live monitor for the sweep_pairs backtesting binary — shows current
/// signal progress, per-pair results, and aggregate stats for completed
/// signals. Uses the ursahq_design_system for consistent theming.
library;

import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(const SweepDashboardApp());
}

class SweepDashboardApp extends StatelessWidget {
  const SweepDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UrsaHQ Sweep',
      debugShowCheckedModeBanner: false,
      theme: UrsaTheme.dark(season: Season.winter),
      home: const SweepDashboardPage(),
    );
  }
}
