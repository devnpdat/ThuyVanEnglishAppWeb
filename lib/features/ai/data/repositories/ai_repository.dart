import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';

/// AI Request DTO
class AIRequestDto {
  final String id;
  final String userId;
  final String provider; // claude, gemini
  final String model;
  final String requestType; // explain, translate, generate_example
  final String prompt;
  final String? response;
  final String status; // pending, completed, failed
  final int? tokensUsed;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? completedAt;

  AIRequestDto({
    required this.id,
    required this.userId,
    required this.provider,
    required this.model,
    required this.requestType,
    required this.prompt,
    this.response,
    required this.status,
    this.tokensUsed,
    this.errorMessage,
    required this.createdAt,
    this.completedAt,
  });

  factory AIRequestDto.fromJson(Map<String, dynamic> json) => AIRequestDto(
        id: json['id'] as String,
        userId: json['userId'] as String,
        provider: json['provider'] as String,
        model: json['model'] as String,
        requestType: json['requestType'] as String,
        prompt: json['prompt'] as String,
        response: json['response'] as String?,
        status: json['status'] as String,
        tokensUsed: json['tokensUsed'] as int?,
        errorMessage: json['errorMessage'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'] as String)
            : null,
      );
}

/// Explain Sentence Request
class ExplainSentenceRequest {
  final String sentenceId;
  final String englishText;
  final String? contextHint;

  ExplainSentenceRequest({
    required this.sentenceId,
    required this.englishText,
    this.contextHint,
  });

  Map<String, dynamic> toJson() => {
        'sentenceId': sentenceId,
        'englishText': englishText,
        'contextHint': contextHint,
      };
}

/// Generate Example Request
class GenerateExampleRequest {
  final String word;
  final String difficultyLevel;
  final int? maxExamples;

  GenerateExampleRequest({
    required this.word,
    required this.difficultyLevel,
    this.maxExamples,
  });

  Map<String, dynamic> toJson() => {
        'word': word,
        'difficultyLevel': difficultyLevel,
        'maxExamples': maxExamples,
      };
}

/// Translate Request
class TranslateRequest {
  final String text;
  final String targetLanguage; // vi, en, etc

  TranslateRequest({
    required this.text,
    required this.targetLanguage,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'targetLanguage': targetLanguage,
      };
}

/// AI Response DTO
class AIResponseDto {
  final String result;
  final int tokensUsed;
  final String provider;

  AIResponseDto({
    required this.result,
    required this.tokensUsed,
    required this.provider,
  });

  factory AIResponseDto.fromJson(Map<String, dynamic> json) => AIResponseDto(
        result: json['result'] as String,
        tokensUsed: json['tokensUsed'] as int,
        provider: json['provider'] as String,
      );
}

/// Repository for AI Integration API
@injectable
class AIRepository {
  final HttpClient _httpClient;

  AIRepository(this._httpClient);

  /// Explain a sentence using AI
  Future<AIResponseDto> explainSentence(
      ExplainSentenceRequest request) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/api/v1/AI/explain',
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return AIResponseDto.fromJson(response.data!);
      }
      throw Exception('Failed to explain: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Generate examples for a word
  Future<AIResponseDto> generateExamples(
      GenerateExampleRequest request) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/api/v1/AI/examples',
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return AIResponseDto.fromJson(response.data!);
      }
      throw Exception('Failed to generate: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Translate text
  Future<AIResponseDto> translate(TranslateRequest request) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.apiBaseUrl}/api/v1/AI/translate',
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return AIResponseDto.fromJson(response.data!);
      }
      throw Exception('Failed to translate: ${response.statusCode}');
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
