import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';

/// Learning Plan DTO
class LearningPlanDto {
  final String id;
  final String userId;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int targetSentencesPerDay;
  final String status; // active, completed, paused
  final DateTime createdAt;

  LearningPlanDto({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.targetSentencesPerDay,
    required this.status,
    required this.createdAt,
  });

  factory LearningPlanDto.fromJson(Map<String, dynamic> json) =>
      LearningPlanDto(
        id: json['id'] as String,
        userId: json['userId'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        startDate: DateTime.parse(json['startDate'] as String),
        endDate: DateTime.parse(json['endDate'] as String),
        targetSentencesPerDay: json['targetSentencesPerDay'] as int,
        status: json['status'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Learning Progress DTO
class LearningProgressDto {
  final String id;
  final String userId;
  final String sentenceId;
  final int timesLearned;
  final int timesReviewed;
  final DateTime? lastLearnedAt;
  final DateTime? lastReviewedAt;
  final bool isMarked;
  final String? notes;
  final DateTime createdAt;

  LearningProgressDto({
    required this.id,
    required this.userId,
    required this.sentenceId,
    required this.timesLearned,
    required this.timesReviewed,
    this.lastLearnedAt,
    this.lastReviewedAt,
    required this.isMarked,
    this.notes,
    required this.createdAt,
  });

  factory LearningProgressDto.fromJson(Map<String, dynamic> json) =>
      LearningProgressDto(
        id: json['id'] as String,
        userId: json['userId'] as String,
        sentenceId: json['sentenceId'] as String,
        timesLearned: json['timesLearned'] as int,
        timesReviewed: json['timesReviewed'] as int,
        lastLearnedAt: json['lastLearnedAt'] != null
            ? DateTime.parse(json['lastLearnedAt'] as String)
            : null,
        lastReviewedAt: json['lastReviewedAt'] != null
            ? DateTime.parse(json['lastReviewedAt'] as String)
            : null,
        isMarked: json['isMarked'] as bool,
        notes: json['notes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// Create Learning Plan Request
class CreateLearningPlanRequest {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int targetSentencesPerDay;

  CreateLearningPlanRequest({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.targetSentencesPerDay,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'targetSentencesPerDay': targetSentencesPerDay,
      };
}

/// Repository for Learning Plans & Progress
@injectable
class LearningRepository {
  final HttpClient _httpClient;

  LearningRepository(this._httpClient);

  /// Get all learning plans for user
  Future<List<LearningPlanDto>> getLearningPlans() async {
    try {
      final response = await _httpClient
          .get<Map<String, dynamic>>(AppConfig.learningPlanEndpoint);

      if (response.statusCode == 200 && response.data != null) {
        final items = response.data!['items'] as List?;
        return items
                ?.map((item) =>
                    LearningPlanDto.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [];
      }
      throw Exception('Failed to fetch plans: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Create new learning plan
  Future<LearningPlanDto> createLearningPlan(
      CreateLearningPlanRequest request) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        AppConfig.learningPlanEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 201 && response.data != null) {
        return LearningPlanDto.fromJson(response.data!);
      }
      throw Exception('Failed to create plan: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get learning progress for sentence
  Future<LearningProgressDto> getProgress(String sentenceId) async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.learningPlanEndpoint}/progress/$sentenceId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return LearningProgressDto.fromJson(response.data!);
      }
      throw Exception('Failed to fetch progress: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Mark sentence as learned
  Future<LearningProgressDto> markAsLearned(String sentenceId) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.learningPlanEndpoint}/progress/$sentenceId/mark-learned',
      );

      if (response.statusCode == 200 && response.data != null) {
        return LearningProgressDto.fromJson(response.data!);
      }
      throw Exception('Failed to mark learned: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode}');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
