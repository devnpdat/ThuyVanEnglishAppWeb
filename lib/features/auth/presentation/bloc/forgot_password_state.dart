part of 'forgot_password_bloc.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState.initial() = _Initial;
  const factory ForgotPasswordState.loading() = _Loading;

  /// Gửi email thành công
  const factory ForgotPasswordState.codeSent() = _CodeSent;

  /// Reset password thành công
  const factory ForgotPasswordState.resetSuccess() = _ResetSuccess;

  const factory ForgotPasswordState.error(String message) = _Error;
}
