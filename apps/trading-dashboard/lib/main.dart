import 'package:flutter/material.dart';
import 'package:ursahq_app_base/ursahq_app_base.dart';

import 'pages/dashboard_page.dart';

void main() => runApp(const SeasonAwareApp(
  title: 'UrsaHQ Trading',
  home: DashboardPage(),
));
