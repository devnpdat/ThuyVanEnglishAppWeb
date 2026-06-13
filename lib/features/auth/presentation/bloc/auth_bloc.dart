import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:english_learning_app/features/auth/data/repositories/auth_repository.dart';
import 'package:english_learning_app/core/di/service_locator.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

/// AuthBloc — kết nối với API thật
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? getIt<AuthRepository>(),
        super(const AuthState.initial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthCheckStatusEvent>(_onCheckStatus);
  }

  /// Login với username/email và password thật
  Future<void> _onLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final response = await _authRepository.login(
        LoginRequest(
          userNameOrEmailAddress: event.email,
          password: event.password,
        ),
      );

      // Lấy profile để có userId, displayName
      await _authRepository.setAuthToken(response.accessToken);
      UserProfileResponse? profile;
      try {
        profile = await _authRepository.getProfile();
      } catch (_) {
        // Profile call failed — vẫn login được, dùng email làm displayName
      }

      await _authRepository.saveUserLocally(
        response.accessToken,
        profile?.id ?? '',
        profile?.emailAddress ?? event.email,
        profile?.displayName ?? event.email,
      );

      emit(AuthState.authenticated(
        userId: profile?.id ?? '',
        email: profile?.emailAddress ?? event.email,
        token: response.accessToken,
        displayName: profile?.displayName ?? event.email,
      ));
    } catch (e) {
      emit(AuthState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Register rồi tự động login
  Future<void> _onRegister(
      AuthRegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      // Bước 1: Register
      await _authRepository.register(
        RegisterRequest(
          userName: event.email.split('@').first.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_'),
          emailAddress: event.email,
          password: event.password,
        ),
      );

      // Bước 2: Auto-login sau khi register
      final loginResp = await _authRepository.login(
        LoginRequest(
          userNameOrEmailAddress: event.email,
          password: event.password,
        ),
      );

      await _authRepository.setAuthToken(loginResp.accessToken);
      UserProfileResponse? profile;
      try {
        profile = await _authRepository.getProfile();
      } catch (_) {}

      await _authRepository.saveUserLocally(
        loginResp.accessToken,
        profile?.id ?? '',
        event.email,
        event.displayName.isNotEmpty ? event.displayName : event.email,
      );

      emit(AuthState.authenticated(
        userId: profile?.id ?? '',
        email: event.email,
        token: loginResp.accessToken,
        displayName: event.displayName.isNotEmpty ? event.displayName : event.email,
      ));
    } catch (e) {
      emit(AuthState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Logout — xóa token
  Future<void> _onLogout(
      AuthLogoutEvent event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.clearLocalAuth();
    } catch (_) {}
    emit(const AuthState.initial());
  }

  /// Kiểm tra token đang lưu khi app khởi động
  Future<void> _onCheckStatus(
      AuthCheckStatusEvent event, Emitter<AuthState> emit) async {
    try {
      final stored = await _authRepository.getStoredUser();
      if (stored != null) {
        // Có token — restore session
        await _authRepository.setAuthToken(stored['token']!);
        emit(AuthState.authenticated(
          userId: stored['userId']!,
          email: stored['email']!,
          token: stored['token']!,
          displayName: stored['displayName']!,
        ));
      } else {
        emit(const AuthState.initial());
      }
    } catch (_) {
      emit(const AuthState.initial());
    }
  }
}

// Helper extension on AuthRepository to expose setAuthToken publicly
extension on AuthRepository {
  Future<void> setAuthToken(String token) async {
    // Only set the HTTP client token — don't overwrite userId/email/displayName with empty strings
    // Use HttpClient directly via saveUserLocally with preserved existing values
    final existing = await getStoredUser();
    await saveUserLocally(
      token,
      existing?['userId'] ?? '',
      existing?['email'] ?? '',
      existing?['displayName'] ?? '',
    );
  }
}
