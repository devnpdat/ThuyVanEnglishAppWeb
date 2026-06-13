import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';

/// DTO classes
class CreateQuizAttemptRequest {
  final String sentenceId;
  final String quizType; // multiple_choice, fill_blank, true_false, etc
  final String userAnswer;
  final int timeSpentSeconds;
  final bool isCorrect;

  CreateQuizAttemptRequest({
    required this.sentenceId,
    required this.quizType,
    required this.userAnswer,
    required this.timeSpentSeconds,
    required this.isCorrect,
  });

  Map<String, dynamic> toJson() => {
        'sentenceId': sentenceId,
        'quizType': quizType,
        'userAnswer': userAnswer,
        'timeSpentSeconds': timeSpentSeconds,
        'isCorrect': isCorrect,
      };
}

class QuizAttemptDto {
  final String id;
  final String userId;
  final String sentenceId;
  final String quizType;
  final String userAnswer;
  final int timeSpentSeconds;
  final bool isCorrect;
  final DateTime attemptedAt;

  QuizAttemptDto({
    required this.id,
    required this.userId,
    required this.sentenceId,
    required this.quizType,
    required this.userAnswer,
    required this.timeSpentSeconds,
    required this.isCorrect,
    required this.attemptedAt,
  });

  factory QuizAttemptDto.fromJson(Map<String, dynamic> json) => QuizAttemptDto(
        id: json['id'] as String,
        userId: json['userId'] as String,
        sentenceId: json['sentenceId'] as String,
        quizType: json['quizType'] as String,
        userAnswer: json['userAnswer'] as String,
        timeSpentSeconds: json['timeSpentSeconds'] as int,
        isCorrect: json['isCorrect'] as bool,
        attemptedAt: DateTime.parse(json['attemptedAt'] as String),
      );
}

/// Repository to handle Quiz API calls
@injectable
class QuizRepository {
  final HttpClient _httpClient;

  QuizRepository(this._httpClient);

  /// Submit quiz attempt and get result
  Future<QuizAttemptDto> submitQuizAttempt(
      CreateQuizAttemptRequest request) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.quizEndpoint}/submit',
        data: request.toJson(),
      );

      if (response.statusCode == 201 && response.data != null) {
        return QuizAttemptDto.fromJson(response.data!);
      }
      throw Exception('Failed to submit quiz: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get quiz history for user
  Future<List<QuizAttemptDto>> getQuizHistory({
    int pageIndex = 0,
    int pageSize = 50,
  }) async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.quizEndpoint}/history?pageIndex=$pageIndex&pageSize=$pageSize',
      );

      if (response.statusCode == 200 && response.data != null) {
        final items = response.data!['items'] as List?;
        return items
                ?.map((item) => QuizAttemptDto.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [];
      }
      throw Exception('Failed to fetch quiz history: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get quiz stats
  Future<QuizStats> getQuizStats() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.quizEndpoint}/stats',
      );

      if (response.statusCode == 200 && response.data != null) {
        return QuizStats.fromJson(response.data!);
      }
      throw Exception('Failed to fetch quiz stats: ${response.statusCode}');
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

class QuizStats {
  final int totalAttempts;
  final int correctAnswers;
  final double successRate;

  QuizStats({
    required this.totalAttempts,
    required this.correctAnswers,
    required this.successRate,
  });

  factory QuizStats.fromJson(Map<String, dynamic> json) => QuizStats(
        totalAttempts: json['totalAttempts'] as int? ?? 0,
        correctAnswers: json['correctAnswers'] as int? ?? 0,
        successRate: (json['successRate'] as num?)?.toDouble() ?? 0.0,
      );
}
