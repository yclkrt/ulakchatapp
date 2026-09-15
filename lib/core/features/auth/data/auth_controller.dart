// lib/features/auth/application/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AsyncValue.data(null));

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
    });
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.signIn(email: email, password: password);
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.signOut());
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.sendPasswordReset(email));
  }

  /// Hata mesajlarını Türkçeleştirir.
  static String errorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'Bu e-posta adresi zaten kullanılıyor.';
        case 'invalid-email':
          return 'Geçersiz e-posta adresi.';
        case 'weak-password':
          return 'Şifre çok zayıf (en az 6 karakter).';
        case 'user-not-found':
          return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
        case 'wrong-password':
          return 'Şifre hatalı.';
        case 'invalid-credential':
          return 'E-posta veya şifre hatalı.';
        case 'user-disabled':
          return 'Bu hesap devre dışı bırakılmış.';
        case 'too-many-requests':
          return 'Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin.';
        case 'operation-not-allowed':
          return 'E-posta/şifre ile giriş bu projede etkin değil. Firebase Console > Authentication > Sign-in method bölümünden Email/Password sağlayıcısını etkinleştirin.';
        case 'network-request-failed':
          return 'Ağ hatası. İnternet bağlantınızı kontrol edin.';
        default:
          return 'Bir hata oluştu: ${error.code}';
      }
    }
    return 'Beklenmeyen bir hata oluştu.';
  }
}
