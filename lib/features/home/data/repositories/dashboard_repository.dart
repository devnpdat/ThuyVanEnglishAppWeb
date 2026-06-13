import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:english_learning_app/features/home/data/dtos/dashboard_dto.dart';

@injectable
class DashboardRepository {
  final HttpClient _httpClient;

  DashboardRepository(this._httpClient);

  Future<DashboardDto> getDashboardStats() async {
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        AppConfig.dashboardEndpoint,
      );

      if (response.statusCode == 200 && response.data != null) {
        return DashboardDto.fromJson(response.data!);
      }
      throw Exception('Failed to fetch dashboard stats: ${response.statusCode}');
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
