import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingo_easy/lingo_easy.dart';
import 'package:ulakchatapp/firebase_options.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

/// App Check debug token'ı (sadece --dart-define ile verilirse kullanılır).
/// Örn: flutter run --dart-define-from-file=.env.local
/// (.env.local içine "APP_CHECK_DEBUG_TOKEN": "XXXX-..." ekle)
const _appCheckDebugToken = String.fromEnvironment('APP_CHECK_DEBUG_TOKEN');

Future<void> _activateAppCheck() async {
  try {
    if (kIsWeb) {
      // Web: reCAPTCHA v3 site key Firebase Console > App Check > Apps > Web
      // uygulamasından alınır. Secret değil, site key herkese açıktır.
      // Şimdilik debug modda sorunsuz çalışsın diye pas geçiyoruz;
      // web'e çıkarken APP_CHECK_WEB_SITE_KEY tanımla.
      const siteKey = String.fromEnvironment('APP_CHECK_WEB_SITE_KEY');
      if (siteKey.isEmpty) {
        debugPrint(
          '⚠️ APP_CHECK_WEB_SITE_KEY yok → Web App Check pas geçildi. '
          'Tarayıcıda Firebase çalışır ama App Check koruması olmaz.',
        );
        return;
      }
      await FirebaseAppCheck.instance.activate(
        providerWeb: ReCaptchaV3Provider(siteKey),
      );
      debugPrint('✅ App Check (Web reCAPTCHA v3) aktif.');
      return;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Release: Play Integrity (Google Play'in cihaz doğrulaması).
        // Debug: APP_CHECK_DEBUG_TOKEN verildiyse debug provider.
        if (_appCheckDebugToken.isNotEmpty) {
          await FirebaseAppCheck.instance.activate(
            providerAndroid: AndroidDebugProvider(debugToken: _appCheckDebugToken),
          );
          debugPrint('✅ App Check (Android DEBUG) aktif.');
        } else {
          await FirebaseAppCheck.instance.activate(
            providerAndroid: const AndroidPlayIntegrityProvider(),
          );
          debugPrint('✅ App Check (Android Play Integrity) aktif.');
        }
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        // Release: App Attest (varsa) → DeviceCheck fallback.
        // Debug: APP_CHECK_DEBUG_TOKEN verildiyse debug provider.
        if (_appCheckDebugToken.isNotEmpty) {
          await FirebaseAppCheck.instance.activate(
            providerApple: AppleDebugProvider(debugToken: _appCheckDebugToken),
          );
          debugPrint('✅ App Check (Apple DEBUG) aktif.');
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          await FirebaseAppCheck.instance.activate(
            providerApple:
                const AppleAppAttestWithDeviceCheckFallbackProvider(),
          );
          debugPrint('✅ App Check (iOS App Attest + DeviceCheck) aktif.');
        } else {
          await FirebaseAppCheck.instance.activate(
            providerApple: const AppleDeviceCheckProvider(),
          );
          debugPrint('✅ App Check (macOS DeviceCheck) aktif.');
        }
      case TargetPlatform.windows:
        // Windows'ta sadece debug provider desteklenir.
        if (_appCheckDebugToken.isNotEmpty) {
          await FirebaseAppCheck.instance.activate(
            providerWindows: WindowsDebugProvider(debugToken: _appCheckDebugToken),
          );
          debugPrint('✅ App Check (Windows DEBUG) aktif.');
        } else {
          debugPrint(
            '⚠️ Windows App Check token yok → pas geçildi. '
            'APP_CHECK_DEBUG_TOKEN tanımla (bkz. FIREBASE_SETUP.md).',
          );
        }
      default:
        debugPrint('⚠️ Bu platformda App Check desteklenmiyor (linux).');
    }
  } catch (e) {
    // App Check hatası uygulamayı ÇÖKERTMEMELİ — sadece logla.
    // (Örn: henüz Console'da uygulama kaydedilmediyse.)
    debugPrint('⚠️ App Check aktive edilemedi (uygulama çalışmaya devam eder): $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Önce --dart-define key'leriyle (tavsiye edilen, güvenli yol) dene.
  // 2) Flag unutulduysa: mobil/masaüstünde native dosyalardan
  //    (google-services.json / GoogleService-Info.plist) çalışmayı dene.
  //    Bu dosyalar yerelde sende var, sadece GitHub'a push'lanmıyor.
  bool firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
  } on StateError catch (e) {
    if (!e.message.contains('--dart-define')) rethrow;
    debugPrint('⚠️ --dart-define bulunamadı, native config deneniyor: $e');
    try {
      // Native dosyalardan okur (Android/iOS/macOS). Web'de çalışmaz.
      await Firebase.initializeApp();
      firebaseReady = true;
      debugPrint('✅ Native config ile Firebase başlatıldı.');
    } catch (nativeError) {
      // Ne dart-define ne native config var → kullanıcıya yol gösteren ekran.
      runApp(_MissingFirebaseConfigApp(details: '$e'));
      return;
    }
  }

  // Firebase hazırsa App Check'i aktifleştir (bot/sahte istemci koruması).
  if (firebaseReady) {
    await _activateAppCheck();
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
