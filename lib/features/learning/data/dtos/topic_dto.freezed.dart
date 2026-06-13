// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TopicDto _$TopicDtoFromJson(Map<String, dynamic> json) {
  return _TopicDto.fromJson(json);
}

/// @nodoc
mixin _$TopicDto {
  String get id => throw _privateConstructorUsedError;
  String get topicName => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get sourceType => throw _privateConstructorUsedError;
  int get sentenceCount => throw _privateConstructorUsedError;
  String get iconEmoji => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TopicDtoCopyWith<TopicDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicDtoCopyWith<$Res> {
  factory $TopicDtoCopyWith(TopicDto value, $Res Function(TopicDto) then) =
      _$TopicDtoCopyWithImpl<$Res, TopicDto>;
  @useResult
  $Res call(
      {String id,
      String topicName,
      String slug,
      String? description,
      String? sourceType,
      int sentenceCount,
      String iconEmoji,
      bool isActive,
      DateTime? createdAt});
}

/// @nodoc
class _$TopicDtoCopyWithImpl<$Res, $Val extends TopicDto>
    implements $TopicDtoCopyWith<$Res> {
  _$TopicDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicName = null,
    Object? slug = null,
    Object? description = freezed,
    Object? sourceType = freezed,
    Object? sentenceCount = null,
    Object? iconEmoji = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topicName: null == topicName
          ? _value.topicName
          : topicName // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceType: freezed == sourceType
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      sentenceCount: null == sentenceCount
          ? _value.sentenceCount
          : sentenceCount // ignore: cast_nullable_to_non_nullable
              as int,
      iconEmoji: null == iconEmoji
          ? _value.iconEmoji
          : iconEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopicDtoImplCopyWith<$Res>
    implements $TopicDtoCopyWith<$Res> {
  factory _$$TopicDtoImplCopyWith(
          _$TopicDtoImpl value, $Res Function(_$TopicDtoImpl) then) =
      __$$TopicDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String topicName,
      String slug,
      String? description,
      String? sourceType,
      int sentenceCount,
      String iconEmoji,
      bool isActive,
      DateTime? createdAt});
}

/// @nodoc
class __$$TopicDtoImplCopyWithImpl<$Res>
    extends _$TopicDtoCopyWithImpl<$Res, _$TopicDtoImpl>
    implements _$$TopicDtoImplCopyWith<$Res> {
  __$$TopicDtoImplCopyWithImpl(
      _$TopicDtoImpl _value, $Res Function(_$TopicDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicName = null,
    Object? slug = null,
    Object? description = freezed,
    Object? sourceType = freezed,
    Object? sentenceCount = null,
    Object? iconEmoji = null,
    Object? isActive = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$TopicDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topicName: null == topicName
          ? _value.topicName
          : topicName // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceType: freezed == sourceType
          ? _value.sourceType
          : sourceType // ignore: cast_nullable_to_non_nullable
              as String?,
      sentenceCount: null == sentenceCount
          ? _value.sentenceCount
          : sentenceCount // ignore: cast_nullable_to_non_nullable
              as int,
      iconEmoji: null == iconEmoji
          ? _value.iconEmoji
          : iconEmoji // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicDtoImpl implements _TopicDto {
  const _$TopicDtoImpl(
      {required this.id,
      required this.topicName,
      required this.slug,
      this.description,
      this.sourceType,
      this.sentenceCount = 0,
      this.iconEmoji = '📚',
      this.isActive = true,
      this.createdAt});

  factory _$TopicDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String topicName;
  @override
  final String slug;
  @override
  final String? description;
  @override
  final String? sourceType;
  @override
  @JsonKey()
  final int sentenceCount;
  @override
  @JsonKey()
  final String iconEmoji;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TopicDto(id: $id, topicName: $topicName, slug: $slug, description: $description, sourceType: $sourceType, sentenceCount: $sentenceCount, iconEmoji: $iconEmoji, isActive: $isActive, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicName, topicName) ||
                other.topicName == topicName) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sourceType, sourceType) ||
                other.sourceType == sourceType) &&
            (identical(other.sentenceCount, sentenceCount) ||
                other.sentenceCount == sentenceCount) &&
            (identical(other.iconEmoji, iconEmoji) ||
                other.iconEmoji == iconEmoji) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, topicName, slug, description,
      sourceType, sentenceCount, iconEmoji, isActive, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicDtoImplCopyWith<_$TopicDtoImpl> get copyWith =>
      __$$TopicDtoImplCopyWithImpl<_$TopicDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicDtoImplToJson(
      this,
    );
  }
}

abstract class _TopicDto implements TopicDto {
  const factory _TopicDto(
      {required final String id,
      required final String topicName,
      required final String slug,
      final String? description,
      final String? sourceType,
      final int sentenceCount,
      final String iconEmoji,
      final bool isActive,
      final DateTime? createdAt}) = _$TopicDtoImpl;

  factory _TopicDto.fromJson(Map<String, dynamic> json) =
      _$TopicDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get topicName;
  @override
  String get slug;
  @override
  String? get description;
  @override
  String? get sourceType;
  @override
  int get sentenceCount;
  @override
  String get iconEmoji;
  @override
  bool get isActive;
  @override
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TopicDtoImplCopyWith<_$TopicDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
