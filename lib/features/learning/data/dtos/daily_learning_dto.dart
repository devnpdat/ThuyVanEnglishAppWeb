import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:english_learning_app/features/learning/data/dtos/sentence_dto.dart';

part 'daily_learning_dto.freezed.dart';
part 'daily_learning_dto.g.dart';

@freezed
class TodayLearningDto with _$TodayLearningDto {
  const factory TodayLearningDto({
    required String planDate,
    required int totalSentences,
    required int completedCount,
    required int remainingCount,
    @Default([]) List<LearningSessionItemDto> items,
    @Default(false) bool isAlreadyGenerated,
    String? warningMessage,
  }) = _TodayLearningDto;

  factory TodayLearningDto.fromJson(Map<String, dynamic> json) =>
      _$TodayLearningDtoFromJson(json);
}

@freezed
class LearningSessionItemDto with _$LearningSessionItemDto {
  const factory LearningSessionItemDto({
    required String sentenceId,
    required SentenceDto sentence,
    required String progressStatus,
    @Default(false) bool isCompletedToday,
    @Default(0) int totalAudioPlays,
    @Default(0) int totalCorrectTypings,
    @Default(false) bool sessionQuizPassed,
    required int order,
  }) = _LearningSessionItemDto;

  factory LearningSessionItemDto.fromJson(Map<String, dynamic> json) =>
      _$LearningSessionItemDtoFromJson(json);
}

@freezed
class TypingAttemptDto with _$TypingAttemptDto {
  const factory TypingAttemptDto({
    required String userInput,
    @Default(0) int elapsedSeconds,
  }) = _TypingAttemptDto;

  factory TypingAttemptDto.fromJson(Map<String, dynamic> json) =>
      _$TypingAttemptDtoFromJson(json);
}

@freezed
class TypingResultDto with _$TypingResultDto {
  const factory TypingResultDto({
    required bool isCorrect,
    @Default(false) bool isNearlyCorrect,
    required String correctText,
    required String userInput,
    @Default([]) List<TypingDiffSegmentDto> diffSegments,
    @Default(0) int totalCorrectTypings,
    @Default(false) bool canProceedToQuiz,
  }) = _TypingResultDto;

  factory TypingResultDto.fromJson(Map<String, dynamic> json) =>
      _$TypingResultDtoFromJson(json);
}

@freezed
class TypingDiffSegmentDto with _$TypingDiffSegmentDto {
  const factory TypingDiffSegmentDto({
    required String text,
    required String type,
  }) = _TypingDiffSegmentDto;

  factory TypingDiffSegmentDto.fromJson(Map<String, dynamic> json) =>
      _$TypingDiffSegmentDtoFromJson(json);
}

@freezed
class AudioPlayedResultDto with _$AudioPlayedResultDto {
  const factory AudioPlayedResultDto({
    required int totalAudioPlays,
    required bool audioRequirementMet,
  }) = _AudioPlayedResultDto;

  factory AudioPlayedResultDto.fromJson(Map<String, dynamic> json) =>
      _$AudioPlayedResultDtoFromJson(json);
}

@freezed
class SessionCompleteResultDto with _$SessionCompleteResultDto {
  const factory SessionCompleteResultDto({
    required bool success,
    required String message,
    String? newStatus,
    @Default(0) int pointsAwarded,
    DateTime? nextReviewAt,
    @Default([]) List<String> unmetConditions,
  }) = _SessionCompleteResultDto;

  factory SessionCompleteResultDto.fromJson(Map<String, dynamic> json) =>
      _$SessionCompleteResultDtoFromJson(json);
}

@freezed
class SessionQuizSubmitDto with _$SessionQuizSubmitDto {
  const factory SessionQuizSubmitDto({
    required bool isCorrect,
    required String userAnswer,
    required int timeSpentMs,
  }) = _SessionQuizSubmitDto;

  factory SessionQuizSubmitDto.fromJson(Map<String, dynamic> json) =>
      _$SessionQuizSubmitDtoFromJson(json);
}

@freezed
class SessionQuizResultDto with _$SessionQuizResultDto {
  const factory SessionQuizResultDto({
    required bool isCorrect,
    required String feedback,
    required bool sessionQuizPassed,
    required bool canComplete,
    @Default(0) int scoreAwarded,
  }) = _SessionQuizResultDto;

  factory SessionQuizResultDto.fromJson(Map<String, dynamic> json) =>
      _$SessionQuizResultDtoFromJson(json);
}
