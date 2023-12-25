import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

//! 3 - StateNotifierProvider - consume afuera
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {


  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  return LoginFormNotifier(
    loginUserCallback: loginUserCallback
  );
});


//! 2 - Implementacion de notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {

  final Function(String, String) loginUserCallback;

  // Constructor
  LoginFormNotifier({
  required this.loginUserCallback
  }): super(LoginFormState());

  // Método personalizado: onEmailChanged() 
  onEmailChanged (String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password])
    );
  }

  // Método personalizado: onPasswordChanged()
  onPasswordChanged (String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email])
    );
  }

  // Método personalizado publico
  onFormSubmit() async {
    _touchEveryField();
    if(!state.isValid) return;
    await loginUserCallback(state.email.value, state.password.value);
  }

  // Método personalizado privado
  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password])
    );
  }
  
}


//! 1 - Estado = State del provider
class LoginFormState {

  // Propiedades
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  // Constructor
  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure()
  });

  // Metodo personalizado copyWith()
  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  // Método personalizado sobrescrito toString()
  @override
  String toString() {
    // return '''LoginFormState:
    // isPosting =$isPosting,
    // isFormPosted = $isFormPosted,
    // isValid = $isValid,
    // email = $email,
    // password = $password''';
    String msg = '';
    msg += 'LoginFormState:';
    msg += '\n';
    msg += ' isPosting = $isPosting';
    msg += '\n';
    msg += ' isFormPosted = $isFormPosted';
    msg += '\n';
    msg += ' isValid = $isValid';
    msg += '\n';
    msg += ' email = $email';
    msg += '\n';
    msg += ' password = $password';
    msg += '\n';
    return msg;
  }
}