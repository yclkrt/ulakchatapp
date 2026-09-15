import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ulakchatapp/core/features/auth/data/auth_controller.dart';
import 'package:ulakchatapp/core/features/auth/data/auth_repository.dart';
import 'package:ulakchatapp/core/providers/firebase_providers.dart';

//? AuthRepository sağlayıcısı
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

//? AuthController sağlayıcısı (UI bunu dinler).
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      return AuthController(ref.watch(authRepositoryProvider));
    });

/// Kullanıcının oturum durumu (login mi değil mi).
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return authState.valueOrNull != null;
});
