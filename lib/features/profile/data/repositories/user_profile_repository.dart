import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';

/// User Profile DTO — khớp với GET /api/v1/userprofile response
class UserProfileDto {
  final String id;
  final String userId;
  final String learningGoal;      // conversation|business|travel|academic
  final String selfLevel;         // Beginner|Elementary|Intermediate|...
  final int dailyTargetMinutes;
  final int currentStreak;
  final int longestStreak;
  final int totalPoints;
  final DateTime? lastActivityAt;
  final DateTime? createdAt;

  UserProfileDto({
    required this.id,
    required this.userId,
    required this.learningGoal,
    required this.selfLevel,
    required this.dailyTargetMinutes,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalPoints,
    this.lastActivityAt,
    this.createdAt,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) => UserProfileDto(
        id: json['id'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        learningGoal: json['learningGoal'] as String? ?? 'conversation',
        selfLevel: json['selfLevel'] as String? ?? 'Beginner',
        dailyTargetMinutes: json['dailyTargetMinutes'] as int? ?? 30,
        currentStreak: json['currentStreak'] as int? ?? 0,
        longestStreak: json['longestStreak'] as int? ?? 0,
        totalPoints: json['totalPoints'] as int? ?? 0,
        lastActivityAt: _parseDate(json['lastActivityAt']),
        createdAt: _parseDate(json['createdAt']),
      );

  static DateTime? _parseDate(dynamic val) {
    if (val == null) return null;
    try {
      return DateTime.parse(val as String);
    } catch (_) {
      return null;
    }
  }
}

/// Update Profile Request
class UpdateUserProfileRequest {
  final String? learningGoal;
  final String? selfLevel;
  final int? dailyTargetMinutes;

  UpdateUserProfileRequest({
    this.learningGoal,
    this.selfLevel,
    this.dailyTargetMinutes,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (learningGoal != null) data['learningGoal'] = learningGoal;
    if (selfLevel != null) data['selfLevel'] = selfLevel;
    if (dailyTargetMinutes != null) {
      data['dailyTargetMinutes'] = dailyTargetMinutes;
    }
    return data;
  }
}

/// Repository for User Profile API
@injectable
class UserProfileRepository {
  final HttpClient _httpClient;

  UserProfileRepository(this._httpClient);

  /// GET /api/v1/userprofile — lấy profile của user hiện tại
  Future<UserProfileDto> getCurrentProfile() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        AppConfig.userProfileEndpoint,
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserProfileDto.fromJson(response.data!);
      }
      throw Exception('Failed to fetch profile: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT /api/v1/userprofile — update profile
  Future<UserProfileDto> updateProfile(UpdateUserProfileRequest request) async {
    try {
      final response = await _httpClient.put<Map<String, dynamic>>(
        AppConfig.userProfileEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserProfileDto.fromJson(response.data!);
      }
      throw Exception('Failed to update profile: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Không có kết nối mạng');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401) return Exception('Phiên đăng nhập hết hạn');
        if (code == 404) return Exception('Chưa có profile. Hãy tạo mới.');
        return Exception('Lỗi server: $code');
      default:
        return Exception('Lỗi mạng: ${e.message}');
    }
  }
}

class UserStatsDto {
  final int totalSentencesLearned;
  final int totalQuizAttempts;
  final int totalReviewsCompleted;
  final double quizSuccessRate;
  final int totalPointsEarned;

  UserStatsDto({
    required this.totalSentencesLearned,
    required this.totalQuizAttempts,
    required this.totalReviewsCompleted,
    required this.quizSuccessRate,
    required this.totalPointsEarned,
  });

  factory UserStatsDto.fromJson(Map<String, dynamic> json) => UserStatsDto(
        totalSentencesLearned: json['totalSentencesLearned'] as int? ?? 0,
        totalQuizAttempts: json['totalQuizAttempts'] as int? ?? 0,
        totalReviewsCompleted: json['totalReviewsCompleted'] as int? ?? 0,
        quizSuccessRate:
            (json['quizSuccessRate'] as num?)?.toDouble() ?? 0.0,
        totalPointsEarned: json['totalPointsEarned'] as int? ?? 0,
      );
}
