import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roadmap/domain/auth/entities/user.dart' as app_user;
import 'package:roadmap/domain/auth/usecases/change_password_usecase.dart';
import 'package:roadmap/domain/auth/usecases/login_usecase.dart';
import 'package:roadmap/domain/auth/usecases/logout_usecase.dart';
import 'package:roadmap/domain/auth/usecases/register_usecase.dart';
import 'package:roadmap/domain/auth/usecases/reset_password_usecase.dart';
import 'package:roadmap/domain/auth/usecases/sign_in_with_google_usecase.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LogoutUseCase logoutUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.resetPasswordUseCase,
    required this.logoutUseCase,
    required this.changePasswordUseCase,
    required this.signInWithGoogleUseCase,
  }) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final user = await loginUseCase(email: email, password: password);
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      final user = await registerUseCase(
        name: name,
        email: email,
        password: password,
      );

      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());

    try {
      await resetPasswordUseCase(email: email);
      emit(PasswordResetEmailSent());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await logoutUseCase();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(AuthLoading());

    try {
      await changePasswordUseCase(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      emit(PasswordChanged());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());

    try {
      final user = await signInWithGoogleUseCase();
      emit(Authenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void updateCurrentUserName(String name) {
    final currentState = state;
    if (currentState is! Authenticated) return;

    emit(
      Authenticated(
        app_user.User(
          id: currentState.user.id,
          email: currentState.user.email,
          name: name,
        ),
      ),
    );
  }
}
