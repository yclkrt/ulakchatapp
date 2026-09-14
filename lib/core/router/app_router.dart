import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/chats/presentation/chats_page.dart';
import '../features/settings/presentation/settings_page.dart';

/// Route name & path definitions
class AppRoutes {
  AppRoutes._();

  static const String chats = '/';
  static const String settings = '/settings';
}

/// Global navigator key for top-level navigation
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'rootNav');

/// Provider for GoRouter instance managed by Riverpod
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.chats,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.chats,
        name: 'chats',
        builder: (context, state) => const ChatsPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Sayfa bulunamadı: ${state.uri.toString()}'),
      ),
    ),
  );
});
