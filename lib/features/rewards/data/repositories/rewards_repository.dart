import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';

/// Reward Summary — response từ GET /api/v1/rewards/summary
class RewardsSummaryDto {
  final int totalPoints;
  final int quizCorrectCount;
  final int streakDaysCount;
  final int plansCompletedCount;
  final String currentLevel;       // Bronze, Silver, Gold, Platinum
  final int pointsToNextLevel;
  final int currentLevelThreshold;
  final int nextLevelThreshold;

  RewardsSummaryDto({
    required this.totalPoints,
    required this.quizCorrectCount,
    required this.streakDaysCount,
    required this.plansCompletedCount,
    required this.currentLevel,
    required this.pointsToNextLevel,
    required this.currentLevelThreshold,
    required this.nextLevelThreshold,
  });

  factory RewardsSummaryDto.fromJson(Map<String, dynamic> json) {
    final totalPoints = json['totalPoints'] as int? ?? 0;

    // Tính level từ points (hoặc lấy từ API nếu có)
    String level = 'Bronze';
    int levelThreshold = 0;
    int nextThreshold = 1000;
    if (json['currentLevel'] != null) {
      level = json['currentLevel'] as String;
    } else if (totalPoints >= 10000) {
      level = 'Platinum';
      levelThreshold = 10000;
      nextThreshold = 999999;
    } else if (totalPoints >= 5000) {
      level = 'Gold';
      levelThreshold = 5000;
      nextThreshold = 10000;
    } else if (totalPoints >= 1000) {
      level = 'Silver';
      levelThreshold = 1000;
      nextThreshold = 5000;
    }

    return RewardsSummaryDto(
      totalPoints: totalPoints,
      quizCorrectCount: json['quizCorrectCount'] as int? ?? 0,
      streakDaysCount: json['streakDaysCount'] as int? ??
          json['currentStreak'] as int? ?? 0,
      plansCompletedCount: json['plansCompletedCount'] as int? ?? 0,
      currentLevel: level,
      pointsToNextLevel: (nextThreshold - totalPoints).clamp(0, 999999),
      currentLevelThreshold: levelThreshold,
      nextLevelThreshold: nextThreshold,
    );
  }
}

/// Leaderboard entry — item trong GET /api/v1/rewards/leaderboard
class LeaderboardEntryDto {
  final int rank;
  final String userId;
  final String userName;
  final int totalPoints;
  final int currentStreak;
  final bool isCurrentUser;

  LeaderboardEntryDto({
    required this.rank,
    required this.userId,
    required this.userName,
    required this.totalPoints,
    required this.currentStreak,
    this.isCurrentUser = false,
  });

  factory LeaderboardEntryDto.fromJson(Map<String, dynamic> json, {int rank = 0}) =>
      LeaderboardEntryDto(
        rank: json['rank'] as int? ?? rank,
        userId: json['userId'] as String? ?? '',
        userName: json['userName'] as String? ??
            json['displayName'] as String? ?? 'User',
        totalPoints: json['totalPoints'] as int? ?? 0,
        currentStreak: json['currentStreak'] as int? ??
            json['streakDaysCount'] as int? ?? 0,
      );
}

/// Reward History item — item trong GET /api/v1/rewards/history
class RewardHistoryDto {
  final String id;
  final int points;
  final String activityType;   // quiz_correct, review_done, streak_milestone, etc.
  final String description;
  final DateTime createdAt;

  RewardHistoryDto({
    required this.id,
    required this.points,
    required this.activityType,
    required this.description,
    required this.createdAt,
  });

  factory RewardHistoryDto.fromJson(Map<String, dynamic> json) =>
      RewardHistoryDto(
        id: json['id'] as String? ?? '',
        points: json['points'] as int? ?? 0,
        activityType: json['activityType'] as String? ?? 'other',
        description: json['description'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
      );
}

/// Repository for Rewards API
@injectable
class RewardsRepository {
  final HttpClient _httpClient;

  RewardsRepository(this._httpClient);

  /// GET /api/v1/rewards/summary — lấy tổng điểm + streak + level
  Future<RewardsSummaryDto> getSummary() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.rewardsEndpoint}/summary',
      );

      if (response.statusCode == 200 && response.data != null) {
        return RewardsSummaryDto.fromJson(response.data!);
      }
      throw Exception('Failed to fetch rewards: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET /api/v1/rewards/history — lịch sử nhận điểm
  Future<List<RewardHistoryDto>> getHistory({
    int skipCount = 0,
    int maxResultCount = 20,
  }) async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.rewardsEndpoint}/history',
        queryParameters: {
          'SkipCount': skipCount,
          'MaxResultCount': maxResultCount,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final items = response.data!['items'] as List<dynamic>? ?? [];
        return items
            .map((e) =>
                RewardHistoryDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Failed to fetch history: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET /api/v1/rewards/leaderboard — top 10 users
  Future<List<LeaderboardEntryDto>> getLeaderboard({int limit = 10}) async {
    try {
      final response = await _httpClient.get<dynamic>(
        '${AppConfig.rewardsEndpoint}/leaderboard',
        queryParameters: {'limit': limit},
      );

      if (response.statusCode == 200 && response.data != null) {
        // Leaderboard có thể trả array trực tiếp hoặc wrapped trong items
        List<dynamic> items;
        if (response.data is List) {
          items = response.data as List<dynamic>;
        } else if (response.data is Map) {
          items = (response.data as Map)['items'] as List<dynamic>? ?? [];
        } else {
          items = [];
        }

        return items
            .asMap()
            .entries
            .map((entry) => LeaderboardEntryDto.fromJson(
                  entry.value as Map<String, dynamic>,
                  rank: entry.key + 1,
                ))
            .toList();
      }
      throw Exception('Failed to fetch leaderboard: ${response.statusCode}');
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
        return Exception('Lỗi server: $code');
      default:
        return Exception('Lỗi mạng: ${e.message}');
    }
  }
}
