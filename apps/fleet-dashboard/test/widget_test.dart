import 'package:flutter_test/flutter_test.dart';
import 'package:fleet_dashboard/main.dart';

void main() {
  testWidgets('Fleet dashboard renders', (WidgetTester tester) async {
    await tester.pumpWidget(const FleetDashboardApp());
    expect(find.text('Fleet Dashboard'), findsOneWidget);
  });
}
