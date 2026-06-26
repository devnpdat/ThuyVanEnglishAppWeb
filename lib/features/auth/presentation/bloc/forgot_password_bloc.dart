import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:english_learning_app/features/auth/data/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

part 'forgot_password_bloc.freezed.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

final _getIt = GetIt.instance;

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? _getIt<AuthRepository>(),
        super(const ForgotPasswordState.initial()) {
    on<ForgotPasswordSendCodeEvent>(_onSendCode);
    on<ForgotPasswordResetEvent>(_onResetPassword);
  }

  Future<void> _onSendCode(
    ForgotPasswordSendCodeEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordState.loading());
    try {
      await _authRepository.sendPasswordResetCode(event.email);
      emit(const ForgotPasswordState.codeSent());
    } catch (e) {
      emit(ForgotPasswordState.error(
        e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> _onResetPassword(
    ForgotPasswordResetEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordState.loading());
    try {
      await _authRepository.resetPassword(
        userId: event.userId,
        resetToken: event.resetToken,
        password: event.password,
      );
      emit(const ForgotPasswordState.resetSuccess());
    } catch (e) {
      emit(ForgotPasswordState.error(
        e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }
}
