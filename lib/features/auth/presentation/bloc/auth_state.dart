part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _AuthInitial;

  const factory AuthState.loading() = _AuthLoading;

  const factory AuthState.authenticated({
    required String userId,
    required String email,
    required String token,
    required String displayName,
  }) = _Authenticated;

  /// Sau khi đăng ký thành công — cần xác thực email trước khi login
  const factory AuthState.emailConfirmationRequired({
    required String email,
    required String message,
  }) = _EmailConfirmationRequired;

  const factory AuthState.error(String message) = _AuthError;
}
