import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  return AuthNotifier(
    authRepository: authRepository
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({
    required this.authRepository
  }): super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));//realentización para ver loading
    // if (kDebugMode) print('>> [auth_provider.dart] email: $email | password: $password');
    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    }
    on CustomError catch (e) {
       if (kDebugMode) print('>> [auth_provider] CustomError (e): ${e.message}');
       logout(e.message);
     }
     catch (e) {
      if (kDebugMode) print('>>> [auth_provider] catch (e): $e');
      logout('>>> Error: no controlado');
    }
    //state = state.copyWith(authStatus: AuthStatus.authenticated, user: user);
  }

  void registerUser(String email, String password, String fullName) async {}

  void checkAuthStatus() async {}

  Future<void> logout([String? errorMessage]) async {
    // todo: limpiar token
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }

  void _setLoggedUser(User user) {
    // todo: guardar token en local
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      // errorMessage: '',
    );
  }

}

/// Valores: checking, authenticated, notAuthenticated
enum AuthStatus {checking, authenticated, notAuthenticated}

class AuthState {

  // Propiedades
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  // Constructor
  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  // Metodo personalizado
  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}