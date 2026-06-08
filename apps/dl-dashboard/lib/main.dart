import 'package:flutter/material.dart';
import 'package:ursahq_design_system/ursahq_design_system.dart';
import 'pages/dashboard_page.dart';

void main() {
  runApp(const DlDashboardApp());
}

class DlDashboardApp extends StatelessWidget {
  const DlDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UrsaHQ Downloader',
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      darkTheme: UrsaTheme.dark(),
      home: const DashboardPage(),
    );
  }
}
