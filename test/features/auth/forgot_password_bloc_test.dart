// ForgotPassword BLoC Tests
// Mocks AuthRepository và verify state machine transitions.
// States: initial(), loading(), codeSent(), resetSuccess(), error(msg)

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:english_learning_app/features/auth/data/repositories/auth_repository.dart';

final getIt = GetIt.instance;

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
    getIt.reset(); // clear DI registry
  });

  // ─── ForgotPasswordBloc Init ─────────────────────────────────────────────

  group('ForgotPasswordBloc — sendCode', () {
    test('initial state is ForgotPasswordState.initial()', () {
      final bloc = ForgotPasswordBloc(authRepository: mockRepo);
      expect(bloc.state, const ForgotPasswordState.initial());
      bloc.close();
    });

    test('emits [loading, codeSent] when sendCode succeeds', () async {
      when(() => mockRepo.sendPasswordResetCode(any()))
          .thenAnswer((_) async {});

      final bloc = ForgotPasswordBloc(authRepository: mockRepo);

      bloc.add(const ForgotPasswordEvent.sendCode(email: 'test@example.com'));

      // Expect: initial → loading → codeSent
      await expectLater(
        bloc.stream,
        emitsInOrder([
          const ForgotPasswordState.loading(),
          const ForgotPasswordState.codeSent(),
        ]),
      );

      bloc.close();
    });

    test('emits [loading, error] when sendCode fails', () async {
      when(() => mockRepo.sendPasswordResetCode(any()))
          .thenThrow(Exception('Email không tồn tại'));

      final bloc = ForgotPasswordBloc(authRepository: mockRepo);

      bloc.add(const ForgotPasswordEvent.sendCode(email: 'invalid@test.com'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const ForgotPasswordState.loading(),
          const ForgotPasswordState.error('Email không tồn tại'),
        ]),
      );

      bloc.close();
    });
  });

  // ─── ForgotPasswordBloc resetPassword ────────────────────────────────────

  group('ForgotPasswordBloc — resetPassword', () {
    test('emits [loading, resetSuccess] when reset succeeds', () async {
      when(() => mockRepo.resetPassword(
            userId: any(named: 'userId'),
            resetToken: any(named: 'resetToken'),
            password: any(named: 'password'),
          )).thenAnswer((_) async {});

      final bloc = ForgotPasswordBloc(authRepository: mockRepo);

      bloc.add(const ForgotPasswordEvent.resetPassword(
        userId: 'uid-123',
        resetToken: 'tok-abc',
        password: 'NewPass123!',
      ));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const ForgotPasswordState.loading(),
          const ForgotPasswordState.resetSuccess(),
        ]),
      );

      bloc.close();
    });

    test('emits [loading, error] when reset fails', () async {
      when(() => mockRepo.resetPassword(
            userId: any(named: 'userId'),
            resetToken: any(named: 'resetToken'),
            password: any(named: 'password'),
          )).thenThrow(Exception('Token không hợp lệ'));

      final bloc = ForgotPasswordBloc(authRepository: mockRepo);

      bloc.add(const ForgotPasswordEvent.resetPassword(
        userId: 'uid-123',
        resetToken: 'bad-token',
        password: 'NewPass123!',
      ));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          const ForgotPasswordState.loading(),
          const ForgotPasswordState.error('Token không hợp lệ'),
        ]),
      );

      bloc.close();
    });
  });
}
