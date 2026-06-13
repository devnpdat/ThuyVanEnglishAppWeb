// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sentence_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SentenceMediaDtoImpl _$$SentenceMediaDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$SentenceMediaDtoImpl(
      id: json['id'] as String,
      sentenceId: json['sentenceId'] as String,
      mediaType: json['mediaType'] as String,
      mediaUrl: json['mediaUrl'] as String,
      fileName: json['fileName'] as String? ?? '',
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 0,
      mimeType: json['mimeType'] as String?,
      description: json['description'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt() ?? 1,
      isApproved: json['isApproved'] as bool? ?? false,
    );

Map<String, dynamic> _$$SentenceMediaDtoImplToJson(
        _$SentenceMediaDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sentenceId': instance.sentenceId,
      'mediaType': instance.mediaType,
      'mediaUrl': instance.mediaUrl,
      'fileName': instance.fileName,
      'fileSizeBytes': instance.fileSizeBytes,
      'mimeType': instance.mimeType,
      'description': instance.description,
      'displayOrder': instance.displayOrder,
      'isApproved': instance.isApproved,
    };

_$SentenceDtoImpl _$$SentenceDtoImplFromJson(Map<String, dynamic> json) =>
    _$SentenceDtoImpl(
      id: json['id'] as String,
      vietnameseText: json['vietnameseseText'] as String? ?? '',
      englishText: json['englishText'] as String,
      difficultyLevel: json['difficultyLevel'] as String? ?? 'medium',
      sentenceType: json['sentenceType'] as String? ?? 'conversation',
      sourceType: json['sourceType'] as String? ?? 'system',
      topicId: json['topicId'] as String?,
      ownerUserId: json['ownerUserId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      medias: (json['medias'] as List<dynamic>?)
              ?.map((e) => SentenceMediaDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      creationTime: json['creationTime'] == null
          ? null
          : DateTime.parse(json['creationTime'] as String),
    );

Map<String, dynamic> _$$SentenceDtoImplToJson(_$SentenceDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vietnameseseText': instance.vietnameseText,
      'englishText': instance.englishText,
      'difficultyLevel': instance.difficultyLevel,
      'sentenceType': instance.sentenceType,
      'sourceType': instance.sourceType,
      'topicId': instance.topicId,
      'ownerUserId': instance.ownerUserId,
      'isActive': instance.isActive,
      'medias': instance.medias,
      'creationTime': instance.creationTime?.toIso8601String(),
    };
