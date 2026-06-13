// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_plan_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LearningPlanDto _$LearningPlanDtoFromJson(Map<String, dynamic> json) {
  return _LearningPlanDto.fromJson(json);
}

/// @nodoc
mixin _$LearningPlanDto {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get topicId => throw _privateConstructorUsedError;
  String get planType =>
      throw _privateConstructorUsedError; // 'daily' | 'weekly' | 'custom'
  int get dailyTargetSentences => throw _privateConstructorUsedError;
  List<String> get selectedDayOfWeek => throw _privateConstructorUsedError;
  int get completedSentences => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningPlanDtoCopyWith<LearningPlanDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPlanDtoCopyWith<$Res> {
  factory $LearningPlanDtoCopyWith(
          LearningPlanDto value, $Res Function(LearningPlanDto) then) =
      _$LearningPlanDtoCopyWithImpl<$Res, LearningPlanDto>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String topicId,
      String planType,
      int dailyTargetSentences,
      List<String> selectedDayOfWeek,
      int completedSentences,
      bool isActive,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$LearningPlanDtoCopyWithImpl<$Res, $Val extends LearningPlanDto>
    implements $LearningPlanDtoCopyWith<$Res> {
  _$LearningPlanDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? topicId = null,
    Object? planType = null,
    Object? dailyTargetSentences = null,
    Object? selectedDayOfWeek = null,
    Object? completedSentences = null,
    Object? isActive = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: null == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      planType: null == planType
          ? _value.planType
          : planType // ignore: cast_nullable_to_non_nullable
              as String,
      dailyTargetSentences: null == dailyTargetSentences
          ? _value.dailyTargetSentences
          : dailyTargetSentences // ignore: cast_nullable_to_non_nullable
              as int,
      selectedDayOfWeek: null == selectedDayOfWeek
          ? _value.selectedDayOfWeek
          : selectedDayOfWeek // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedSentences: null == completedSentences
          ? _value.completedSentences
          : completedSentences // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningPlanDtoImplCopyWith<$Res>
    implements $LearningPlanDtoCopyWith<$Res> {
  factory _$$LearningPlanDtoImplCopyWith(_$LearningPlanDtoImpl value,
          $Res Function(_$LearningPlanDtoImpl) then) =
      __$$LearningPlanDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String topicId,
      String planType,
      int dailyTargetSentences,
      List<String> selectedDayOfWeek,
      int completedSentences,
      bool isActive,
      DateTime? startDate,
      DateTime? endDate,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$LearningPlanDtoImplCopyWithImpl<$Res>
    extends _$LearningPlanDtoCopyWithImpl<$Res, _$LearningPlanDtoImpl>
    implements _$$LearningPlanDtoImplCopyWith<$Res> {
  __$$LearningPlanDtoImplCopyWithImpl(
      _$LearningPlanDtoImpl _value, $Res Function(_$LearningPlanDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? topicId = null,
    Object? planType = null,
    Object? dailyTargetSentences = null,
    Object? selectedDayOfWeek = null,
    Object? completedSentences = null,
    Object? isActive = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$LearningPlanDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: null == topicId
          ? _value.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      planType: null == planType
          ? _value.planType
          : planType // ignore: cast_nullable_to_non_nullable
              as String,
      dailyTargetSentences: null == dailyTargetSentences
          ? _value.dailyTargetSentences
          : dailyTargetSentences // ignore: cast_nullable_to_non_nullable
              as int,
      selectedDayOfWeek: null == selectedDayOfWeek
          ? _value._selectedDayOfWeek
          : selectedDayOfWeek // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedSentences: null == completedSentences
          ? _value.completedSentences
          : completedSentences // ignore: cast_nullable_to_non_nullable
              as int,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningPlanDtoImpl implements _LearningPlanDto {
  const _$LearningPlanDtoImpl(
      {required this.id,
      required this.userId,
      required this.topicId,
      required this.planType,
      this.dailyTargetSentences = 5,
      final List<String> selectedDayOfWeek = const [],
      this.completedSentences = 0,
      this.isActive = false,
      this.startDate,
      this.endDate,
      this.createdAt,
      this.updatedAt})
      : _selectedDayOfWeek = selectedDayOfWeek;

  factory _$LearningPlanDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningPlanDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String topicId;
  @override
  final String planType;
// 'daily' | 'weekly' | 'custom'
  @override
  @JsonKey()
  final int dailyTargetSentences;
  final List<String> _selectedDayOfWeek;
  @override
  @JsonKey()
  List<String> get selectedDayOfWeek {
    if (_selectedDayOfWeek is EqualUnmodifiableListView)
      return _selectedDayOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedDayOfWeek);
  }

  @override
  @JsonKey()
  final int completedSentences;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LearningPlanDto(id: $id, userId: $userId, topicId: $topicId, planType: $planType, dailyTargetSentences: $dailyTargetSentences, selectedDayOfWeek: $selectedDayOfWeek, completedSentences: $completedSentences, isActive: $isActive, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPlanDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.planType, planType) ||
                other.planType == planType) &&
            (identical(other.dailyTargetSentences, dailyTargetSentences) ||
                other.dailyTargetSentences == dailyTargetSentences) &&
            const DeepCollectionEquality()
                .equals(other._selectedDayOfWeek, _selectedDayOfWeek) &&
            (identical(other.completedSentences, completedSentences) ||
                other.completedSentences == completedSentences) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      topicId,
      planType,
      dailyTargetSentences,
      const DeepCollectionEquality().hash(_selectedDayOfWeek),
      completedSentences,
      isActive,
      startDate,
      endDate,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPlanDtoImplCopyWith<_$LearningPlanDtoImpl> get copyWith =>
      __$$LearningPlanDtoImplCopyWithImpl<_$LearningPlanDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningPlanDtoImplToJson(
      this,
    );
  }
}

abstract class _LearningPlanDto implements LearningPlanDto {
  const factory _LearningPlanDto(
      {required final String id,
      required final String userId,
      required final String topicId,
      required final String planType,
      final int dailyTargetSentences,
      final List<String> selectedDayOfWeek,
      final int completedSentences,
      final bool isActive,
      final DateTime? startDate,
      final DateTime? endDate,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$LearningPlanDtoImpl;

  factory _LearningPlanDto.fromJson(Map<String, dynamic> json) =
      _$LearningPlanDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get topicId;
  @override
  String get planType;
  @override // 'daily' | 'weekly' | 'custom'
  int get dailyTargetSentences;
  @override
  List<String> get selectedDayOfWeek;
  @override
  int get completedSentences;
  @override
  bool get isActive;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$LearningPlanDtoImplCopyWith<_$LearningPlanDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningProgressDto _$LearningProgressDtoFromJson(Map<String, dynamic> json) {
  return _LearningProgressDto.fromJson(json);
}

/// @nodoc
mixin _$LearningProgressDto {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get sentenceId => throw _privateConstructorUsedError;
  String get planId => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  int get correctCount => throw _privateConstructorUsedError;
  String get masteryLevel =>
      throw _privateConstructorUsedError; // 'learning' | 'reviewing' | 'mastered'
  DateTime? get lastReviewedAt => throw _privateConstructorUsedError;
  DateTime? get masteredAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningProgressDtoCopyWith<LearningProgressDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningProgressDtoCopyWith<$Res> {
  factory $LearningProgressDtoCopyWith(
          LearningProgressDto value, $Res Function(LearningProgressDto) then) =
      _$LearningProgressDtoCopyWithImpl<$Res, LearningProgressDto>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String sentenceId,
      String planId,
      int reviewCount,
      int correctCount,
      String masteryLevel,
      DateTime? lastReviewedAt,
      DateTime? masteredAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$LearningProgressDtoCopyWithImpl<$Res, $Val extends LearningProgressDto>
    implements $LearningProgressDtoCopyWith<$Res> {
  _$LearningProgressDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sentenceId = null,
    Object? planId = null,
    Object? reviewCount = null,
    Object? correctCount = null,
    Object? masteryLevel = null,
    Object? lastReviewedAt = freezed,
    Object? masteredAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sentenceId: null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      correctCount: null == correctCount
          ? _value.correctCount
          : correctCount // ignore: cast_nullable_to_non_nullable
              as int,
      masteryLevel: null == masteryLevel
          ? _value.masteryLevel
          : masteryLevel // ignore: cast_nullable_to_non_nullable
              as String,
      lastReviewedAt: freezed == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      masteredAt: freezed == masteredAt
          ? _value.masteredAt
          : masteredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningProgressDtoImplCopyWith<$Res>
    implements $LearningProgressDtoCopyWith<$Res> {
  factory _$$LearningProgressDtoImplCopyWith(_$LearningProgressDtoImpl value,
          $Res Function(_$LearningProgressDtoImpl) then) =
      __$$LearningProgressDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String sentenceId,
      String planId,
      int reviewCount,
      int correctCount,
      String masteryLevel,
      DateTime? lastReviewedAt,
      DateTime? masteredAt,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$LearningProgressDtoImplCopyWithImpl<$Res>
    extends _$LearningProgressDtoCopyWithImpl<$Res, _$LearningProgressDtoImpl>
    implements _$$LearningProgressDtoImplCopyWith<$Res> {
  __$$LearningProgressDtoImplCopyWithImpl(_$LearningProgressDtoImpl _value,
      $Res Function(_$LearningProgressDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sentenceId = null,
    Object? planId = null,
    Object? reviewCount = null,
    Object? correctCount = null,
    Object? masteryLevel = null,
    Object? lastReviewedAt = freezed,
    Object? masteredAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$LearningProgressDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sentenceId: null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
      planId: null == planId
          ? _value.planId
          : planId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      correctCount: null == correctCount
          ? _value.correctCount
          : correctCount // ignore: cast_nullable_to_non_nullable
              as int,
      masteryLevel: null == masteryLevel
          ? _value.masteryLevel
          : masteryLevel // ignore: cast_nullable_to_non_nullable
              as String,
      lastReviewedAt: freezed == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      masteredAt: freezed == masteredAt
          ? _value.masteredAt
          : masteredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningProgressDtoImpl implements _LearningProgressDto {
  const _$LearningProgressDtoImpl(
      {required this.id,
      required this.userId,
      required this.sentenceId,
      required this.planId,
      this.reviewCount = 0,
      this.correctCount = 0,
      this.masteryLevel = 'learning',
      this.lastReviewedAt,
      this.masteredAt,
      this.createdAt,
      this.updatedAt});

  factory _$LearningProgressDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningProgressDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String sentenceId;
  @override
  final String planId;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final int correctCount;
  @override
  @JsonKey()
  final String masteryLevel;
// 'learning' | 'reviewing' | 'mastered'
  @override
  final DateTime? lastReviewedAt;
  @override
  final DateTime? masteredAt;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'LearningProgressDto(id: $id, userId: $userId, sentenceId: $sentenceId, planId: $planId, reviewCount: $reviewCount, correctCount: $correctCount, masteryLevel: $masteryLevel, lastReviewedAt: $lastReviewedAt, masteredAt: $masteredAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningProgressDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sentenceId, sentenceId) ||
                other.sentenceId == sentenceId) &&
            (identical(other.planId, planId) || other.planId == planId) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.correctCount, correctCount) ||
                other.correctCount == correctCount) &&
            (identical(other.masteryLevel, masteryLevel) ||
                other.masteryLevel == masteryLevel) &&
            (identical(other.lastReviewedAt, lastReviewedAt) ||
                other.lastReviewedAt == lastReviewedAt) &&
            (identical(other.masteredAt, masteredAt) ||
                other.masteredAt == masteredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      sentenceId,
      planId,
      reviewCount,
      correctCount,
      masteryLevel,
      lastReviewedAt,
      masteredAt,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningProgressDtoImplCopyWith<_$LearningProgressDtoImpl> get copyWith =>
      __$$LearningProgressDtoImplCopyWithImpl<_$LearningProgressDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningProgressDtoImplToJson(
      this,
    );
  }
}

abstract class _LearningProgressDto implements LearningProgressDto {
  const factory _LearningProgressDto(
      {required final String id,
      required final String userId,
      required final String sentenceId,
      required final String planId,
      final int reviewCount,
      final int correctCount,
      final String masteryLevel,
      final DateTime? lastReviewedAt,
      final DateTime? masteredAt,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$LearningProgressDtoImpl;

  factory _LearningProgressDto.fromJson(Map<String, dynamic> json) =
      _$LearningProgressDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get sentenceId;
  @override
  String get planId;
  @override
  int get reviewCount;
  @override
  int get correctCount;
  @override
  String get masteryLevel;
  @override // 'learning' | 'reviewing' | 'mastered'
  DateTime? get lastReviewedAt;
  @override
  DateTime? get masteredAt;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$LearningProgressDtoImplCopyWith<_$LearningProgressDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
