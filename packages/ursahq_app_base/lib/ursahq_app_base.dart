/// UrsaHQ App Base — canonical app wrapper for all UrsaHQ Flutter web UIs.
///
/// Usage:
/// ```dart
/// void main() => runApp(const UrsaApp(home: MyHomeWidget()));
/// ```
///
/// With GoRouter:
/// ```dart
/// void main() => runApp(UrsaApp.router(routerConfig: _router));
/// ```
library ursahq_app_base;

export 'src/ursa_app.dart';
export 'src/season_aware_app.dart';
