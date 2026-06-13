import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:english_learning_app/features/learning/data/dtos/sentence_dto.dart';

class PagedSentenceResult {
  final int totalCount;
  final List<SentenceDto> items;

  PagedSentenceResult({required this.totalCount, required this.items});
}

/// Repository to handle Sentence API calls
@injectable
class SentenceRepository {
  final HttpClient _httpClient;

  SentenceRepository(this._httpClient);

  /// GET /api/v1/sentences — lấy danh sách câu với filter & pagination
  /// Query params theo đúng API doc: SkipCount, MaxResultCount, TopicId, DifficultyLevel, SearchText, SentenceType, SourceType
  Future<PagedSentenceResult> getSentences({
    String? topicId,
    String? difficultyLevel,
    String? sentenceType,
    String? searchText,
    String sourceType = 'system',
    int skipCount = 0,
    int maxResultCount = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'SkipCount': skipCount,
        'MaxResultCount': maxResultCount,
        'SourceType': sourceType,
      };
      if (topicId != null) queryParams['TopicId'] = topicId;
      if (difficultyLevel != null) queryParams['DifficultyLevel'] = difficultyLevel;
      if (sentenceType != null) queryParams['SentenceType'] = sentenceType;
      if (searchText != null && searchText.isNotEmpty) {
        queryParams['SearchText'] = searchText;
      }

      final response = await _httpClient.get<Map<String, dynamic>>(
        AppConfig.sentencesEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        final items = (data['items'] as List<dynamic>? ?? [])
            .map((item) => SentenceDto.fromJson(item as Map<String, dynamic>))
            .toList();
        return PagedSentenceResult(
          totalCount: data['totalCount'] as int? ?? items.length,
          items: items,
        );
      }
      throw Exception('Failed to fetch sentences: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET /api/v1/sentences/{id} — chi tiết 1 câu (kèm media)
  Future<SentenceDto> getSentenceById(String sentenceId) async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.sentencesEndpoint}/$sentenceId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return SentenceDto.fromJson(response.data!);
      }
      throw Exception('Sentence not found: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Không có kết nối mạng');
      case DioExceptionType.receiveTimeout:
        return Exception('Server phản hồi quá chậm');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 404) return Exception('Không tìm thấy câu');
        if (code == 401) return Exception('Phiên đăng nhập hết hạn');
        return Exception('Lỗi server: $code');
      default:
        return Exception('Lỗi mạng: ${e.message}');
    }
  }
}
