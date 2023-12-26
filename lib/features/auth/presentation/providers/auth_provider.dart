import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final KeyValueStorageServiceImpl keyValueStorageService;


  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService, 
  }): super(AuthState()){
    checkAuthStatus();
  }

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

  void checkAuthStatus() async {
    // verificar token
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }

  }

  void _setLoggedUser(User user) async {

    // guardar token en local
    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {

    // limpiar token
    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
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