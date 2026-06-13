import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';

// ─── Request DTOs ──────────────────────────────────────────────────────────

class LoginRequest {
  final String userNameOrEmailAddress;
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.userNameOrEmailAddress,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() => {
        'userNameOrEmailAddress': userNameOrEmailAddress,
        'password': password,
        'rememberMe': rememberMe,
      };
}

class RegisterRequest {
  final String userName;
  final String emailAddress;
  final String password;
  final String appName;

  RegisterRequest({
    required this.userName,
    required this.emailAddress,
    required this.password,
    this.appName = AppConfig.appName,
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'emailAddress': emailAddress,
        'password': password,
        'appName': appName,
      };
}

// ─── Response DTOs ──────────────────────────────────────────────────────────

/// ABP login response — field là camelCase: accessToken (không phải access_token)
class LoginResponse {
  final String accessToken;
  final String? encryptedAccessToken;
  final int expireInSeconds;

  LoginResponse({
    required this.accessToken,
    this.encryptedAccessToken,
    required this.expireInSeconds,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        // ABP trả 'accessToken' (camelCase)
        accessToken: json['accessToken'] as String? ??
            json['access_token'] as String? ??
            '',
        encryptedAccessToken: json['encryptedAccessToken'] as String?,
        expireInSeconds: json['expireInSeconds'] as int? ??
            json['expires_in'] as int? ??
            86400,
      );
}

class RegisterResponse {
  final String userId;
  final String userName;
  final String emailAddress;

  RegisterResponse({
    required this.userId,
    required this.userName,
    required this.emailAddress,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        userId: json['id'] as String? ?? '',
        userName: json['userName'] as String? ?? '',
        emailAddress: json['emailAddress'] as String? ??
            json['email'] as String? ??
            '',
      );
}

class UserProfileResponse {
  final String id;
  final String userName;
  final String emailAddress;
  final String? name;
  final String? surname;

  UserProfileResponse({
    required this.id,
    required this.userName,
    required this.emailAddress,
    this.name,
    this.surname,
  });

  String get displayName {
    if (name != null && name!.isNotEmpty) {
      return surname != null ? '$name $surname' : name!;
    }
    return userName;
  }

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) =>
      UserProfileResponse(
        id: json['id'] as String? ?? '',
        userName: json['userName'] as String? ?? '',
        emailAddress: json['emailAddress'] as String? ?? '',
        name: json['name'] as String?,
        surname: json['surname'] as String?,
      );
}

// ─── Repository ──────────────────────────────────────────────────────────────

@injectable
class AuthRepository {
  final HttpClient _httpClient;

  AuthRepository(this._httpClient);

  /// Login — trả về JWT token
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        AppConfig.authLoginEndpoint,
        data: {
          'grant_type': 'password',
          'username': request.userNameOrEmailAddress,
          'password': request.password,
          'client_id': 'EnglishApp_Mobile',
          'scope': 'EnglishApp offline_access',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final loginResp = LoginResponse.fromJson(response.data!);
        if (loginResp.accessToken.isEmpty) {
          throw Exception('Login failed: empty token received');
        }
        return loginResp;
      }
      throw Exception('Login failed: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Register new user
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        AppConfig.authRegisterEndpoint,
        data: request.toJson(),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return RegisterResponse.fromJson(response.data!);
      }
      throw Exception('Registration failed: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get current user profile (ABP)
  Future<UserProfileResponse> getProfile() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        AppConfig.authProfileEndpoint,
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserProfileResponse.fromJson(response.data!);
      }
      throw Exception('Failed to get profile: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Save user info to SharedPreferences
  Future<void> saveUserLocally(
      String token, String userId, String email, String displayName) async {
    await _httpClient.setAuthToken(token);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.userIdKey, userId);
    await prefs.setString(AppConfig.userEmailKey, email);
    await prefs.setString(AppConfig.userDisplayNameKey, displayName);
  }

  /// Clear all stored auth data
  Future<void> clearLocalAuth() async {
    await _httpClient.clearAuthToken();
  }

  /// Check if user is still logged in (has stored token)
  Future<Map<String, String>?> getStoredUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.tokenStorageKey);
      final userId = prefs.getString(AppConfig.userIdKey);
      final email = prefs.getString(AppConfig.userEmailKey);
      final displayName = prefs.getString(AppConfig.userDisplayNameKey);

      if (token != null && token.isNotEmpty && userId != null) {
        return {
          'token': token,
          'userId': userId,
          'email': email ?? '',
          'displayName': displayName ?? email ?? '',
        };
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Không có kết nối mạng. Vui lòng kiểm tra internet.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        // ABP trả error message trong response.data cho cả 400 (Validation) và 403 (Business Exception)
        final data = e.response?.data;
        String? errorMsg;
        if (data is Map) {
          errorMsg = data['error']?['message'] as String? ??
              data['error_description'] as String?;
        }

        if (statusCode == 400) {
          return Exception(errorMsg ?? 'Thông tin không hợp lệ');
        } else if (statusCode == 401) {
          return Exception(errorMsg ?? 'Sai tên đăng nhập hoặc mật khẩu.');
        } else if (statusCode == 403) {
          // Volo.Abp trả 403 cho BusinessException (vd: Lỗi format password)
          return Exception(errorMsg ?? 'Tài khoản không có quyền truy cập.');
        }
        return Exception(errorMsg ?? 'Lỗi máy chủ: $statusCode');
      default:
        return Exception('Lỗi mạng: ${e.message}');
    }
  }
}
