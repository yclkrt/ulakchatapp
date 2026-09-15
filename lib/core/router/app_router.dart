import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_page.dart';
import '../providers/firebase_providers.dart';
import '../widgets/main_screen.dart';

/// Route name & path definitions
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String main = '/';
}

/// Firebase auth durumunu GoRouter'a dinletmek için köprü.
/// authStateChanges emit ettiğinde GoRouter'ın `redirect`'i yeniden çalışır.
class _AuthRefreshListenable extends ChangeNotifier {
  StreamSubscription<dynamic>? _sub;

  void attach(Stream<dynamic> stream) {
    _sub?.cancel();
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// Global navigator key for top-level navigation
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'rootNav');

/// Provider for GoRouter instance managed by Riverpod
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthRefreshListenable();
  // authStateChanges her değiştiğinde redirect yeniden değerlendirilir.
  refresh.attach(ref.watch(firebaseAuthProvider).authStateChanges());

  // Provider dispose olunca listener'ı temizle.
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true,
    refreshListenable: refresh,
    redirect: (context, state) {
      final user = ref.read(firebaseAuthProvider).currentUser;
      final isLoggedIn = user != null;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      // Giriş yapmamış kullanıcı login dışında bir sayfadaysa -> login'e at.
      if (!isLoggedIn && !isOnLogin) return AppRoutes.login;
      // Giriş yapmış kullanıcı login'deyse -> ana ekrana at.
      if (isLoggedIn && isOnLogin) return AppRoutes.main;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.main,
        name: 'main',
        builder: (context, state) => const MainScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Sayfa bulunamadı: ${state.uri.toString()}'),
      ),
    ),
  );
});

