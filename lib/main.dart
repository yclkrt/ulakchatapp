import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ulakchatapp/firebase_options.dart';

import 'core/providers/preferences_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SharedPreferences'ı başlat
  final prefs = await SharedPreferences.getInstance();
  final initialLocale = prefs.getString(AppPreferenceKeys.language) ?? 'tr';

  // ÖNCE native config dene (google-services.json / GoogleService-Info.plist).
  // Bu dosyalar sende yerelde var ve F5 / Xcode ile her zaman çalışır.
  // --dart-define key'leri varsa FirebaseOptions ile tekrar dene (CI/güvenli yol).
  // Not: "duplicate-app" hatası = zaten başlatılmış demektir, devam et.
  try {
    await Firebase.initializeApp();
    debugPrint('✅ Firebase native config ile başlatıldı.');
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      debugPrint('✅ Firebase zaten başlatılmış (duplicate-app).');
    } else {
      debugPrint('⚠️ Native init başarısız (${e.code}): ${e.message}');
    }
  } catch (e) {
    debugPrint('⚠️ Native init başarısız: $e');
  }

  // Henüz başlatılmadıysa dart-define opsiyonlarıyla dene.
  if (Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ Firebase dart-define config ile başlatıldı.');
    } catch (e) {
      debugPrint('❌ Firebase başlatılamadı: $e');
      final missingDefine =
          e is StateError && e.message.contains('--dart-define');
      runApp(
        missingDefine
            ? _MissingFirebaseConfigApp(details: '$e')
            : _FirebaseErrorApp(details: '$e'),
      );
      return;
    }
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LingoWrapper(
          defaultLocale: initialLocale,
          supportedLocales: const ['tr', 'en'],
          assetsPath: 'assets/lang',
          // Lingo çevirileri yüklenirken gösterilen ekran.
          // ÖNEMLİ: Burada Scaffold KULLANMA! Çünkü bu aşamada henüz
          // MaterialApp/MediaQuery yok. Scaffold -> "No MediaQuery ancestor"
          // hatasıyla uygulamayı anında kapatır (iOS'ta siyah ekran + kapanma).
          loadingWidget: const Directionality(
            textDirection: TextDirection.ltr,
            child: Center(child: CircularProgressIndicator()),
          ),
          child: const MyApp(),
        ),
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
                  SelectableText(details, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Firebase'in --dart-define dışı herhangi bir sebeple (duplicate-app,
/// bozuk plist, vs.) başlatılamaması durumunda gösterilen genel hata ekranı.
class _FirebaseErrorApp extends StatelessWidget {
  final String details;
  const _FirebaseErrorApp({required this.details});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase başlatılamadı')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              const Icon(Icons.cloud_off_rounded, size: 56),
              const SizedBox(height: 12),
              const Text(
                'Uygulama Firebase\'e bağlanamadı, bu yüzden güvenli '
                'hata ekranı gösteriliyor (sessizce kapanma yok).\n\n'
                'Genelde sebep: bozuk GoogleService-Info.plist, '
                'yanlış bundle id veya ağ sorunudur.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Teknik detay'),
                children: [
                  SelectableText(details, style: const TextStyle(fontSize: 12)),
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

    return AdaptiveApp.router(
      title: 'UlakChat',
      routerConfig: router,
      themeMode: themeMode,
      materialLightTheme: AppTheme.lightTheme,
      materialDarkTheme: AppTheme.darkTheme,
      cupertinoLightTheme: AppTheme.cupertinoLightTheme,
      cupertinoDarkTheme: AppTheme.cupertinoDarkTheme,
      builder: (context, child) => ScaffoldMessenger(child: child!),
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      material: (context, platform) =>
          const MaterialAppData(debugShowCheckedModeBanner: false),
      cupertino: (context, platform) =>
          const CupertinoAppData(debugShowCheckedModeBanner: false),
    );
  }
}
