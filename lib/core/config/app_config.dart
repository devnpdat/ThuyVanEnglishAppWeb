/// App Configuration - Environment Selector
/// 
/// Chọn config theo build mode:
/// - Development (local): flutter run -d chrome --web-port=5173
/// - Production (Railway): flutter build web --release
/// 
/// File này export đúng config theo kIsWeb và kReleaseMode.

import 'package:flutter/foundation.dart';

// Import cả 2 config với prefix
import 'app_config.dev.dart' as dev;
import 'app_config.prod.dart' as prod;

/// AppConfig - tự động chọn dev/prod dựa vào build mode
class AppConfig {
  // Chọn config: kReleaseMode → prod, còn lại → dev
  static final _config = kReleaseMode ? prod.AppConfig : dev.AppConfig;

  // Backend API Configuration
  static String get apiBaseUrl => _config.apiBaseUrl;

  // API Endpoints
  static String get topicsEndpoint => _config.topicsEndpoint;
  static String get sentencesEndpoint => _config.sentencesEndpoint;
  static String get quizEndpoint => _config.quizEndpoint;
  static String get reviewEndpoint => _config.reviewEndpoint;
  static String get userProfileEndpoint => _config.userProfileEndpoint;
  static String get rewardsEndpoint => _config.rewardsEndpoint;
  static String get learningPlanEndpoint => _config.learningPlanEndpoint;
  static String get learningEndpoint => _config.learningEndpoint;
  static String get dashboardEndpoint => _config.dashboardEndpoint;
  static String get aiEndpoint => _config.aiEndpoint;

  // Auth endpoints
  static String get authLoginEndpoint => _config.authLoginEndpoint;
  static String get authRegisterEndpoint => _config.authRegisterEndpoint;
  static String get authProfileEndpoint => _config.authProfileEndpoint;
  static String get authChangePasswordEndpoint => _config.authChangePasswordEndpoint;

  // HTTP Configuration
  static int get connectionTimeout => _config.connectionTimeout;
  static int get receiveTimeout => _config.receiveTimeout;
  static int get sendTimeout => _config.sendTimeout;

  // Local Storage Keys
  static String get tokenStorageKey => _config.tokenStorageKey;
  static String get userEmailKey => _config.userEmailKey;
  static String get userIdKey => _config.userIdKey;
  static String get userDisplayNameKey => _config.userDisplayNameKey;
  static String get offlineDataKey => _config.offlineDataKey;

  // App Settings
  static String get appName => _config.appName;
  static String get appVersion => _config.appVersion;
  static String get defaultLanguage => _config.defaultLanguage;

  // Feature Flags
  static bool get enableOfflineMode => _config.enableOfflineMode;
  static bool get enableDebugLogging => _config.enableDebugLogging;
  static bool get enableApiCaching => _config.enableApiCaching;

  // SSL Configuration
  static bool get allowSelfSignedCerts => _config.allowSelfSignedCerts;

  // Debug info
  static String get currentEnv => kReleaseMode ? 'PRODUCTION' : 'DEVELOPMENT';
}
