/// App Configuration - Environment Selector
/// 
/// Chọn config theo build mode:
/// - Development (local): flutter run -d chrome --web-port=5173
/// - Production (Railway): flutter build web --release

import 'package:flutter/foundation.dart';

// Import cả 2 config
import 'app_config.dev.dart' as dev;
import 'app_config.prod.dart' as prod;

/// AppConfig - tự động chọn dev/prod dựa vào build mode
class AppConfig {
  // Backend API Configuration
  static String get apiBaseUrl => kReleaseMode ? prod.AppConfig.apiBaseUrl : dev.AppConfig.apiBaseUrl;

  // API Endpoints
  static String get topicsEndpoint => kReleaseMode ? prod.AppConfig.topicsEndpoint : dev.AppConfig.topicsEndpoint;
  static String get sentencesEndpoint => kReleaseMode ? prod.AppConfig.sentencesEndpoint : dev.AppConfig.sentencesEndpoint;
  static String get quizEndpoint => kReleaseMode ? prod.AppConfig.quizEndpoint : dev.AppConfig.quizEndpoint;
  static String get reviewEndpoint => kReleaseMode ? prod.AppConfig.reviewEndpoint : dev.AppConfig.reviewEndpoint;
  static String get userProfileEndpoint => kReleaseMode ? prod.AppConfig.userProfileEndpoint : dev.AppConfig.userProfileEndpoint;
  static String get rewardsEndpoint => kReleaseMode ? prod.AppConfig.rewardsEndpoint : dev.AppConfig.rewardsEndpoint;
  static String get learningPlanEndpoint => kReleaseMode ? prod.AppConfig.learningPlanEndpoint : dev.AppConfig.learningPlanEndpoint;
  static String get learningEndpoint => kReleaseMode ? prod.AppConfig.learningEndpoint : dev.AppConfig.learningEndpoint;
  static String get dashboardEndpoint => kReleaseMode ? prod.AppConfig.dashboardEndpoint : dev.AppConfig.dashboardEndpoint;
  static String get aiEndpoint => kReleaseMode ? prod.AppConfig.aiEndpoint : dev.AppConfig.aiEndpoint;
  static String get placementTestEndpoint => kReleaseMode ? prod.AppConfig.placementTestEndpoint : dev.AppConfig.placementTestEndpoint;

  // Auth endpoints
  static String get authLoginEndpoint => kReleaseMode ? prod.AppConfig.authLoginEndpoint : dev.AppConfig.authLoginEndpoint;
  static String get authRegisterEndpoint => kReleaseMode ? prod.AppConfig.authRegisterEndpoint : dev.AppConfig.authRegisterEndpoint;
  static String get authProfileEndpoint => kReleaseMode ? prod.AppConfig.authProfileEndpoint : dev.AppConfig.authProfileEndpoint;
  static String get authChangePasswordEndpoint => kReleaseMode ? prod.AppConfig.authChangePasswordEndpoint : dev.AppConfig.authChangePasswordEndpoint;

  // HTTP Configuration
  static int get connectionTimeout => kReleaseMode ? prod.AppConfig.connectionTimeout : dev.AppConfig.connectionTimeout;
  static int get receiveTimeout => kReleaseMode ? prod.AppConfig.receiveTimeout : dev.AppConfig.receiveTimeout;
  static int get sendTimeout => kReleaseMode ? prod.AppConfig.sendTimeout : dev.AppConfig.sendTimeout;

  // Local Storage Keys
  static String get tokenStorageKey => kReleaseMode ? prod.AppConfig.tokenStorageKey : dev.AppConfig.tokenStorageKey;
  static String get userEmailKey => kReleaseMode ? prod.AppConfig.userEmailKey : dev.AppConfig.userEmailKey;
  static String get userIdKey => kReleaseMode ? prod.AppConfig.userIdKey : dev.AppConfig.userIdKey;
  static String get userDisplayNameKey => kReleaseMode ? prod.AppConfig.userDisplayNameKey : dev.AppConfig.userDisplayNameKey;
  static String get offlineDataKey => kReleaseMode ? prod.AppConfig.offlineDataKey : dev.AppConfig.offlineDataKey;

  // App Settings
  static String get appName => kReleaseMode ? prod.AppConfig.appName : dev.AppConfig.appName;
  static String get appVersion => kReleaseMode ? prod.AppConfig.appVersion : dev.AppConfig.appVersion;
  static String get defaultLanguage => kReleaseMode ? prod.AppConfig.defaultLanguage : dev.AppConfig.defaultLanguage;

  // Feature Flags
  static bool get enableOfflineMode => kReleaseMode ? prod.AppConfig.enableOfflineMode : dev.AppConfig.enableOfflineMode;
  static bool get enableDebugLogging => kReleaseMode ? prod.AppConfig.enableDebugLogging : dev.AppConfig.enableDebugLogging;
  static bool get enableApiCaching => kReleaseMode ? prod.AppConfig.enableApiCaching : dev.AppConfig.enableApiCaching;

  // SSL Configuration
  static bool get allowSelfSignedCerts => kReleaseMode ? prod.AppConfig.allowSelfSignedCerts : dev.AppConfig.allowSelfSignedCerts;

  // Debug info
  static String get currentEnv => kReleaseMode ? 'PRODUCTION' : 'DEVELOPMENT';
}
