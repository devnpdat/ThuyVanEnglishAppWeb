import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/config/app_config.dart';

// ─── DTOs ────────────────────────────────────────────────────────────────────

class LearningPlanSummaryDto {
  final String id;
  final String planName;
  final String? description;
  final String status; // draft, active, completed, cancelled
  final String? targetCompletionDate;
  final String difficultyLevel;
  final int totalItems;
  final int completedItems;
  final double progressPercentage;
  final String? createdAt;
  final String? activatedAt;
  final String? completedAt;

  LearningPlanSummaryDto({
    required this.id,
    required this.planName,
    this.description,
    required this.status,
    this.targetCompletionDate,
    required this.difficultyLevel,
    required this.totalItems,
    required this.completedItems,
    required this.progressPercentage,
    this.createdAt,
    this.activatedAt,
    this.completedAt,
  });

  factory LearningPlanSummaryDto.fromJson(Map<String, dynamic> json) =>
      LearningPlanSummaryDto(
        id: json['id'] as String? ?? '',
        planName: json['planName'] as String? ?? 'Untitled Plan',
        description: json['description'] as String?,
        status: json['status'] as String? ?? 'draft',
        targetCompletionDate: json['targetCompletionDate'] as String?,
        difficultyLevel: json['difficultyLevel'] as String? ?? 'medium',
        totalItems: json['totalItems'] as int? ?? 0,
        completedItems: json['completedItems'] as int? ?? 0,
        progressPercentage:
            (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
        createdAt: json['createdAt'] as String?,
        activatedAt: json['activatedAt'] as String?,
        completedAt: json['completedAt'] as String?,
      );
}

class LearningPlanItemDto {
  final String id;
  final String planId;
  final String sentenceId;
  final String englishText;
  final String vietnameseseText;
  final String difficultyLevel;
  final String? topicName;
  final String? audioUrl;
  final int displayOrder;
  final bool isCompleted;
  final String? completedAt;

  LearningPlanItemDto({
    required this.id,
    required this.planId,
    required this.sentenceId,
    required this.englishText,
    required this.vietnameseseText,
    required this.difficultyLevel,
    this.topicName,
    this.audioUrl,
    required this.displayOrder,
    required this.isCompleted,
    this.completedAt,
  });

  factory LearningPlanItemDto.fromJson(Map<String, dynamic> json) =>
      LearningPlanItemDto(
        id: json['id'] as String? ?? '',
        planId: json['planId'] as String? ?? '',
        sentenceId: json['sentenceId'] as String? ?? '',
        englishText: json['englishText'] as String? ?? '',
        vietnameseseText: json['vietnameseseText'] as String? ?? '',
        difficultyLevel: json['difficultyLevel'] as String? ?? 'medium',
        topicName: json['topicName'] as String?,
        audioUrl: json['audioUrl'] as String?,
        displayOrder: json['displayOrder'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? false,
        completedAt: json['completedAt'] as String?,
      );
}

class CreateLearningPlanDto {
  final String planName;
  final String? description;
  final String targetCompletionDate; // ISO date string
  final String difficultyLevel;
  final List<String> topicIds;
  final int sentenceCount;

  CreateLearningPlanDto({
    required this.planName,
    this.description,
    required this.targetCompletionDate,
    this.difficultyLevel = 'medium',
    required this.topicIds,
    required this.sentenceCount,
  });

  Map<String, dynamic> toJson() => {
        'planName': planName,
        if (description != null) 'description': description,
        'targetCompletionDate': targetCompletionDate,
        'difficultyLevel': difficultyLevel,
        'topicIds': topicIds,
        'sentenceCount': sentenceCount,
      };
}

// ─── Repository ───────────────────────────────────────────────────────────────

@injectable
class LearningPlanRepository {
  final HttpClient _httpClient;

  LearningPlanRepository(this._httpClient);

  /// GET /api/v1/learningplan — Danh sách kế hoạch của user
  Future<List<LearningPlanSummaryDto>> getPlans({String? status}) async {
    try {
      final params = <String, dynamic>{
        'MaxResultCount': 50,
        if (status != null) 'Status': status,
      };
      final response = await _httpClient.get<Map<String, dynamic>>(
        AppConfig.learningPlanEndpoint,
        queryParameters: params,
      );
      if (response.statusCode == 200 && response.data != null) {
        final items = response.data!['items'] as List? ?? [];
        return items
            .map((e) =>
                LearningPlanSummaryDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Lỗi tải danh sách plan: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST /api/v1/learningplan — Tạo kế hoạch mới
  Future<LearningPlanSummaryDto> createPlan(CreateLearningPlanDto dto) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        AppConfig.learningPlanEndpoint,
        data: dto.toJson(),
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return LearningPlanSummaryDto.fromJson(response.data!);
      }
      throw Exception('Lỗi tạo plan: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST /api/v1/learningplan/{id}/activate — Kích hoạt plan
  Future<LearningPlanSummaryDto> activatePlan(String planId) async {
    try {
      final response = await _httpClient.post<Map<String, dynamic>>(
        '${AppConfig.learningPlanEndpoint}/$planId/activate',
      );
      if (response.statusCode == 200 && response.data != null) {
        return LearningPlanSummaryDto.fromJson(response.data!);
      }
      throw Exception('Lỗi kích hoạt plan: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// GET /api/v1/learningplan/{id}/items — Items của plan
  Future<List<LearningPlanItemDto>> getPlanItems(String planId) async {
    try {
      final response = await _httpClient.get<dynamic>(
        '${AppConfig.learningPlanEndpoint}/$planId/items',
      );
      if (response.statusCode == 200 && response.data != null) {
        final list = response.data is List
            ? response.data as List
            : (response.data as Map)['items'] as List? ?? [];
        return list
            .map((e) =>
                LearningPlanItemDto.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      throw Exception('Lỗi tải plan items: ${response.statusCode}');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Không có kết nối mạng');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        final data = e.response?.data;
        final msg = (data is Map)
            ? (data['error']?['message'] as String? ?? 'Lỗi server $code')
            : 'Lỗi server $code';
        return Exception(msg);
      default:
        return Exception('Lỗi mạng: ${e.message}');
    }
  }
}
