// Auth BLoC Unit Tests
// Dùng freezed union pattern: AuthState.initial(), AuthState.authenticated(), etc.

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:english_learning_app/features/auth/data/repositories/auth_repository.dart';
import 'package:english_learning_app/core/di/service_locator.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthBloc — state transitions', () {
    late MockAuthRepository mockRepo;

    setUp(() {
      mockRepo = MockAuthRepository();
      if (getIt.isRegistered<AuthRepository>()) {
        getIt.unregister<AuthRepository>();
      }
      getIt.registerSingleton<AuthRepository>(mockRepo);
    });

    tearDown(() {
      if (getIt.isRegistered<AuthRepository>()) {
        getIt.unregister<AuthRepository>();
      }
    });

    test('initial state là AuthState.initial()', () {
      final bloc = AuthBloc();
      expect(bloc.state, equals(const AuthState.initial()));
      bloc.close();
    });

    test('checkStatus — không có token → giữ initial', () async {
      when(() => mockRepo.getStoredUser()).thenAnswer((_) async => null);

      final bloc = AuthBloc();
      bloc.add(const AuthEvent.checkStatus());
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, equals(const AuthState.initial()));
      bloc.close();
    });

    test('checkStatus — có token → AuthState.authenticated', () async {
      when(() => mockRepo.getStoredUser()).thenAnswer((_) async => {
            'token': 'valid_token_123',
            'userId': 'uid-1',
            'email': 'user@test.com',
            'displayName': 'Test User',
          });
      when(() => mockRepo.saveUserLocally(any(), any(), any(), any()))
          .thenAnswer((_) async {});

      final bloc = AuthBloc();
      bloc.add(const AuthEvent.checkStatus());
      await Future.delayed(const Duration(milliseconds: 300));

      bloc.state.maybeWhen(
        authenticated: (userId, email, token, displayName) {
          expect(userId, equals('uid-1'));
          expect(email, equals('user@test.com'));
          expect(token, equals('valid_token_123'));
        },
        orElse: () => fail('Expected authenticated state, got: ${bloc.state}'),
      );
      bloc.close();
    });

    test('logout → AuthState.initial()', () async {
      when(() => mockRepo.clearLocalAuth()).thenAnswer((_) async {});

      final bloc = AuthBloc();
      bloc.add(const AuthEvent.logout());
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, equals(const AuthState.initial()));
      bloc.close();
    });
  });
}
