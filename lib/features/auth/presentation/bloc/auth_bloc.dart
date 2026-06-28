import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:english_learning_app/features/auth/data/repositories/auth_repository.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:get_it/get_it.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

final _getIt = GetIt.instance;

/// AuthBloc — kết nối với API thật
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({AuthRepository? authRepository})
      : _authRepository = authRepository ?? _getIt<AuthRepository>(),
        super(const AuthState.initial()) {
    on<AuthLoginEvent>(_onLogin);
    on<AuthRegisterEvent>(_onRegister);
    on<AuthSocialLoginEvent>(_onSocialLogin);
    on<AuthLogoutEvent>(_onLogout);
    on<AuthCheckStatusEvent>(_onCheckStatus);
  }

  /// Parse JWT để lấy preferred_username (hoặc unique_name / sub)
  static String _parseUsernameFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return '';
      String payload = parts[1].replaceAll('-', '+').replaceAll('_', '/');
      while (payload.length % 4 != 0) payload += '=';
      final decoded = utf8.decode(base64.decode(payload));
      final Map<String, dynamic> claims = jsonDecode(decoded);
      // Ưu tiên: preferred_username → unique_name → sub
      return claims['preferred_username'] as String? ??
          claims['unique_name'] as String? ??
          claims['sub'] as String? ??
          '';
    } catch (_) {
      return '';
    }
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

      final token = response.accessToken ?? '';
      if (token.isEmpty) {
        throw Exception('Sai email hoặc mật khẩu, hoặc email chưa được xác nhận');
      }

      // Lấy username từ JWT (preferred_username claim)
      final usernameFromJwt = _parseUsernameFromJwt(token);

      // Set token vào HttpClient (memory only) để gọi getProfile
      await _authRepository.setHttpToken(token);

      // Gọi getProfile để lấy userId, email
      UserProfileResponse? profile;
      try {
        profile = await _authRepository.getProfile();
      } catch (_) {}

      final displayName = usernameFromJwt.isNotEmpty
          ? usernameFromJwt
          : (profile?.emailAddress ?? event.email);

      debugPrint('🔍 [AuthBloc] usernameFromJwt="$usernameFromJwt" displayName="$displayName"');

      // Lưu toàn bộ user data
      await _authRepository.saveUserLocally(
        token,
        profile?.id ?? '',
        profile?.emailAddress ?? event.email,
        displayName,
      );

      emit(AuthState.authenticated(
        userId: profile?.id ?? '',
        email: profile?.emailAddress ?? event.email,
        token: token,
        displayName: displayName,
      ));
    } catch (e) {
      emit(AuthState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Register — KHÔNG auto-login, gửi email xác thực
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

      // Bước 2: Gửi email xác thực
      try {
        await _authRepository.sendEmailConfirmation(event.email);
      } catch (e) {
        debugPrint('⚠️ [AuthBloc] sendEmailConfirmation error (non-fatal): $e');
      }

      // Bước 3: Emit emailConfirmationRequired — KHÔNG auto-login
      emit(AuthState.emailConfirmationRequired(
        email: event.email,
        message: 'Vui lòng kiểm tra email $event.email để xác nhận tài khoản.\n'
            'Sau đó bạn có thể đăng nhập bình thường.',
      ));
    } catch (e) {
      emit(AuthState.error(e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Google login — verify token server-side, nhận OAuth token về
  Future<void> _onSocialLogin(
      AuthSocialLoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      // Gửi idToken lên BE để server verify
      final response = await _authRepository.socialLogin(
        provider: event.provider,
        idToken: event.idToken,
      );

      final token = response.accessToken ?? '';
      if (token.isEmpty) {
        throw Exception('Không lấy được token từ server');
      }

      final usernameFromJwt = _parseUsernameFromJwt(token);

      await _authRepository.setHttpToken(token);

      UserProfileResponse? profile;
      try {
        profile = await _authRepository.getProfile();
      } catch (_) {}

      final displayName = usernameFromJwt.isNotEmpty
          ? usernameFromJwt
          : (profile?.emailAddress ?? event.provider);

      await _authRepository.saveUserLocally(
        token,
        profile?.id ?? '',
        profile?.emailAddress ?? '',
        displayName,
      );

      emit(AuthState.authenticated(
        userId: profile?.id ?? '',
        email: profile?.emailAddress ?? '',
        token: token,
        displayName: displayName,
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
        // Có token — chỉ set vào HttpClient memory, KHÔNG overwrite SharedPrefs
        await _authRepository.setHttpToken(stored['token']!);
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
