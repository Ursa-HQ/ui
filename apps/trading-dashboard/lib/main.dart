import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(const TradingDashboardApp());
}

class TradingDashboardApp extends StatelessWidget {
  const TradingDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UrsaHQ Trading',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: UrsaTheme.dark(),
      home: const DashboardPage(),
    );
  }
}
