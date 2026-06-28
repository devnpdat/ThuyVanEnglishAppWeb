import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';


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
    String? appName,
  }) : appName = appName ?? AppConfig.appName;

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'emailAddress': emailAddress,
        'password': password,
        'appName': appName,
      };
}

// ─── Response DTOs ──────────────────────────────────────────────────────────

/// ABP /api/account/login response:
/// {"result":1,"description":"Success"} — không có token trực tiếp
/// Token nằm trong cookie hoặc cần gọi thêm /api/abp/application-configuration
/// Workaround: sau khi login thành công (result=1), gọi /connect/token để lấy token
class LoginResponse {
  final bool success;
  final String? accessToken;
  final String? encryptedAccessToken;
  final int expireInSeconds;

  LoginResponse({
    required this.success,
    this.accessToken,
    this.encryptedAccessToken,
    this.expireInSeconds = 86400,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    // ABP /api/account/login trả {"result":1,"description":"Success"}
    final result = json['result'] as int? ?? 0;
    return LoginResponse(
      success: result == 1,
      // Token sẽ được set qua cookie session hoặc OAuth flow riêng
      accessToken: json['accessToken'] as String? ??
          json['access_token'] as String?,
      expireInSeconds: json['expireInSeconds'] as int? ??
          json['expires_in'] as int? ??
          86400,
    );
  }
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

  /// Login — 2 bước:
  /// 1. POST /api/account/login → {"result":1}
  /// 2. POST /connect/token (OAuth2) → access_token
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      // Bước 1: ABP session login
      final loginResp = await _httpClient.post<Map<String, dynamic>>(
        AppConfig.authLoginEndpoint,
        data: request.toJson(),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final result = loginResp.data?['result'] as int? ?? 0;
      if (result != 1) {
        final desc = loginResp.data?['description'] ?? 'Đăng nhập thất bại';
        throw Exception(desc);
      }

      // Bước 2: Lấy OAuth2 token
      final tokenResp = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/connect/token',
        data: {
          'grant_type': 'password',
          'username': request.userNameOrEmailAddress,
          'password': request.password,
          'client_id': 'EnglishApp_App',
          'client_secret': '1q2w3e*',
          'scope': 'EnglishApp offline_access',
        },
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );

      if (tokenResp.statusCode == 200 && tokenResp.data != null) {
        final token = tokenResp.data!['access_token'] as String? ?? '';
        if (token.isEmpty) throw Exception('Không lấy được token');
        return LoginResponse(
          success: true,
          accessToken: token,
          expireInSeconds: tokenResp.data!['expires_in'] as int? ?? 86400,
        );
      }
      throw Exception('Lỗi lấy token: ${tokenResp.statusCode}');
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

  /// Google login — gửi idToken lên BE, nhận OAuth token về
  Future<LoginResponse> socialLogin({
    required String provider,
    required String idToken,
  }) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/api/account/google-login',
        data: {
          'idToken': idToken,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final token = response.data!['access_token'] as String? ??
            response.data!['accessToken'] as String? ??
            '';
        return LoginResponse(
          success: token.isNotEmpty,
          accessToken: token,
          expireInSeconds: response.data!['expires_in'] as int? ?? 86400,
        );
      }
      throw Exception('Google login failed: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Gửi email xác thực sau khi đăng ký
  Future<void> sendEmailConfirmation(String email) async {
    try {
      await _httpClient.post<dynamic>(
        '${AppConfig.apiBaseUrl}/api/account/send-email-confirmation',
        data: {
          'email': email,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
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

  /// Set token vào HttpClient memory only — KHÔNG ghi SharedPreferences
  /// Dùng khi cần gọi API (getProfile) trước khi lưu user data đầy đủ,
  /// hoặc khi restore session (chỉ cần set token vào memory, không overwrite prefs).
  Future<void> setHttpToken(String token) async {
    await _httpClient.setAuthToken(token);
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

  /// Send password reset code to email
  Future<void> sendPasswordResetCode(String email) async {
    try {
      await _httpClient.post<dynamic>(
        AppConfig.authForgotPasswordEndpoint,
        data: {
          'appName': AppConfig.appName,
          'email': email,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      // ABP trả 200 không có body — mọi status 2xx là thành công
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Reset password with token from email link
  Future<void> resetPassword({
    required String userId,
    required String resetToken,
    required String password,
  }) async {
    try {
      await _httpClient.post<dynamic>(
        AppConfig.authResetPasswordEndpoint,
        data: {
          'userId': userId,
          'resetToken': resetToken,
          'password': password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
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
        final data = e.response?.data;
        String? errorMsg;

        if (data is Map) {
          // OpenIddict /connect/token trả: {"error":"invalid_client","error_description":"..."}
          // data['error'] ở đây là String, KHÔNG phải Map — tránh gọi ['message'] trên String
          final errorField = data['error'];
          if (errorField is Map) {
            // ABP Business Exception format: {"error":{"message":"...","details":"..."}}
            errorMsg = errorField['message'] as String?;
          } else {
            // OAuth2 format: {"error":"invalid_client","error_description":"..."}
            errorMsg = data['error_description'] as String? ??
                data['message'] as String?;
          }
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
