import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:english_learning_app/features/learning/data/dtos/daily_learning_dto.dart';

@injectable
class DailyLearningRepository {
  final HttpClient _httpClient;

  DailyLearningRepository(this._httpClient);

  Future<TodayLearningDto> getTodayLearning() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.learningEndpoint}/today',
      );

      if (response.statusCode == 200 && response.data != null) {
        return TodayLearningDto.fromJson(response.data!);
      }
      throw Exception('Failed to fetch today learning: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<TodayLearningDto> generateTodayPlan() async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.learningEndpoint}/today/generate',
      );

      if (response.statusCode == 200 && response.data != null) {
        return TodayLearningDto.fromJson(response.data!);
      }
      throw Exception('Failed to generate today plan: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<AudioPlayedResultDto> recordAudioPlayed(String sentenceId) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.learningEndpoint}/sentences/$sentenceId/audio-played',
      );

      if (response.statusCode == 200 && response.data != null) {
        return AudioPlayedResultDto.fromJson(response.data!);
      }
      throw Exception('Failed to record audio played: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<TypingResultDto> submitTypingAttempt(String sentenceId, TypingAttemptDto attempt) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.learningEndpoint}/sentences/$sentenceId/typing-attempt',
        data: attempt.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return TypingResultDto.fromJson(response.data!);
      }
      throw Exception('Failed to submit typing attempt: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<SessionQuizResultDto> submitSessionQuiz(String sentenceId, SessionQuizSubmitDto submission) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.learningEndpoint}/sentences/$sentenceId/quiz-submit',
        data: submission.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SessionQuizResultDto.fromJson(response.data!);
      }
      throw Exception('Failed to submit quiz: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<SessionCompleteResultDto> completeSession(String sentenceId) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.learningEndpoint}/sentences/$sentenceId/complete',
      );

      if (response.statusCode == 200 && response.data != null) {
        return SessionCompleteResultDto.fromJson(response.data!);
      }
      throw Exception('Failed to complete session: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 422 && e.response?.data != null) {
          return SessionCompleteResultDto.fromJson(e.response!.data as Map<String, dynamic>);
      }
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout');
      case DioExceptionType.badResponse:
        return Exception('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}
