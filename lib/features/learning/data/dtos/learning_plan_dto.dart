import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning_plan_dto.freezed.dart';
part 'learning_plan_dto.g.dart';

/// Data Transfer Object for Learning Plan
@freezed
class LearningPlanDto with _$LearningPlanDto {
  const factory LearningPlanDto({
    required String id,
    required String userId,
    required String topicId,
    required String planType, // 'daily' | 'weekly' | 'custom'
    @Default(5) int dailyTargetSentences,
    @Default([]) List<String> selectedDayOfWeek,
    @Default(0) int completedSentences,
    @Default(false) bool isActive,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LearningPlanDto;

  factory LearningPlanDto.fromJson(Map<String, dynamic> json) =>
      _$LearningPlanDtoFromJson(json);
}

/// Learning Progress DTO
@freezed
class LearningProgressDto with _$LearningProgressDto {
  const factory LearningProgressDto({
    required String id,
    required String userId,
    required String sentenceId,
    required String planId,
    @Default(0) int reviewCount,
    @Default(0) int correctCount,
    @Default('learning') String masteryLevel, // 'learning' | 'reviewing' | 'mastered'
    DateTime? lastReviewedAt,
    DateTime? masteredAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LearningProgressDto;

  factory LearningProgressDto.fromJson(Map<String, dynamic> json) =>
      _$LearningProgressDtoFromJson(json);
}
