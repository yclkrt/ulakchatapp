import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier to manage application theme mode (Light, Dark, System).
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  // Varsayılan: light. Kullanıcı ayarlardan değiştirebilir.
  ThemeModeNotifier() : super(ThemeMode.light);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

/// Provider for accessing and changing the current ThemeMode.
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});
