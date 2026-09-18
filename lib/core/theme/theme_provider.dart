import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/preferences_provider.dart';

/// Notifier to manage application theme mode (Light, Dark, System) with SharedPreferences persistence.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final SharedPreferences? _prefs;

  ThemeModeNotifier(this._prefs) : super(_loadInitialTheme(_prefs));

  static ThemeMode _loadInitialTheme(SharedPreferences? prefs) {
    if (prefs == null) return ThemeMode.light;
    final saved = prefs.getString(AppPreferenceKeys.themeMode);
    switch (saved) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    _prefs?.setString(AppPreferenceKeys.themeMode, mode.name);
  }

  void toggleTheme(bool isDark) {
    final mode = isDark ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(mode);
  }
}

/// Provider for accessing and changing the current ThemeMode.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeModeNotifier(prefs);
});

/// Notifier to manage liquid glass bottom menu opacity on iOS with SharedPreferences persistence.
class GlassOpacityNotifier extends StateNotifier<double> {
  final SharedPreferences? _prefs;
  static const double defaultOpacity = 0.19;

  GlassOpacityNotifier(this._prefs)
      : super(
          _prefs?.getDouble(AppPreferenceKeys.glassOpacity) ?? defaultOpacity,
        );

  void setOpacity(double opacity) {
    state = opacity;
    _prefs?.setDouble(AppPreferenceKeys.glassOpacity, opacity);
  }
}

/// Liquid glass bottom menü saydamlık değeri provider'ı (varsayılan: 0.19).
final glassOpacityProvider =
    StateNotifierProvider<GlassOpacityNotifier, double>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return GlassOpacityNotifier(prefs);
});
