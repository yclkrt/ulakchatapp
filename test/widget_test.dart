import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulakchatapp/main.dart';

void main() {
  testWidgets('App smoke test - verifies UlakChat root page renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Initial pump and settle for GoRouter
    await tester.pumpAndSettle();

    // Verify that UlakChat AppBar title is present
    expect(find.text('UlakChat'), findsOneWidget);
  });
}
