part of 'settings_cubit.dart';

sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class LogOutLooding extends SettingsState {}

final class LogOutLooded extends SettingsState {}

final class LogoutError extends SettingsState {
  final String message;
  LogoutError(this.message);
}
