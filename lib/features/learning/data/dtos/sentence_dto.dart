import 'package:freezed_annotation/freezed_annotation.dart';

part 'sentence_dto.freezed.dart';
part 'sentence_dto.g.dart';

/// Media đính kèm câu (audio/image)
@freezed
class SentenceMediaDto with _$SentenceMediaDto {
  const factory SentenceMediaDto({
    required String id,
    required String sentenceId,
    required String mediaType,    // 'audio' | 'image' | 'video'
    required String mediaUrl,
    @Default('') String fileName,
    @Default(0) int fileSizeBytes,
    String? mimeType,
    String? description,
    @Default(1) int displayOrder,
    @Default(false) bool isApproved,
  }) = _SentenceMediaDto;

  factory SentenceMediaDto.fromJson(Map<String, dynamic> json) =>
      _$SentenceMediaDtoFromJson(json);
}

/// Sentence DTO — khớp với API response field names
@freezed
class SentenceDto with _$SentenceDto {
  const factory SentenceDto({
    required String id,
    // API trả 'vietnameseseText' (3 chữ 'e') — đây là field name thực tế
    @JsonKey(name: 'vietnameseseText') @Default('') String vietnameseText,
    required String englishText,
    @Default('medium') String difficultyLevel,
    @Default('conversation') String sentenceType,  // conversation|grammar|vocabulary
    @Default('system') String sourceType,           // system|user_generated
    String? topicId,
    String? ownerUserId,
    @Default(true) bool isActive,
    @Default([]) List<SentenceMediaDto> medias,
    DateTime? creationTime,
  }) = _SentenceDto;

  factory SentenceDto.fromJson(Map<String, dynamic> json) =>
      _$SentenceDtoFromJson(json);
}

/// Helper extension để lấy audio URL đầu tiên
extension SentenceDtoX on SentenceDto {
  String? get audioUrl {
    try {
      return medias
          .firstWhere((m) => m.mediaType == 'audio' && m.isApproved)
          .mediaUrl;
    } catch (_) {
      return null;
    }
  }

  String? get imageUrl {
    try {
      return medias
          .firstWhere((m) => m.mediaType == 'image' && m.isApproved)
          .mediaUrl;
    } catch (_) {
      return null;
    }
  }
}
