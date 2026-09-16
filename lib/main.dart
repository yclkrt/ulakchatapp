import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/firebase_options.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Önce --dart-define key'leriyle (tavsiye edilen, güvenli yol) dene.
  // 2) Flag unutulduysa: mobil/masaüstünde native dosyalardan
  //    (google-services.json / GoogleService-Info.plist) çalışmayı dene.
  //    Bu dosyalar yerelde sende var, sadece GitHub'a push'lanmıyor.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on StateError catch (e) {
    if (!e.message.contains('--dart-define')) rethrow;
    debugPrint('⚠️ --dart-define bulunamadı, native config deneniyor: $e');
    try {
      // Native dosyalardan okur (Android/iOS/macOS). Web'de çalışmaz.
      await Firebase.initializeApp();
      debugPrint('✅ Native config ile Firebase başlatıldı.');
    } catch (nativeError) {
      // Ne dart-define ne native config var → kullanıcıya yol gösteren ekran.
      runApp(_MissingFirebaseConfigApp(details: '$e'));
      return;
    }
  }

  runApp(
    const Directionality(
      textDirection: TextDirection.ltr,
      child: LingoWrapper(
        defaultLocale: 'tr',
        supportedLocales: ['tr', 'en'],
        assetsPath: 'assets/lang',
        child: ProviderScope(child: MyApp()),
      ),
    ),
  );
}

/// --dart-define verilmediğinde ve native config de yoksa gösterilen
/// yardımcı ekran (özellikle ilk kurulumda yol gösterir, kırmızı ekran
/// yerine ne yapılacağını anlatır).
class _MissingFirebaseConfigApp extends StatelessWidget {
  final String details;
  const _MissingFirebaseConfigApp({required this.details});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase kurulumu eksik')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Icon(Icons.warning_amber_rounded, size: 56),
              const SizedBox(height: 12),
              const Text(
                'Firebase key\'leri yüklenemedi.\n\n'
                'VS Code\'da F5 ile (üstteki listede "Flutter (local Firebase keys)" '
                'seçiliyken) çalıştırın.\n\n'
                'Terminalden çalıştırıyorsanız:',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFF0F0F0),
                child: const SelectableText(
                  'flutter run --dart-define-from-file=.env.local',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '.env.local yoksa: FIREBASE_SETUP.md adım 1\'e bakın '
                '(cp .env.example .env.local + Firebase Console\'dan doldurun).',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Teknik detay'),
                children: [
                  SelectableText(details,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'UlakChat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
