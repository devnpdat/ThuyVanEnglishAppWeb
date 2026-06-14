import 'package:freezed_annotation/freezed_annotation.dart';

part 'placement_test_dto.freezed.dart';
part 'placement_test_dto.g.dart';

// ─── Question ────────────────────────────────────────────────────────────────

@freezed
class PlacementTestQuestionDto with _$PlacementTestQuestionDto {
  const factory PlacementTestQuestionDto({
    required String id,
    required int phase,
    required int orderInPhase,
    required String questionText,
    String? readingPassage,
    required String questionType,
    required String optionA,
    required String optionB,
    required String optionC,
  }) = _PlacementTestQuestionDto;

  factory PlacementTestQuestionDto.fromJson(Map<String, dynamic> json) =>
      _$PlacementTestQuestionDtoFromJson(json);
}

@freezed
class PlacementTestQuestionsDto with _$PlacementTestQuestionsDto {
  const factory PlacementTestQuestionsDto({
    required int totalQuestions,
    @Default([]) List<PlacementTestQuestionDto> questions,
  }) = _PlacementTestQuestionsDto;

  factory PlacementTestQuestionsDto.fromJson(Map<String, dynamic> json) =>
      _$PlacementTestQuestionsDtoFromJson(json);
}

// ─── Submit ──────────────────────────────────────────────────────────────────

@freezed
class PlacementTestAnswerDto with _$PlacementTestAnswerDto {
  const factory PlacementTestAnswerDto({
    required String questionId,
    required String selectedOption,
  }) = _PlacementTestAnswerDto;

  factory PlacementTestAnswerDto.fromJson(Map<String, dynamic> json) =>
      _$PlacementTestAnswerDtoFromJson(json);
}

@freezed
class PlacementTestSubmitDto with _$PlacementTestSubmitDto {
  const factory PlacementTestSubmitDto({
    required List<PlacementTestAnswerDto> answers,
  }) = _PlacementTestSubmitDto;

  factory PlacementTestSubmitDto.fromJson(Map<String, dynamic> json) =>
      _$PlacementTestSubmitDtoFromJson(json);
}

// ─── Result ──────────────────────────────────────────────────────────────────

@freezed
class PlacementTestResultDto with _$PlacementTestResultDto {
  const factory PlacementTestResultDto({
    required int totalScore,
    required String resultLevel,
    required int phase1Score,
    required int phase2Score,
    required int phase3Score,
    required int phase4Score,
    required int phase5Score,
    required String message,
    required String updatedSelfLevel,
  }) = _PlacementTestResultDto;

  factory PlacementTestResultDto.fromJson(Map<String, dynamic> json) =>
      _$PlacementTestResultDtoFromJson(json);
}

// ─── Status ──────────────────────────────────────────────────────────────────

@freezed
class PlacementTestStatusDto with _$PlacementTestStatusDto {
  const factory PlacementTestStatusDto({
    required String status,
    required String currentLevel,
    String? lastCompletedAt,
  }) = _PlacementTestStatusDto;

  factory PlacementTestStatusDto.fromJson(Map<String, dynamic> json) =>
      _$PlacementTestStatusDtoFromJson(json);
}
