import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
      final key = utf8.decode(message!.buffer.asUint8List());
      if (key == 'assets/lang/tr.json' || key == 'assets/lang/en.json') {
        final data = utf8.encode(jsonEncode({
          'chats': 'Sohbetler',
          'settings': 'Ayarlar',
          'language': 'Dil',
          'turkish': 'Türkçe',
          'english': 'İngilizce',
        }));
        return ByteData.view(Uint8List.fromList(data).buffer);
      }
      return null;
    });
  });

  testWidgets('App smoke test - verifies bottom navigation and chats page render', (WidgetTester tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: LingoWrapper(
          defaultLocale: 'tr',
          supportedLocales: ['tr', 'en'],
          assetsPath: 'assets/lang',
          child: ProviderScope(
            child: MyApp(),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Sohbetler'), findsWidgets);
  });
}
