import 'package:roadmap/domain/auth/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class PasswordResetEmailSent extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
