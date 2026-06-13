import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:english_learning_app/features/learning/data/dtos/topic_dto.dart';

/// Repository to handle Topic API calls
@injectable
class TopicRepository {
  final HttpClient _httpClient;

  TopicRepository(this._httpClient);

  /// Get all topics with pagination
  Future<PagedTopicResult> getTopics({
    int pageIndex = 0,
    int pageSize = 10,
    String? sorting,
  }) async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.topicsEndpoint}?pageIndex=$pageIndex&pageSize=$pageSize' +
            (sorting != null ? '&sorting=$sorting' : ''),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data!;
        return PagedTopicResult(
          totalCount: data['totalCount'] as int? ?? 0,
          items: (data['items'] as List?)
                  ?.map((item) => TopicDto.fromJson(item as Map<String, dynamic>))
                  .toList() ??
              [],
        );
      }
      throw Exception('Failed to fetch topics: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Get single topic by ID
  Future<TopicDto> getTopicById(String topicId) async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.topicsEndpoint}/$topicId',
      );

      if (response.statusCode == 200 && response.data != null) {
        return TopicDto.fromJson(response.data!);
      }
      throw Exception('Failed to fetch topic: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Create new topic (admin only)
  Future<TopicDto> createTopic({
    required String topicName,
    required String description,
    required String iconEmoji,
  }) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        AppConfig.topicsEndpoint,
        data: {
          'topicName': topicName,
          'description': description,
          'iconEmoji': iconEmoji,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        return TopicDto.fromJson(response.data!);
      }
      throw Exception('Failed to create topic: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Update topic (admin only)
  Future<TopicDto> updateTopic(
    String topicId, {
    String? topicName,
    String? description,
    String? iconEmoji,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (topicName != null) data['topicName'] = topicName;
      if (description != null) data['description'] = description;
      if (iconEmoji != null) data['iconEmoji'] = iconEmoji;

      final response = await _httpClient.put<Map<String, dynamic>>(
        '${AppConfig.topicsEndpoint}/$topicId',
        data: data,
      );

      if (response.statusCode == 200 && response.data != null) {
        return TopicDto.fromJson(response.data!);
      }
      throw Exception('Failed to update topic: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Delete topic (admin only)
  Future<void> deleteTopic(String topicId) async {
    try {
      final response = await _httpClient.delete(
        '${AppConfig.topicsEndpoint}/$topicId',
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete topic: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors with user-friendly messages
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Connection timeout - check your internet');
      case DioExceptionType.receiveTimeout:
        return Exception('Server response timeout');
      case DioExceptionType.sendTimeout:
        return Exception('Request timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return Exception('Unauthorized - please login');
        } else if (statusCode == 403) {
          return Exception('Forbidden - you do not have access');
        } else if (statusCode == 404) {
          return Exception('Topic not found');
        } else if (statusCode == 500) {
          return Exception('Server error - please try later');
        }
        return Exception('Error: $statusCode');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      case DioExceptionType.unknown:
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}

/// DTO classes
class PagedTopicResult {
  final int totalCount;
  final List<TopicDto> items;

  PagedTopicResult({
    required this.totalCount,
    required this.items,
  });
}
