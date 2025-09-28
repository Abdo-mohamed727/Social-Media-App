part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}

final class AuthSignedOut extends AuthState {}

final class AuthWithGoogleLooding extends AuthState {}

final class AuthWithGoogleSuccess extends AuthState {}

final class AuthWithGoogleError extends AuthState {
  final String message;
  AuthWithGoogleError(this.message);
}
