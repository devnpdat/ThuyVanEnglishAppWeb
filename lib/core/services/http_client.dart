import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/core/config/app_config.dart';

/// HTTP Client wrapper — handles auth token injection, interceptors, error handling
@singleton
class HttpClient {
  late final Dio _dio;
  String? _token;

  HttpClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(seconds: AppConfig.connectionTimeout),
        receiveTimeout: Duration(seconds: AppConfig.receiveTimeout),
        sendTimeout: Duration(seconds: AppConfig.sendTimeout),
        contentType: 'application/json',
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    // Add auth + logging interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          // Load token from SharedPreferences if not cached in memory
          _token ??= await _loadToken();
          if (_token != null && _token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          if (AppConfig.enableDebugLogging) {
            debugPrint('→ ${options.method} ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (Response response, handler) {
          if (AppConfig.enableDebugLogging) {
            debugPrint('✅ ${response.statusCode} ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          debugPrint('🔴 API Error: ${error.response?.statusCode} ${error.requestOptions.path}');
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// Load token from SharedPreferences
  Future<String?> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(AppConfig.tokenStorageKey);
    } catch (_) {
      return null;
    }
  }

  /// Set auth token (called after login)
  Future<void> setAuthToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.tokenStorageKey, token);
    debugPrint('🔑 Auth token set');
  }

  /// Clear auth token (called on logout)
  Future<void> clearAuthToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenStorageKey);
    await prefs.remove(AppConfig.userIdKey);
    await prefs.remove(AppConfig.userEmailKey);
    await prefs.remove(AppConfig.userDisplayNameKey);
    debugPrint('🔓 Auth token cleared');
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response;
  }
}
