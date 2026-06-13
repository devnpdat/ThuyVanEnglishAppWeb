import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:english_learning_app/features/review/data/dtos/review_dto.dart';

/// Request để submit review
class SubmitReviewRequest {
  final String sentenceId;
  final int quality;           // 0-5: SM-2 quality rating
  final int timeSpentSeconds;

  SubmitReviewRequest({
    required this.sentenceId,
    required this.quality,
    required this.timeSpentSeconds,
  });

  Map<String, dynamic> toJson() => {
        'sentenceId': sentenceId,
        'quality': quality,
        'timeSpentSeconds': timeSpentSeconds,
      };
}

/// Repository cho Review (Spaced Repetition) API
@injectable
class ReviewRepository {
  final HttpClient _httpClient;

  ReviewRepository(this._httpClient);

  /// GET /api/v1/review/today — lấy các câu cần ôn hôm nay
  Future<ReviewTodayResponseDto> getTodayReviews() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.reviewEndpoint}/today',
      );

      if (response.statusCode == 200 && response.data != null) {
        return ReviewTodayResponseDto.fromJson(response.data!);
      }
      throw Exception('Failed to load today reviews: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET /api/v1/review/progress — tiến độ ôn tập tổng thể
  Future<Map<String, dynamic>> getProgress() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.reviewEndpoint}/progress',
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!;
      }
      throw Exception('Failed to load progress: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST /api/v1/review/submit — nộp kết quả ôn tập
  Future<SubmitReviewResponseDto> submitReview(SubmitReviewRequest request) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.reviewEndpoint}/submit',
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SubmitReviewResponseDto.fromJson(response.data!);
      }
      throw Exception('Failed to submit review: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// GET /api/v1/review/mastered — danh sách câu đã mastered
  Future<List<Map<String, dynamic>>> getMasteredSentences() async {
    try {
      final response = await _httpClient.get<dynamic>(
        '${AppConfig.reviewEndpoint}/mastered',
      );
      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          return (response.data as List)
              .map((e) => e as Map<String, dynamic>)
              .toList();
        }
        final items = (response.data as Map)['items'] as List? ?? [];
        return items.map((e) => e as Map<String, dynamic>).toList();
      }
      throw Exception('Lỗi tải mastered: ${response.statusCode}');
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
        if (code == 404) return Exception('Không tìm thấy dữ liệu ôn tập');
        return Exception('Lỗi server: $code');
      default:
        return Exception('Lỗi mạng: ${e.message}');
    }
  }
}

