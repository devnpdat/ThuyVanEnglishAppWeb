import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_dto.freezed.dart';
part 'dashboard_dto.g.dart';

@freezed
class DashboardDto with _$DashboardDto {
  const factory DashboardDto({
    @Default(0) int totalSentencesLearned,
    @Default(0) int totalSentencesMastered,
    @Default(0) int todayCompleted,
    @Default(0) int todayTarget,
    @Default(0) int reviewDueToday,
    @Default(0) int streakDays,
    @Default(0) int totalPoints,
    @Default(0) int rank,
    @Default(0.0) double overallAccuracy,
    DateTime? lastActivityAt,
    String? selfLevel,
    @Default(false) bool hasTakenPlacementTest,
  }) = _DashboardDto;

  factory DashboardDto.fromJson(Map<String, dynamic> json) =>
      _$DashboardDtoFromJson(json);
}
