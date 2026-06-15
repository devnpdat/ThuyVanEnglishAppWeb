// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement_test_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlacementTestQuestionDtoImpl _$$PlacementTestQuestionDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PlacementTestQuestionDtoImpl(
      id: json['id'] as String,
      phase: (json['phase'] as num).toInt(),
      orderInPhase: (json['orderInPhase'] as num).toInt(),
      questionText: json['questionText'] as String,
      readingPassage: json['readingPassage'] as String?,
      questionType: json['questionType'] as String,
      optionA: json['optionA'] as String,
      optionB: json['optionB'] as String,
      optionC: json['optionC'] as String,
    );

Map<String, dynamic> _$$PlacementTestQuestionDtoImplToJson(
        _$PlacementTestQuestionDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phase': instance.phase,
      'orderInPhase': instance.orderInPhase,
      'questionText': instance.questionText,
      'readingPassage': instance.readingPassage,
      'questionType': instance.questionType,
      'optionA': instance.optionA,
      'optionB': instance.optionB,
      'optionC': instance.optionC,
    };

_$PlacementTestQuestionsDtoImpl _$$PlacementTestQuestionsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PlacementTestQuestionsDtoImpl(
      totalQuestions: (json['totalQuestions'] as num).toInt(),
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) =>
                  PlacementTestQuestionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$PlacementTestQuestionsDtoImplToJson(
        _$PlacementTestQuestionsDtoImpl instance) =>
    <String, dynamic>{
      'totalQuestions': instance.totalQuestions,
      'questions': instance.questions,
    };

_$PlacementTestAnswerDtoImpl _$$PlacementTestAnswerDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PlacementTestAnswerDtoImpl(
      questionId: json['questionId'] as String,
      selectedOption: json['selectedOption'] as String,
    );

Map<String, dynamic> _$$PlacementTestAnswerDtoImplToJson(
        _$PlacementTestAnswerDtoImpl instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'selectedOption': instance.selectedOption,
    };

_$PlacementTestSubmitDtoImpl _$$PlacementTestSubmitDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PlacementTestSubmitDtoImpl(
      answers: (json['answers'] as List<dynamic>)
          .map(
              (e) => PlacementTestAnswerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PlacementTestSubmitDtoImplToJson(
        _$PlacementTestSubmitDtoImpl instance) =>
    <String, dynamic>{
      'answers': instance.answers,
    };

_$PlacementTestResultDtoImpl _$$PlacementTestResultDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PlacementTestResultDtoImpl(
      totalScore: (json['totalScore'] as num).toInt(),
      totalMaxScore: (json['totalMaxScore'] as num?)?.toInt() ?? 40,
      resultLevel: json['resultLevel'] as String,
      phase1Score: (json['phase1Score'] as num).toInt(),
      phase2Score: (json['phase2Score'] as num).toInt(),
      phase3Score: (json['phase3Score'] as num).toInt(),
      phase4Score: (json['phase4Score'] as num).toInt(),
      phase5Score: (json['phase5Score'] as num).toInt(),
      phase1MaxScore: (json['phase1MaxScore'] as num?)?.toInt() ?? 12,
      phase2MaxScore: (json['phase2MaxScore'] as num?)?.toInt() ?? 8,
      phase3MaxScore: (json['phase3MaxScore'] as num?)?.toInt() ?? 12,
      phase4MaxScore: (json['phase4MaxScore'] as num?)?.toInt() ?? 4,
      phase5MaxScore: (json['phase5MaxScore'] as num?)?.toInt() ?? 4,
      message: json['message'] as String,
      updatedSelfLevel: json['updatedSelfLevel'] as String,
    );

Map<String, dynamic> _$$PlacementTestResultDtoImplToJson(
        _$PlacementTestResultDtoImpl instance) =>
    <String, dynamic>{
      'totalScore': instance.totalScore,
      'totalMaxScore': instance.totalMaxScore,
      'resultLevel': instance.resultLevel,
      'phase1Score': instance.phase1Score,
      'phase2Score': instance.phase2Score,
      'phase3Score': instance.phase3Score,
      'phase4Score': instance.phase4Score,
      'phase5Score': instance.phase5Score,
      'phase1MaxScore': instance.phase1MaxScore,
      'phase2MaxScore': instance.phase2MaxScore,
      'phase3MaxScore': instance.phase3MaxScore,
      'phase4MaxScore': instance.phase4MaxScore,
      'phase5MaxScore': instance.phase5MaxScore,
      'message': instance.message,
      'updatedSelfLevel': instance.updatedSelfLevel,
    };

_$PlacementTestStatusDtoImpl _$$PlacementTestStatusDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$PlacementTestStatusDtoImpl(
      status: json['status'] as String,
      currentLevel: json['currentLevel'] as String,
      lastCompletedAt: json['lastCompletedAt'] as String?,
    );

Map<String, dynamic> _$$PlacementTestStatusDtoImplToJson(
        _$PlacementTestStatusDtoImpl instance) =>
    <String, dynamic>{
      'status': instance.status,
      'currentLevel': instance.currentLevel,
      'lastCompletedAt': instance.lastCompletedAt,
    };
