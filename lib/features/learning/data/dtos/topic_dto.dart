import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_dto.freezed.dart';
part 'topic_dto.g.dart';

/// Data Transfer Object for Topic
@freezed
class TopicDto with _$TopicDto {
  const factory TopicDto({
    required String id,
    required String topicName,
    required String slug,
    String? description,
    String? sourceType,
    @Default(0) int sentenceCount,
    @Default('📚') String iconEmoji,
    @Default(true) bool isActive,
    DateTime? createdAt,
  }) = _TopicDto;

  factory TopicDto.fromJson(Map<String, dynamic> json) =>
      _$TopicDtoFromJson(json);
}

/// Result wrapper for paged topic list
class PagedTopicResult {
  final int totalCount;
  final List<TopicDto> items;

  PagedTopicResult({
    required this.totalCount,
    required this.items,
  });
}
