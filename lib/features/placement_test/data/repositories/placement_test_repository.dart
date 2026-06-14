import 'package:dio/dio.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/features/placement_test/data/dtos/placement_test_dto.dart';

class PlacementTestRepository {
  final HttpClient _httpClient;

  PlacementTestRepository(this._httpClient);

  Future<PlacementTestQuestionsDto> getQuestions() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.placementTestEndpoint}/questions',
      );
      if (response.statusCode == 200 && response.data != null) {
        return PlacementTestQuestionsDto.fromJson(response.data!);
      }
      throw Exception('Failed to fetch placement test questions: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<PlacementTestResultDto> submit(PlacementTestSubmitDto dto) async {
    try {
      final body = {
        'answers': dto.answers
            .map((a) => {'questionId': a.questionId, 'selectedOption': a.selectedOption})
            .toList(),
      };
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.placementTestEndpoint}/submit',
        data: body,
      );
      if (response.statusCode == 200 && response.data != null) {
        return PlacementTestResultDto.fromJson(response.data!);
      }
      throw Exception('Failed to submit placement test: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<PlacementTestStatusDto> getStatus() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.placementTestEndpoint}/status',
      );
      if (response.statusCode == 200 && response.data != null) {
        return PlacementTestStatusDto.fromJson(response.data!);
      }
      throw Exception('Failed to fetch placement test status: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> requestRetake() async {
    try {
      await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.placementTestEndpoint}/request-retake',
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['error']?['message'] ??
        e.response?.data?.toString() ??
        e.message ??
        'Network error';
    return Exception('[$statusCode] $message');
  }
}
