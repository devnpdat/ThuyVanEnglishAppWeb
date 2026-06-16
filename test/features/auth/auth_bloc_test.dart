// Auth BLoC Unit Tests
// Dùng freezed union pattern: AuthState.initial(), AuthState.authenticated(), etc.
//
// Bug fix coverage: displayName lấy từ JWT preferred_username, không hardcode 'Learner'
// JWT kFakeJwt có payload: {"preferred_username":"devdatnp","unique_name":"devdatnp","sub":"uid-123","email":"devdatnp@gmail.com"}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:english_learning_app/features/auth/data/repositories/auth_repository.dart';

final getIt = GetIt.instance;

class MockAuthRepository extends Mock implements AuthRepository {}

// Real JWT structure từ vanvy.up.railway.app — payload có preferred_username=devdatnp
// python3: base64url({"alg":"HS256"}).base64url({"preferred_username":"devdatnp","unique_name":"devdatnp","sub":"uid-123","email":"devdatnp@gmail.com"}).fakesig
const String kFakeJwt =
    'eyJhbGciOiJIUzI1NiJ9'
    '.eyJwcmVmZXJyZWRfdXNlcm5hbWUiOiJkZXZkYXRucCIsInVuaXF1ZV9uYW1lIjoiZGV2ZGF0bnAiLCJzdWIiOiJ1aWQtMTIzIiwiZW1haWwiOiJkZXZkYXRucEBnbWFpbC5jb20ifQ'
    '.fakesig';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Đăng ký fallback value cho mocktail khi dùng any() với custom types
    registerFallbackValue(LoginRequest(
      userNameOrEmailAddress: 'fallback',
      password: 'fallback',
    ));
  });

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

    // ── Bug fix tests: displayName từ JWT, không hardcode 'Learner' ───────────

    test('login thành công → displayName = preferred_username từ JWT', () async {
      when(() => mockRepo.login(any())).thenAnswer((_) async => LoginResponse(
            success: true,
            accessToken: kFakeJwt,
          ));
      when(() => mockRepo.getProfile()).thenAnswer((_) async => UserProfileResponse(
            id: 'uid-123',
            userName: 'devdatnp',
            emailAddress: 'devdatnp@gmail.com',
          ));
      when(() => mockRepo.saveUserLocally(any(), any(), any(), any()))
          .thenAnswer((_) async {});

      final bloc = AuthBloc();
      bloc.add(const AuthEvent.login(
        email: 'devdatnp',
        password: 'M1nhkh@nh1',
      ));
      await Future.delayed(const Duration(milliseconds: 400));

      bloc.state.maybeWhen(
        authenticated: (userId, email, token, displayName) {
          // Phải là 'devdatnp' từ JWT, KHÔNG phải 'Learner' hay email
          expect(displayName, equals('devdatnp'));
          expect(displayName, isNot(equals('Learner')));
          expect(displayName, isNot(contains('@')));
        },
        orElse: () => fail('Expected authenticated state, got: ${bloc.state}'),
      );
      bloc.close();
    });

    test('login — getProfile fail → vẫn lấy username từ JWT (không fallback email)', () async {
      when(() => mockRepo.login(any())).thenAnswer((_) async => LoginResponse(
            success: true,
            accessToken: kFakeJwt,
          ));
      // getProfile thất bại
      when(() => mockRepo.getProfile()).thenThrow(Exception('Network error'));
      when(() => mockRepo.saveUserLocally(any(), any(), any(), any()))
          .thenAnswer((_) async {});

      final bloc = AuthBloc();
      bloc.add(const AuthEvent.login(
        email: 'devdatnp@gmail.com',
        password: 'M1nhkh@nh1',
      ));
      await Future.delayed(const Duration(milliseconds: 400));

      bloc.state.maybeWhen(
        authenticated: (userId, email, token, displayName) {
          // Dù getProfile fail, vẫn phải lấy được 'devdatnp' từ JWT
          expect(displayName, equals('devdatnp'));
          expect(displayName, isNot(equals('Learner')));
        },
        orElse: () => fail('Expected authenticated state, got: ${bloc.state}'),
      );
      bloc.close();
    });
  });
}
