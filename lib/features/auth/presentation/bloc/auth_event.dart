part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.login({
    required String email,
    required String password,
  }) = AuthLoginEvent;

  const factory AuthEvent.register({
    required String email,
    required String password,
    required String displayName,
  }) = AuthRegisterEvent;

  const factory AuthEvent.logout() = AuthLogoutEvent;

  const factory AuthEvent.checkStatus() = AuthCheckStatusEvent;
}
