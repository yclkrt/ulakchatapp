import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences anahtarları
class AppPreferenceKeys {
  static const String themeMode = 'app_theme_mode';
  static const String language = 'app_language';
  static const String glassOpacity = 'app_glass_opacity';
}

/// SharedPreferences instance sağlayıcısı.
/// main() içerisinde SharedPreferences.getInstance() ile başlatılıp ProviderScope'a override edilmelidir.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider ProviderScope içinde başlatılmalıdır (overrideWithValue).',
  );
});

/// Seçili dili (tr, en vb.) SharedPreferences üzerinde tutan ve yöneten Notifier.
class AppLanguageNotifier extends StateNotifier<String> {
  final SharedPreferences? _prefs;
  static const String defaultLanguage = 'tr';

  AppLanguageNotifier(this._prefs)
      : super(_prefs?.getString(AppPreferenceKeys.language) ?? defaultLanguage);

  Future<void> setLanguage(String lang) async {
    state = lang;
    await _prefs?.setString(AppPreferenceKeys.language, lang);
  }
}

/// Uygulama dilini sağlayan StateNotifierProvider.
final appLanguageProvider =
    StateNotifierProvider<AppLanguageNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppLanguageNotifier(prefs);
});
