import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ulakchatapp/main.dart';

void main() {
  testWidgets('App smoke test - verifies bottom navigation and chats page render', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Chats tab / AppBar title is present
    expect(find.text('Sohbetler'), findsWidgets);
  });
}
