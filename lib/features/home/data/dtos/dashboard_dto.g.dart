// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardDtoImpl _$$DashboardDtoImplFromJson(Map<String, dynamic> json) =>
    _$DashboardDtoImpl(
      totalSentencesLearned:
          (json['totalSentencesLearned'] as num?)?.toInt() ?? 0,
      totalSentencesMastered:
          (json['totalSentencesMastered'] as num?)?.toInt() ?? 0,
      todayCompleted: (json['todayCompleted'] as num?)?.toInt() ?? 0,
      todayTarget: (json['todayTarget'] as num?)?.toInt() ?? 0,
      reviewDueToday: (json['reviewDueToday'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      overallAccuracy: (json['overallAccuracy'] as num?)?.toDouble() ?? 0.0,
      lastActivityAt: json['lastActivityAt'] == null
          ? null
          : DateTime.parse(json['lastActivityAt'] as String),
    );

Map<String, dynamic> _$$DashboardDtoImplToJson(_$DashboardDtoImpl instance) =>
    <String, dynamic>{
      'totalSentencesLearned': instance.totalSentencesLearned,
      'totalSentencesMastered': instance.totalSentencesMastered,
      'todayCompleted': instance.todayCompleted,
      'todayTarget': instance.todayTarget,
      'reviewDueToday': instance.reviewDueToday,
      'streakDays': instance.streakDays,
      'totalPoints': instance.totalPoints,
      'rank': instance.rank,
      'overallAccuracy': instance.overallAccuracy,
      'lastActivityAt': instance.lastActivityAt?.toIso8601String(),
    };
