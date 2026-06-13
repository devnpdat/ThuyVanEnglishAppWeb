// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sentence_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SentenceMediaDto _$SentenceMediaDtoFromJson(Map<String, dynamic> json) {
  return _SentenceMediaDto.fromJson(json);
}

/// @nodoc
mixin _$SentenceMediaDto {
  String get id => throw _privateConstructorUsedError;
  String get sentenceId => throw _privateConstructorUsedError;
  String get mediaType =>
      throw _privateConstructorUsedError; // 'audio' | 'image' | 'video'
  String get mediaUrl => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  int get fileSizeBytes => throw _privateConstructorUsedError;
  String? get mimeType => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get displayOrder => throw _privateConstructorUsedError;
  bool get isApproved => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SentenceMediaDtoCopyWith<SentenceMediaDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SentenceMediaDtoCopyWith<$Res> {
  factory $SentenceMediaDtoCopyWith(
          SentenceMediaDto value, $Res Function(SentenceMediaDto) then) =
      _$SentenceMediaDtoCopyWithImpl<$Res, SentenceMediaDto>;
  @useResult
  $Res call(
      {String id,
      String sentenceId,
      String mediaType,
      String mediaUrl,
      String fileName,
      int fileSizeBytes,
      String? mimeType,
      String? description,
      int displayOrder,
      bool isApproved});
}

/// @nodoc
class _$SentenceMediaDtoCopyWithImpl<$Res, $Val extends SentenceMediaDto>
    implements $SentenceMediaDtoCopyWith<$Res> {
  _$SentenceMediaDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sentenceId = null,
    Object? mediaType = null,
    Object? mediaUrl = null,
    Object? fileName = null,
    Object? fileSizeBytes = null,
    Object? mimeType = freezed,
    Object? description = freezed,
    Object? displayOrder = null,
    Object? isApproved = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sentenceId: null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SentenceMediaDtoImplCopyWith<$Res>
    implements $SentenceMediaDtoCopyWith<$Res> {
  factory _$$SentenceMediaDtoImplCopyWith(_$SentenceMediaDtoImpl value,
          $Res Function(_$SentenceMediaDtoImpl) then) =
      __$$SentenceMediaDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sentenceId,
      String mediaType,
      String mediaUrl,
      String fileName,
      int fileSizeBytes,
      String? mimeType,
      String? description,
      int displayOrder,
      bool isApproved});
}

/// @nodoc
class __$$SentenceMediaDtoImplCopyWithImpl<$Res>
    extends _$SentenceMediaDtoCopyWithImpl<$Res, _$SentenceMediaDtoImpl>
    implements _$$SentenceMediaDtoImplCopyWith<$Res> {
  __$$SentenceMediaDtoImplCopyWithImpl(_$SentenceMediaDtoImpl _value,
      $Res Function(_$SentenceMediaDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sentenceId = null,
    Object? mediaType = null,
    Object? mediaUrl = null,
    Object? fileName = null,
    Object? fileSizeBytes = null,
    Object? mimeType = freezed,
    Object? description = freezed,
    Object? displayOrder = null,
    Object? isApproved = null,
  }) {
    return _then(_$SentenceMediaDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sentenceId: null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      mediaUrl: null == mediaUrl
          ? _value.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSizeBytes: null == fileSizeBytes
          ? _value.fileSizeBytes
          : fileSizeBytes // ignore: cast_nullable_to_non_nullable
              as int,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      displayOrder: null == displayOrder
          ? _value.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int,
      isApproved: null == isApproved
          ? _value.isApproved
          : isApproved // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SentenceMediaDtoImpl implements _SentenceMediaDto {
  const _$SentenceMediaDtoImpl(
      {required this.id,
      required this.sentenceId,
      required this.mediaType,
      required this.mediaUrl,
      this.fileName = '',
      this.fileSizeBytes = 0,
      this.mimeType,
      this.description,
      this.displayOrder = 1,
      this.isApproved = false});

  factory _$SentenceMediaDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SentenceMediaDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String sentenceId;
  @override
  final String mediaType;
// 'audio' | 'image' | 'video'
  @override
  final String mediaUrl;
  @override
  @JsonKey()
  final String fileName;
  @override
  @JsonKey()
  final int fileSizeBytes;
  @override
  final String? mimeType;
  @override
  final String? description;
  @override
  @JsonKey()
  final int displayOrder;
  @override
  @JsonKey()
  final bool isApproved;

  @override
  String toString() {
    return 'SentenceMediaDto(id: $id, sentenceId: $sentenceId, mediaType: $mediaType, mediaUrl: $mediaUrl, fileName: $fileName, fileSizeBytes: $fileSizeBytes, mimeType: $mimeType, description: $description, displayOrder: $displayOrder, isApproved: $isApproved)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SentenceMediaDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sentenceId, sentenceId) ||
                other.sentenceId == sentenceId) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSizeBytes, fileSizeBytes) ||
                other.fileSizeBytes == fileSizeBytes) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isApproved, isApproved) ||
                other.isApproved == isApproved));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sentenceId,
      mediaType,
      mediaUrl,
      fileName,
      fileSizeBytes,
      mimeType,
      description,
      displayOrder,
      isApproved);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SentenceMediaDtoImplCopyWith<_$SentenceMediaDtoImpl> get copyWith =>
      __$$SentenceMediaDtoImplCopyWithImpl<_$SentenceMediaDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SentenceMediaDtoImplToJson(
      this,
    );
  }
}

abstract class _SentenceMediaDto implements SentenceMediaDto {
  const factory _SentenceMediaDto(
      {required final String id,
      required final String sentenceId,
      required final String mediaType,
      required final String mediaUrl,
      final String fileName,
      final int fileSizeBytes,
      final String? mimeType,
      final String? description,
      final int displayOrder,
      final bool isApproved}) = _$SentenceMediaDtoImpl;

  factory _SentenceMediaDto.fromJson(Map<String, dynamic> json) =
      _$SentenceMediaDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get sentenceId;
  @override
  String get mediaType;
  @override // 'audio' | 'image' | 'video'
  String get mediaUrl;
  @override
  String get fileName;
  @override
  int get fileSizeBytes;
  @override
  String? get mimeType;
  @override
  String? get description;
  @override
  int get displayOrder;
  @override
  bool get isApproved;
  @override
  @JsonKey(ignore: true)
  _$$SentenceMediaDtoImplCopyWith<_$SentenceMediaDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SentenceDto _$SentenceDtoFromJson(Map<String, dynamic> json) {
  return _SentenceDto.fromJson(json);
}

/// @nodoc
mixin _$SentenceDto {
  String get id =>
      throw _privateConstructorUsedError; // API trả 'vietnameseseText' (3 chữ 'e') — đây là field name thực tế
  @JsonKey(name: 'vietnameseseText')
  String get vietnameseText => throw _privateConstructorUsedError;
  String get englishText => throw _privateConstructorUsedError;
  String get difficultyLevel => throw _privateConstructorUsedError;
  String get sentenceType =>
      throw _privateConstructorUsedError; // conversation|grammar|vocabulary
  String get sourceType =>
      throw _privateConstructorUsedError; // system|user_generated
  String? get topicId => throw _privateConstructorUsedError;
  String? get ownerUserId => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  List<SentenceMediaDto> get medias => throw _privateConstructorUsedError;
  DateTime? get creationTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SentenceDtoCopyWith<SentenceDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SentenceDtoCopyWith<$Res> {
  factory $SentenceDtoCopyWith(
          SentenceDto value, $Res Function(SentenceDto) then) =
      _$SentenceDtoCopyWithImpl<$Res, SentenceDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vietnameseseText') String vietnameseText,
      String englishText,
      String difficultyLevel,
      String sentenceType,
      String sourceType,
      String? topicId,
      String? ownerUserId,
      bool isActive,
      List<SentenceMediaDto> medias,
      DateTime? creationTime});
}

/// @nodoc
class _$SentenceDtoCopyWithImpl<$Res, $Val extends SentenceDto>
    implements $SentenceDtoCopyWith<$Res> {
  _$SentenceDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vietnameseText = null,
    Object? englishText = null,
    Object? difficultyLevel = null,
    Object? sentenceType = null,
    Object? sourceType = null,
    Object? topicId = freezed,
    Object? ownerUserId = freezed,
    Object? isActive = null,
    Object? medias = null,
    Object? creationTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vietnameseText: null == vietnameseText
          ? _value.vietnameseText
          : vietnameseText // ignore: cast_nullable_to_non_nullable
              as String,
      englishText: null == englishText
          ? _value.englishText
          : englishText // ignore: cast_nullable_to_non_nullable
              as String,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as String,
      sentenceType: null == sentenceType
          ? _value.sentenceType
          : sentenceType // ignore: cast_nullable_to_non_nullable
              as String,
      sourceType: null == sourceType
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: freezed == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerUserId: freezed == ownerUserId
          ? _value.ownerUserId
          : ownerUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      medias: null == medias
          ? _value.medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<SentenceMediaDto>,
      creationTime: freezed == creationTime
          ? _value.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SentenceDtoImplCopyWith<$Res>
    implements $SentenceDtoCopyWith<$Res> {
  factory _$$SentenceDtoImplCopyWith(
          _$SentenceDtoImpl value, $Res Function(_$SentenceDtoImpl) then) =
      __$$SentenceDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'vietnameseseText') String vietnameseText,
      String englishText,
      String difficultyLevel,
      String sentenceType,
      String sourceType,
      String? topicId,
      String? ownerUserId,
      bool isActive,
      List<SentenceMediaDto> medias,
      DateTime? creationTime});
}

/// @nodoc
class __$$SentenceDtoImplCopyWithImpl<$Res>
    extends _$SentenceDtoCopyWithImpl<$Res, _$SentenceDtoImpl>
    implements _$$SentenceDtoImplCopyWith<$Res> {
  __$$SentenceDtoImplCopyWithImpl(
      _$SentenceDtoImpl _value, $Res Function(_$SentenceDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vietnameseText = null,
    Object? englishText = null,
    Object? difficultyLevel = null,
    Object? sentenceType = null,
    Object? sourceType = null,
    Object? topicId = freezed,
    Object? ownerUserId = freezed,
    Object? isActive = null,
    Object? medias = null,
    Object? creationTime = freezed,
  }) {
    return _then(_$SentenceDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vietnameseText: null == vietnameseText
          ? _value.vietnameseText
          : vietnameseText // ignore: cast_nullable_to_non_nullable
              as String,
      englishText: null == englishText
          ? _value.englishText
          : englishText // ignore: cast_nullable_to_non_nullable
              as String,
      difficultyLevel: null == difficultyLevel
          ? _value.difficultyLevel
          : difficultyLevel // ignore: cast_nullable_to_non_nullable
              as String,
      sentenceType: null == sentenceType
          ? _value.sentenceType
          : sentenceType // ignore: cast_nullable_to_non_nullable
              as String,
      sourceType: null == sourceType
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: freezed == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String?,
      ownerUserId: freezed == ownerUserId
          ? _value.ownerUserId
          : ownerUserId // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      medias: null == medias
          ? _value._medias
          : medias // ignore: cast_nullable_to_non_nullable
              as List<SentenceMediaDto>,
      creationTime: freezed == creationTime
          ? _value.creationTime
          : creationTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SentenceDtoImpl implements _SentenceDto {
  const _$SentenceDtoImpl(
      {required this.id,
      @JsonKey(name: 'vietnameseseText') this.vietnameseText = '',
      required this.englishText,
      this.difficultyLevel = 'medium',
      this.sentenceType = 'conversation',
      this.sourceType = 'system',
      this.topicId,
      this.ownerUserId,
      this.isActive = true,
      final List<SentenceMediaDto> medias = const [],
      this.creationTime})
      : _medias = medias;

  factory _$SentenceDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SentenceDtoImplFromJson(json);

  @override
  final String id;
// API trả 'vietnameseseText' (3 chữ 'e') — đây là field name thực tế
  @override
  @JsonKey(name: 'vietnameseseText')
  final String vietnameseText;
  @override
  final String englishText;
  @override
  @JsonKey()
  final String difficultyLevel;
  @override
  @JsonKey()
  final String sentenceType;
// conversation|grammar|vocabulary
  @override
  @JsonKey()
  final String sourceType;
// system|user_generated
  @override
  final String? topicId;
  @override
  final String? ownerUserId;
  @override
  @JsonKey()
  final bool isActive;
  final List<SentenceMediaDto> _medias;
  @override
  @JsonKey()
  List<SentenceMediaDto> get medias {
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medias);
  }

  @override
  final DateTime? creationTime;

  @override
  String toString() {
    return 'SentenceDto(id: $id, vietnameseText: $vietnameseText, englishText: $englishText, difficultyLevel: $difficultyLevel, sentenceType: $sentenceType, sourceType: $sourceType, topicId: $topicId, ownerUserId: $ownerUserId, isActive: $isActive, medias: $medias, creationTime: $creationTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SentenceDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vietnameseText, vietnameseText) ||
                other.vietnameseText == vietnameseText) &&
            (identical(other.englishText, englishText) ||
                other.englishText == englishText) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.sentenceType, sentenceType) ||
                other.sentenceType == sentenceType) &&
            (identical(other.sourceType, sourceType) ||
                other.sourceType == sourceType) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.ownerUserId, ownerUserId) ||
                other.ownerUserId == ownerUserId) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            const DeepCollectionEquality().equals(other._medias, _medias) &&
            (identical(other.creationTime, creationTime) ||
                other.creationTime == creationTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vietnameseText,
      englishText,
      difficultyLevel,
      sentenceType,
      sourceType,
      topicId,
      ownerUserId,
      isActive,
      const DeepCollectionEquality().hash(_medias),
      creationTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SentenceDtoImplCopyWith<_$SentenceDtoImpl> get copyWith =>
      __$$SentenceDtoImplCopyWithImpl<_$SentenceDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SentenceDtoImplToJson(
      this,
    );
  }
}

abstract class _SentenceDto implements SentenceDto {
  const factory _SentenceDto(
      {required final String id,
      @JsonKey(name: 'vietnameseseText') final String vietnameseText,
      required final String englishText,
      final String difficultyLevel,
      final String sentenceType,
      final String sourceType,
      final String? topicId,
      final String? ownerUserId,
      final bool isActive,
      final List<SentenceMediaDto> medias,
      final DateTime? creationTime}) = _$SentenceDtoImpl;

  factory _SentenceDto.fromJson(Map<String, dynamic> json) =
      _$SentenceDtoImpl.fromJson;

  @override
  String get id;
  @override // API trả 'vietnameseseText' (3 chữ 'e') — đây là field name thực tế
  @JsonKey(name: 'vietnameseseText')
  String get vietnameseText;
  @override
  String get englishText;
  @override
  String get difficultyLevel;
  @override
  String get sentenceType;
  @override // conversation|grammar|vocabulary
  String get sourceType;
  @override // system|user_generated
  String? get topicId;
  @override
  String? get ownerUserId;
  @override
  bool get isActive;
  @override
  List<SentenceMediaDto> get medias;
  @override
  DateTime? get creationTime;
  @override
  @JsonKey(ignore: true)
  _$$SentenceDtoImplCopyWith<_$SentenceDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
