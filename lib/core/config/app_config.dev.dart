/// App Configuration - Development (Local)
class AppConfig {
  // Backend API Configuration - LOCAL
  static const String apiBaseUrl = 'https://localhost:44396';

  // API Endpoints
  static const String topicsEndpoint = '$apiBaseUrl/api/v1/topics';
  static const String sentencesEndpoint = '$apiBaseUrl/api/v1/sentences';
  static const String quizEndpoint = '$apiBaseUrl/api/v1/quiz';
  static const String reviewEndpoint = '$apiBaseUrl/api/v1/review';
  static const String userProfileEndpoint = '$apiBaseUrl/api/v1/userprofile';
  static const String rewardsEndpoint = '$apiBaseUrl/api/v1/rewards';
  static const String learningPlanEndpoint = '$apiBaseUrl/api/v1/learningplan';
  static const String learningEndpoint = '$apiBaseUrl/api/v1/learning';
  static const String dashboardEndpoint = '$apiBaseUrl/api/v1/dashboard';
  static const String aiEndpoint = '$apiBaseUrl/api/v1/ai';
  static const String placementTestEndpoint = '$apiBaseUrl/api/v1/placement-test';

  // Auth endpoints
  static const String authLoginEndpoint = '$apiBaseUrl/api/account/login';
  static const String authRegisterEndpoint = '$apiBaseUrl/api/account/register';
  static const String authProfileEndpoint = '$apiBaseUrl/api/account/profile-extended';
  static const String authChangePasswordEndpoint = '$apiBaseUrl/api/account/change-password';
  static const String authForgotPasswordEndpoint = '$apiBaseUrl/api/account/send-password-reset-code';
  static const String authResetPasswordEndpoint = '$apiBaseUrl/api/account/reset-password';

  // HTTP Configuration
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Local Storage Keys
  static const String tokenStorageKey = 'auth_token';
  static const String userEmailKey = 'user_email';
  static const String userIdKey = 'user_id';
  static const String userDisplayNameKey = 'user_display_name';
  static const String offlineDataKey = 'offline_data';

  // App Settings
  static const String appName = 'EnglishLearningApp';
  static const String appVersion = '1.0.0';
  static const String defaultLanguage = 'en';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableDebugLogging = true;
  static const bool enableApiCaching = true;

  // Google Sign-In
  static const String googleServerClientId = '952037731608-ln7gfjupt77125arhq2oe1as49q978pp.apps.googleusercontent.com';

  // SSL Configuration
  static const bool allowSelfSignedCerts = true;  // Dev only
}
