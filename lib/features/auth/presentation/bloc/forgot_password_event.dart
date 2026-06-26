part of 'forgot_password_bloc.dart';

@freezed
class ForgotPasswordEvent with _$ForgotPasswordEvent {
  /// Gửi email reset password
  const factory ForgotPasswordEvent.sendCode({
    required String email,
  }) = ForgotPasswordSendCodeEvent;

  /// Đặt lại mật khẩu với token từ email link
  const factory ForgotPasswordEvent.resetPassword({
    required String userId,
    required String resetToken,
    required String password,
  }) = ForgotPasswordResetEvent;
}
