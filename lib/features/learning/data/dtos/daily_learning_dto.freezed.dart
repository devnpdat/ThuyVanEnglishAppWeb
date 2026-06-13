// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_learning_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TodayLearningDto _$TodayLearningDtoFromJson(Map<String, dynamic> json) {
  return _TodayLearningDto.fromJson(json);
}

/// @nodoc
mixin _$TodayLearningDto {
  String get planDate => throw _privateConstructorUsedError;
  int get totalSentences => throw _privateConstructorUsedError;
  int get completedCount => throw _privateConstructorUsedError;
  int get remainingCount => throw _privateConstructorUsedError;
  List<LearningSessionItemDto> get items => throw _privateConstructorUsedError;
  bool get isAlreadyGenerated => throw _privateConstructorUsedError;
  String? get warningMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TodayLearningDtoCopyWith<TodayLearningDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodayLearningDtoCopyWith<$Res> {
  factory $TodayLearningDtoCopyWith(
          TodayLearningDto value, $Res Function(TodayLearningDto) then) =
      _$TodayLearningDtoCopyWithImpl<$Res, TodayLearningDto>;
  @useResult
  $Res call(
      {String planDate,
      int totalSentences,
      int completedCount,
      int remainingCount,
      List<LearningSessionItemDto> items,
      bool isAlreadyGenerated,
      String? warningMessage});
}

/// @nodoc
class _$TodayLearningDtoCopyWithImpl<$Res, $Val extends TodayLearningDto>
    implements $TodayLearningDtoCopyWith<$Res> {
  _$TodayLearningDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planDate = null,
    Object? totalSentences = null,
    Object? completedCount = null,
    Object? remainingCount = null,
    Object? items = null,
    Object? isAlreadyGenerated = null,
    Object? warningMessage = freezed,
  }) {
    return _then(_value.copyWith(
      planDate: null == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalSentences: null == totalSentences
          ? _value.totalSentences
          : totalSentences // ignore: cast_nullable_to_non_nullable
              as int,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      remainingCount: null == remainingCount
          ? _value.remainingCount
          : remainingCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LearningSessionItemDto>,
      isAlreadyGenerated: null == isAlreadyGenerated
          ? _value.isAlreadyGenerated
          : isAlreadyGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      warningMessage: freezed == warningMessage
          ? _value.warningMessage
          : warningMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TodayLearningDtoImplCopyWith<$Res>
    implements $TodayLearningDtoCopyWith<$Res> {
  factory _$$TodayLearningDtoImplCopyWith(_$TodayLearningDtoImpl value,
          $Res Function(_$TodayLearningDtoImpl) then) =
      __$$TodayLearningDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String planDate,
      int totalSentences,
      int completedCount,
      int remainingCount,
      List<LearningSessionItemDto> items,
      bool isAlreadyGenerated,
      String? warningMessage});
}

/// @nodoc
class __$$TodayLearningDtoImplCopyWithImpl<$Res>
    extends _$TodayLearningDtoCopyWithImpl<$Res, _$TodayLearningDtoImpl>
    implements _$$TodayLearningDtoImplCopyWith<$Res> {
  __$$TodayLearningDtoImplCopyWithImpl(_$TodayLearningDtoImpl _value,
      $Res Function(_$TodayLearningDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? planDate = null,
    Object? totalSentences = null,
    Object? completedCount = null,
    Object? remainingCount = null,
    Object? items = null,
    Object? isAlreadyGenerated = null,
    Object? warningMessage = freezed,
  }) {
    return _then(_$TodayLearningDtoImpl(
      planDate: null == planDate
          ? _value.planDate
          : planDate // ignore: cast_nullable_to_non_nullable
              as String,
      totalSentences: null == totalSentences
          ? _value.totalSentences
          : totalSentences // ignore: cast_nullable_to_non_nullable
              as int,
      completedCount: null == completedCount
          ? _value.completedCount
          : completedCount // ignore: cast_nullable_to_non_nullable
              as int,
      remainingCount: null == remainingCount
          ? _value.remainingCount
          : remainingCount // ignore: cast_nullable_to_non_nullable
              as int,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<LearningSessionItemDto>,
      isAlreadyGenerated: null == isAlreadyGenerated
          ? _value.isAlreadyGenerated
          : isAlreadyGenerated // ignore: cast_nullable_to_non_nullable
              as bool,
      warningMessage: freezed == warningMessage
          ? _value.warningMessage
          : warningMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TodayLearningDtoImpl implements _TodayLearningDto {
  const _$TodayLearningDtoImpl(
      {required this.planDate,
      required this.totalSentences,
      required this.completedCount,
      required this.remainingCount,
      final List<LearningSessionItemDto> items = const [],
      this.isAlreadyGenerated = false,
      this.warningMessage})
      : _items = items;

  factory _$TodayLearningDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodayLearningDtoImplFromJson(json);

  @override
  final String planDate;
  @override
  final int totalSentences;
  @override
  final int completedCount;
  @override
  final int remainingCount;
  final List<LearningSessionItemDto> _items;
  @override
  @JsonKey()
  List<LearningSessionItemDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final bool isAlreadyGenerated;
  @override
  final String? warningMessage;

  @override
  String toString() {
    return 'TodayLearningDto(planDate: $planDate, totalSentences: $totalSentences, completedCount: $completedCount, remainingCount: $remainingCount, items: $items, isAlreadyGenerated: $isAlreadyGenerated, warningMessage: $warningMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodayLearningDtoImpl &&
            (identical(other.planDate, planDate) ||
                other.planDate == planDate) &&
            (identical(other.totalSentences, totalSentences) ||
                other.totalSentences == totalSentences) &&
            (identical(other.completedCount, completedCount) ||
                other.completedCount == completedCount) &&
            (identical(other.remainingCount, remainingCount) ||
                other.remainingCount == remainingCount) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isAlreadyGenerated, isAlreadyGenerated) ||
                other.isAlreadyGenerated == isAlreadyGenerated) &&
            (identical(other.warningMessage, warningMessage) ||
                other.warningMessage == warningMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      planDate,
      totalSentences,
      completedCount,
      remainingCount,
      const DeepCollectionEquality().hash(_items),
      isAlreadyGenerated,
      warningMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TodayLearningDtoImplCopyWith<_$TodayLearningDtoImpl> get copyWith =>
      __$$TodayLearningDtoImplCopyWithImpl<_$TodayLearningDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodayLearningDtoImplToJson(
      this,
    );
  }
}

abstract class _TodayLearningDto implements TodayLearningDto {
  const factory _TodayLearningDto(
      {required final String planDate,
      required final int totalSentences,
      required final int completedCount,
      required final int remainingCount,
      final List<LearningSessionItemDto> items,
      final bool isAlreadyGenerated,
      final String? warningMessage}) = _$TodayLearningDtoImpl;

  factory _TodayLearningDto.fromJson(Map<String, dynamic> json) =
      _$TodayLearningDtoImpl.fromJson;

  @override
  String get planDate;
  @override
  int get totalSentences;
  @override
  int get completedCount;
  @override
  int get remainingCount;
  @override
  List<LearningSessionItemDto> get items;
  @override
  bool get isAlreadyGenerated;
  @override
  String? get warningMessage;
  @override
  @JsonKey(ignore: true)
  _$$TodayLearningDtoImplCopyWith<_$TodayLearningDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningSessionItemDto _$LearningSessionItemDtoFromJson(
    Map<String, dynamic> json) {
  return _LearningSessionItemDto.fromJson(json);
}

/// @nodoc
mixin _$LearningSessionItemDto {
  String get sentenceId => throw _privateConstructorUsedError;
  SentenceDto get sentence => throw _privateConstructorUsedError;
  String get progressStatus => throw _privateConstructorUsedError;
  bool get isCompletedToday => throw _privateConstructorUsedError;
  int get totalAudioPlays => throw _privateConstructorUsedError;
  int get totalCorrectTypings => throw _privateConstructorUsedError;
  bool get sessionQuizPassed => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LearningSessionItemDtoCopyWith<LearningSessionItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningSessionItemDtoCopyWith<$Res> {
  factory $LearningSessionItemDtoCopyWith(LearningSessionItemDto value,
          $Res Function(LearningSessionItemDto) then) =
      _$LearningSessionItemDtoCopyWithImpl<$Res, LearningSessionItemDto>;
  @useResult
  $Res call(
      {String sentenceId,
      SentenceDto sentence,
      String progressStatus,
      bool isCompletedToday,
      int totalAudioPlays,
      int totalCorrectTypings,
      bool sessionQuizPassed,
      int order});

  $SentenceDtoCopyWith<$Res> get sentence;
}

/// @nodoc
class _$LearningSessionItemDtoCopyWithImpl<$Res,
        $Val extends LearningSessionItemDto>
    implements $LearningSessionItemDtoCopyWith<$Res> {
  _$LearningSessionItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentenceId = null,
    Object? sentence = null,
    Object? progressStatus = null,
    Object? isCompletedToday = null,
    Object? totalAudioPlays = null,
    Object? totalCorrectTypings = null,
    Object? sessionQuizPassed = null,
    Object? order = null,
  }) {
    return _then(_value.copyWith(
      sentenceId: null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
      sentence: null == sentence
          ? _value.sentence
          : sentence // ignore: cast_nullable_to_non_nullable
              as SentenceDto,
      progressStatus: null == progressStatus
          ? _value.progressStatus
          : progressStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isCompletedToday: null == isCompletedToday
          ? _value.isCompletedToday
          : isCompletedToday // ignore: cast_nullable_to_non_nullable
              as bool,
      totalAudioPlays: null == totalAudioPlays
          ? _value.totalAudioPlays
          : totalAudioPlays // ignore: cast_nullable_to_non_nullable
              as int,
      totalCorrectTypings: null == totalCorrectTypings
          ? _value.totalCorrectTypings
          : totalCorrectTypings // ignore: cast_nullable_to_non_nullable
              as int,
      sessionQuizPassed: null == sessionQuizPassed
          ? _value.sessionQuizPassed
          : sessionQuizPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SentenceDtoCopyWith<$Res> get sentence {
    return $SentenceDtoCopyWith<$Res>(_value.sentence, (value) {
      return _then(_value.copyWith(sentence: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LearningSessionItemDtoImplCopyWith<$Res>
    implements $LearningSessionItemDtoCopyWith<$Res> {
  factory _$$LearningSessionItemDtoImplCopyWith(
          _$LearningSessionItemDtoImpl value,
          $Res Function(_$LearningSessionItemDtoImpl) then) =
      __$$LearningSessionItemDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sentenceId,
      SentenceDto sentence,
      String progressStatus,
      bool isCompletedToday,
      int totalAudioPlays,
      int totalCorrectTypings,
      bool sessionQuizPassed,
      int order});

  @override
  $SentenceDtoCopyWith<$Res> get sentence;
}

/// @nodoc
class __$$LearningSessionItemDtoImplCopyWithImpl<$Res>
    extends _$LearningSessionItemDtoCopyWithImpl<$Res,
        _$LearningSessionItemDtoImpl>
    implements _$$LearningSessionItemDtoImplCopyWith<$Res> {
  __$$LearningSessionItemDtoImplCopyWithImpl(
      _$LearningSessionItemDtoImpl _value,
      $Res Function(_$LearningSessionItemDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentenceId = null,
    Object? sentence = null,
    Object? progressStatus = null,
    Object? isCompletedToday = null,
    Object? totalAudioPlays = null,
    Object? totalCorrectTypings = null,
    Object? sessionQuizPassed = null,
    Object? order = null,
  }) {
    return _then(_$LearningSessionItemDtoImpl(
      sentenceId: null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
      sentence: null == sentence
          ? _value.sentence
          : sentence // ignore: cast_nullable_to_non_nullable
              as SentenceDto,
      progressStatus: null == progressStatus
          ? _value.progressStatus
          : progressStatus // ignore: cast_nullable_to_non_nullable
              as String,
      isCompletedToday: null == isCompletedToday
          ? _value.isCompletedToday
          : isCompletedToday // ignore: cast_nullable_to_non_nullable
              as bool,
      totalAudioPlays: null == totalAudioPlays
          ? _value.totalAudioPlays
          : totalAudioPlays // ignore: cast_nullable_to_non_nullable
              as int,
      totalCorrectTypings: null == totalCorrectTypings
          ? _value.totalCorrectTypings
          : totalCorrectTypings // ignore: cast_nullable_to_non_nullable
              as int,
      sessionQuizPassed: null == sessionQuizPassed
          ? _value.sessionQuizPassed
          : sessionQuizPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningSessionItemDtoImpl implements _LearningSessionItemDto {
  const _$LearningSessionItemDtoImpl(
      {required this.sentenceId,
      required this.sentence,
      required this.progressStatus,
      this.isCompletedToday = false,
      this.totalAudioPlays = 0,
      this.totalCorrectTypings = 0,
      this.sessionQuizPassed = false,
      required this.order});

  factory _$LearningSessionItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningSessionItemDtoImplFromJson(json);

  @override
  final String sentenceId;
  @override
  final SentenceDto sentence;
  @override
  final String progressStatus;
  @override
  @JsonKey()
  final bool isCompletedToday;
  @override
  @JsonKey()
  final int totalAudioPlays;
  @override
  @JsonKey()
  final int totalCorrectTypings;
  @override
  @JsonKey()
  final bool sessionQuizPassed;
  @override
  final int order;

  @override
  String toString() {
    return 'LearningSessionItemDto(sentenceId: $sentenceId, sentence: $sentence, progressStatus: $progressStatus, isCompletedToday: $isCompletedToday, totalAudioPlays: $totalAudioPlays, totalCorrectTypings: $totalCorrectTypings, sessionQuizPassed: $sessionQuizPassed, order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningSessionItemDtoImpl &&
            (identical(other.sentenceId, sentenceId) ||
                other.sentenceId == sentenceId) &&
            (identical(other.sentence, sentence) ||
                other.sentence == sentence) &&
            (identical(other.progressStatus, progressStatus) ||
                other.progressStatus == progressStatus) &&
            (identical(other.isCompletedToday, isCompletedToday) ||
                other.isCompletedToday == isCompletedToday) &&
            (identical(other.totalAudioPlays, totalAudioPlays) ||
                other.totalAudioPlays == totalAudioPlays) &&
            (identical(other.totalCorrectTypings, totalCorrectTypings) ||
                other.totalCorrectTypings == totalCorrectTypings) &&
            (identical(other.sessionQuizPassed, sessionQuizPassed) ||
                other.sessionQuizPassed == sessionQuizPassed) &&
            (identical(other.order, order) || other.order == order));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sentenceId,
      sentence,
      progressStatus,
      isCompletedToday,
      totalAudioPlays,
      totalCorrectTypings,
      sessionQuizPassed,
      order);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningSessionItemDtoImplCopyWith<_$LearningSessionItemDtoImpl>
      get copyWith => __$$LearningSessionItemDtoImplCopyWithImpl<
          _$LearningSessionItemDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningSessionItemDtoImplToJson(
      this,
    );
  }
}

abstract class _LearningSessionItemDto implements LearningSessionItemDto {
  const factory _LearningSessionItemDto(
      {required final String sentenceId,
      required final SentenceDto sentence,
      required final String progressStatus,
      final bool isCompletedToday,
      final int totalAudioPlays,
      final int totalCorrectTypings,
      final bool sessionQuizPassed,
      required final int order}) = _$LearningSessionItemDtoImpl;

  factory _LearningSessionItemDto.fromJson(Map<String, dynamic> json) =
      _$LearningSessionItemDtoImpl.fromJson;

  @override
  String get sentenceId;
  @override
  SentenceDto get sentence;
  @override
  String get progressStatus;
  @override
  bool get isCompletedToday;
  @override
  int get totalAudioPlays;
  @override
  int get totalCorrectTypings;
  @override
  bool get sessionQuizPassed;
  @override
  int get order;
  @override
  @JsonKey(ignore: true)
  _$$LearningSessionItemDtoImplCopyWith<_$LearningSessionItemDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TypingAttemptDto _$TypingAttemptDtoFromJson(Map<String, dynamic> json) {
  return _TypingAttemptDto.fromJson(json);
}

/// @nodoc
mixin _$TypingAttemptDto {
  String get userInput => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TypingAttemptDtoCopyWith<TypingAttemptDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypingAttemptDtoCopyWith<$Res> {
  factory $TypingAttemptDtoCopyWith(
          TypingAttemptDto value, $Res Function(TypingAttemptDto) then) =
      _$TypingAttemptDtoCopyWithImpl<$Res, TypingAttemptDto>;
  @useResult
  $Res call({String userInput});
}

/// @nodoc
class _$TypingAttemptDtoCopyWithImpl<$Res, $Val extends TypingAttemptDto>
    implements $TypingAttemptDtoCopyWith<$Res> {
  _$TypingAttemptDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userInput = null,
  }) {
    return _then(_value.copyWith(
      userInput: null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypingAttemptDtoImplCopyWith<$Res>
    implements $TypingAttemptDtoCopyWith<$Res> {
  factory _$$TypingAttemptDtoImplCopyWith(_$TypingAttemptDtoImpl value,
          $Res Function(_$TypingAttemptDtoImpl) then) =
      __$$TypingAttemptDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userInput});
}

/// @nodoc
class __$$TypingAttemptDtoImplCopyWithImpl<$Res>
    extends _$TypingAttemptDtoCopyWithImpl<$Res, _$TypingAttemptDtoImpl>
    implements _$$TypingAttemptDtoImplCopyWith<$Res> {
  __$$TypingAttemptDtoImplCopyWithImpl(_$TypingAttemptDtoImpl _value,
      $Res Function(_$TypingAttemptDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userInput = null,
  }) {
    return _then(_$TypingAttemptDtoImpl(
      userInput: null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypingAttemptDtoImpl implements _TypingAttemptDto {
  const _$TypingAttemptDtoImpl({required this.userInput});

  factory _$TypingAttemptDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypingAttemptDtoImplFromJson(json);

  @override
  final String userInput;

  @override
  String toString() {
    return 'TypingAttemptDto(userInput: $userInput)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypingAttemptDtoImpl &&
            (identical(other.userInput, userInput) ||
                other.userInput == userInput));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userInput);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TypingAttemptDtoImplCopyWith<_$TypingAttemptDtoImpl> get copyWith =>
      __$$TypingAttemptDtoImplCopyWithImpl<_$TypingAttemptDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypingAttemptDtoImplToJson(
      this,
    );
  }
}

abstract class _TypingAttemptDto implements TypingAttemptDto {
  const factory _TypingAttemptDto({required final String userInput}) =
      _$TypingAttemptDtoImpl;

  factory _TypingAttemptDto.fromJson(Map<String, dynamic> json) =
      _$TypingAttemptDtoImpl.fromJson;

  @override
  String get userInput;
  @override
  @JsonKey(ignore: true)
  _$$TypingAttemptDtoImplCopyWith<_$TypingAttemptDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TypingResultDto _$TypingResultDtoFromJson(Map<String, dynamic> json) {
  return _TypingResultDto.fromJson(json);
}

/// @nodoc
mixin _$TypingResultDto {
  bool get isCorrect => throw _privateConstructorUsedError;
  String get correctText => throw _privateConstructorUsedError;
  String get userInput => throw _privateConstructorUsedError;
  List<TypingDiffSegmentDto> get diffSegments =>
      throw _privateConstructorUsedError;
  int get totalCorrectTypings => throw _privateConstructorUsedError;
  bool get canProceedToQuiz => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TypingResultDtoCopyWith<TypingResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypingResultDtoCopyWith<$Res> {
  factory $TypingResultDtoCopyWith(
          TypingResultDto value, $Res Function(TypingResultDto) then) =
      _$TypingResultDtoCopyWithImpl<$Res, TypingResultDto>;
  @useResult
  $Res call(
      {bool isCorrect,
      String correctText,
      String userInput,
      List<TypingDiffSegmentDto> diffSegments,
      int totalCorrectTypings,
      bool canProceedToQuiz});
}

/// @nodoc
class _$TypingResultDtoCopyWithImpl<$Res, $Val extends TypingResultDto>
    implements $TypingResultDtoCopyWith<$Res> {
  _$TypingResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? correctText = null,
    Object? userInput = null,
    Object? diffSegments = null,
    Object? totalCorrectTypings = null,
    Object? canProceedToQuiz = null,
  }) {
    return _then(_value.copyWith(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      correctText: null == correctText
          ? _value.correctText
          : correctText // ignore: cast_nullable_to_non_nullable
              as String,
      userInput: null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
      diffSegments: null == diffSegments
          ? _value.diffSegments
          : diffSegments // ignore: cast_nullable_to_non_nullable
              as List<TypingDiffSegmentDto>,
      totalCorrectTypings: null == totalCorrectTypings
          ? _value.totalCorrectTypings
          : totalCorrectTypings // ignore: cast_nullable_to_non_nullable
              as int,
      canProceedToQuiz: null == canProceedToQuiz
          ? _value.canProceedToQuiz
          : canProceedToQuiz // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypingResultDtoImplCopyWith<$Res>
    implements $TypingResultDtoCopyWith<$Res> {
  factory _$$TypingResultDtoImplCopyWith(_$TypingResultDtoImpl value,
          $Res Function(_$TypingResultDtoImpl) then) =
      __$$TypingResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCorrect,
      String correctText,
      String userInput,
      List<TypingDiffSegmentDto> diffSegments,
      int totalCorrectTypings,
      bool canProceedToQuiz});
}

/// @nodoc
class __$$TypingResultDtoImplCopyWithImpl<$Res>
    extends _$TypingResultDtoCopyWithImpl<$Res, _$TypingResultDtoImpl>
    implements _$$TypingResultDtoImplCopyWith<$Res> {
  __$$TypingResultDtoImplCopyWithImpl(
      _$TypingResultDtoImpl _value, $Res Function(_$TypingResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? correctText = null,
    Object? userInput = null,
    Object? diffSegments = null,
    Object? totalCorrectTypings = null,
    Object? canProceedToQuiz = null,
  }) {
    return _then(_$TypingResultDtoImpl(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      correctText: null == correctText
          ? _value.correctText
          : correctText // ignore: cast_nullable_to_non_nullable
              as String,
      userInput: null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
      diffSegments: null == diffSegments
          ? _value._diffSegments
          : diffSegments // ignore: cast_nullable_to_non_nullable
              as List<TypingDiffSegmentDto>,
      totalCorrectTypings: null == totalCorrectTypings
          ? _value.totalCorrectTypings
          : totalCorrectTypings // ignore: cast_nullable_to_non_nullable
              as int,
      canProceedToQuiz: null == canProceedToQuiz
          ? _value.canProceedToQuiz
          : canProceedToQuiz // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypingResultDtoImpl implements _TypingResultDto {
  const _$TypingResultDtoImpl(
      {required this.isCorrect,
      required this.correctText,
      required this.userInput,
      final List<TypingDiffSegmentDto> diffSegments = const [],
      this.totalCorrectTypings = 0,
      this.canProceedToQuiz = false})
      : _diffSegments = diffSegments;

  factory _$TypingResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypingResultDtoImplFromJson(json);

  @override
  final bool isCorrect;
  @override
  final String correctText;
  @override
  final String userInput;
  final List<TypingDiffSegmentDto> _diffSegments;
  @override
  @JsonKey()
  List<TypingDiffSegmentDto> get diffSegments {
    if (_diffSegments is EqualUnmodifiableListView) return _diffSegments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diffSegments);
  }

  @override
  @JsonKey()
  final int totalCorrectTypings;
  @override
  @JsonKey()
  final bool canProceedToQuiz;

  @override
  String toString() {
    return 'TypingResultDto(isCorrect: $isCorrect, correctText: $correctText, userInput: $userInput, diffSegments: $diffSegments, totalCorrectTypings: $totalCorrectTypings, canProceedToQuiz: $canProceedToQuiz)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypingResultDtoImpl &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.correctText, correctText) ||
                other.correctText == correctText) &&
            (identical(other.userInput, userInput) ||
                other.userInput == userInput) &&
            const DeepCollectionEquality()
                .equals(other._diffSegments, _diffSegments) &&
            (identical(other.totalCorrectTypings, totalCorrectTypings) ||
                other.totalCorrectTypings == totalCorrectTypings) &&
            (identical(other.canProceedToQuiz, canProceedToQuiz) ||
                other.canProceedToQuiz == canProceedToQuiz));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      isCorrect,
      correctText,
      userInput,
      const DeepCollectionEquality().hash(_diffSegments),
      totalCorrectTypings,
      canProceedToQuiz);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TypingResultDtoImplCopyWith<_$TypingResultDtoImpl> get copyWith =>
      __$$TypingResultDtoImplCopyWithImpl<_$TypingResultDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypingResultDtoImplToJson(
      this,
    );
  }
}

abstract class _TypingResultDto implements TypingResultDto {
  const factory _TypingResultDto(
      {required final bool isCorrect,
      required final String correctText,
      required final String userInput,
      final List<TypingDiffSegmentDto> diffSegments,
      final int totalCorrectTypings,
      final bool canProceedToQuiz}) = _$TypingResultDtoImpl;

  factory _TypingResultDto.fromJson(Map<String, dynamic> json) =
      _$TypingResultDtoImpl.fromJson;

  @override
  bool get isCorrect;
  @override
  String get correctText;
  @override
  String get userInput;
  @override
  List<TypingDiffSegmentDto> get diffSegments;
  @override
  int get totalCorrectTypings;
  @override
  bool get canProceedToQuiz;
  @override
  @JsonKey(ignore: true)
  _$$TypingResultDtoImplCopyWith<_$TypingResultDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TypingDiffSegmentDto _$TypingDiffSegmentDtoFromJson(Map<String, dynamic> json) {
  return _TypingDiffSegmentDto.fromJson(json);
}

/// @nodoc
mixin _$TypingDiffSegmentDto {
  String get text => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TypingDiffSegmentDtoCopyWith<TypingDiffSegmentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TypingDiffSegmentDtoCopyWith<$Res> {
  factory $TypingDiffSegmentDtoCopyWith(TypingDiffSegmentDto value,
          $Res Function(TypingDiffSegmentDto) then) =
      _$TypingDiffSegmentDtoCopyWithImpl<$Res, TypingDiffSegmentDto>;
  @useResult
  $Res call({String text, String type});
}

/// @nodoc
class _$TypingDiffSegmentDtoCopyWithImpl<$Res,
        $Val extends TypingDiffSegmentDto>
    implements $TypingDiffSegmentDtoCopyWith<$Res> {
  _$TypingDiffSegmentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TypingDiffSegmentDtoImplCopyWith<$Res>
    implements $TypingDiffSegmentDtoCopyWith<$Res> {
  factory _$$TypingDiffSegmentDtoImplCopyWith(_$TypingDiffSegmentDtoImpl value,
          $Res Function(_$TypingDiffSegmentDtoImpl) then) =
      __$$TypingDiffSegmentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String type});
}

/// @nodoc
class __$$TypingDiffSegmentDtoImplCopyWithImpl<$Res>
    extends _$TypingDiffSegmentDtoCopyWithImpl<$Res, _$TypingDiffSegmentDtoImpl>
    implements _$$TypingDiffSegmentDtoImplCopyWith<$Res> {
  __$$TypingDiffSegmentDtoImplCopyWithImpl(_$TypingDiffSegmentDtoImpl _value,
      $Res Function(_$TypingDiffSegmentDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? type = null,
  }) {
    return _then(_$TypingDiffSegmentDtoImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TypingDiffSegmentDtoImpl implements _TypingDiffSegmentDto {
  const _$TypingDiffSegmentDtoImpl({required this.text, required this.type});

  factory _$TypingDiffSegmentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TypingDiffSegmentDtoImplFromJson(json);

  @override
  final String text;
  @override
  final String type;

  @override
  String toString() {
    return 'TypingDiffSegmentDto(text: $text, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypingDiffSegmentDtoImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, text, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TypingDiffSegmentDtoImplCopyWith<_$TypingDiffSegmentDtoImpl>
      get copyWith =>
          __$$TypingDiffSegmentDtoImplCopyWithImpl<_$TypingDiffSegmentDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TypingDiffSegmentDtoImplToJson(
      this,
    );
  }
}

abstract class _TypingDiffSegmentDto implements TypingDiffSegmentDto {
  const factory _TypingDiffSegmentDto(
      {required final String text,
      required final String type}) = _$TypingDiffSegmentDtoImpl;

  factory _TypingDiffSegmentDto.fromJson(Map<String, dynamic> json) =
      _$TypingDiffSegmentDtoImpl.fromJson;

  @override
  String get text;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$TypingDiffSegmentDtoImplCopyWith<_$TypingDiffSegmentDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AudioPlayedResultDto _$AudioPlayedResultDtoFromJson(Map<String, dynamic> json) {
  return _AudioPlayedResultDto.fromJson(json);
}

/// @nodoc
mixin _$AudioPlayedResultDto {
  int get totalAudioPlays => throw _privateConstructorUsedError;
  bool get audioRequirementMet => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AudioPlayedResultDtoCopyWith<AudioPlayedResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioPlayedResultDtoCopyWith<$Res> {
  factory $AudioPlayedResultDtoCopyWith(AudioPlayedResultDto value,
          $Res Function(AudioPlayedResultDto) then) =
      _$AudioPlayedResultDtoCopyWithImpl<$Res, AudioPlayedResultDto>;
  @useResult
  $Res call({int totalAudioPlays, bool audioRequirementMet});
}

/// @nodoc
class _$AudioPlayedResultDtoCopyWithImpl<$Res,
        $Val extends AudioPlayedResultDto>
    implements $AudioPlayedResultDtoCopyWith<$Res> {
  _$AudioPlayedResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAudioPlays = null,
    Object? audioRequirementMet = null,
  }) {
    return _then(_value.copyWith(
      totalAudioPlays: null == totalAudioPlays
          ? _value.totalAudioPlays
          : totalAudioPlays // ignore: cast_nullable_to_non_nullable
              as int,
      audioRequirementMet: null == audioRequirementMet
          ? _value.audioRequirementMet
          : audioRequirementMet // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AudioPlayedResultDtoImplCopyWith<$Res>
    implements $AudioPlayedResultDtoCopyWith<$Res> {
  factory _$$AudioPlayedResultDtoImplCopyWith(_$AudioPlayedResultDtoImpl value,
          $Res Function(_$AudioPlayedResultDtoImpl) then) =
      __$$AudioPlayedResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalAudioPlays, bool audioRequirementMet});
}

/// @nodoc
class __$$AudioPlayedResultDtoImplCopyWithImpl<$Res>
    extends _$AudioPlayedResultDtoCopyWithImpl<$Res, _$AudioPlayedResultDtoImpl>
    implements _$$AudioPlayedResultDtoImplCopyWith<$Res> {
  __$$AudioPlayedResultDtoImplCopyWithImpl(_$AudioPlayedResultDtoImpl _value,
      $Res Function(_$AudioPlayedResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAudioPlays = null,
    Object? audioRequirementMet = null,
  }) {
    return _then(_$AudioPlayedResultDtoImpl(
      totalAudioPlays: null == totalAudioPlays
          ? _value.totalAudioPlays
          : totalAudioPlays // ignore: cast_nullable_to_non_nullable
              as int,
      audioRequirementMet: null == audioRequirementMet
          ? _value.audioRequirementMet
          : audioRequirementMet // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioPlayedResultDtoImpl implements _AudioPlayedResultDto {
  const _$AudioPlayedResultDtoImpl(
      {required this.totalAudioPlays, required this.audioRequirementMet});

  factory _$AudioPlayedResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioPlayedResultDtoImplFromJson(json);

  @override
  final int totalAudioPlays;
  @override
  final bool audioRequirementMet;

  @override
  String toString() {
    return 'AudioPlayedResultDto(totalAudioPlays: $totalAudioPlays, audioRequirementMet: $audioRequirementMet)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioPlayedResultDtoImpl &&
            (identical(other.totalAudioPlays, totalAudioPlays) ||
                other.totalAudioPlays == totalAudioPlays) &&
            (identical(other.audioRequirementMet, audioRequirementMet) ||
                other.audioRequirementMet == audioRequirementMet));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, totalAudioPlays, audioRequirementMet);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioPlayedResultDtoImplCopyWith<_$AudioPlayedResultDtoImpl>
      get copyWith =>
          __$$AudioPlayedResultDtoImplCopyWithImpl<_$AudioPlayedResultDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioPlayedResultDtoImplToJson(
      this,
    );
  }
}

abstract class _AudioPlayedResultDto implements AudioPlayedResultDto {
  const factory _AudioPlayedResultDto(
      {required final int totalAudioPlays,
      required final bool audioRequirementMet}) = _$AudioPlayedResultDtoImpl;

  factory _AudioPlayedResultDto.fromJson(Map<String, dynamic> json) =
      _$AudioPlayedResultDtoImpl.fromJson;

  @override
  int get totalAudioPlays;
  @override
  bool get audioRequirementMet;
  @override
  @JsonKey(ignore: true)
  _$$AudioPlayedResultDtoImplCopyWith<_$AudioPlayedResultDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SessionCompleteResultDto _$SessionCompleteResultDtoFromJson(
    Map<String, dynamic> json) {
  return _SessionCompleteResultDto.fromJson(json);
}

/// @nodoc
mixin _$SessionCompleteResultDto {
  bool get success => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String? get newStatus => throw _privateConstructorUsedError;
  int get pointsAwarded => throw _privateConstructorUsedError;
  DateTime? get nextReviewAt => throw _privateConstructorUsedError;
  List<String> get unmetConditions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionCompleteResultDtoCopyWith<SessionCompleteResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionCompleteResultDtoCopyWith<$Res> {
  factory $SessionCompleteResultDtoCopyWith(SessionCompleteResultDto value,
          $Res Function(SessionCompleteResultDto) then) =
      _$SessionCompleteResultDtoCopyWithImpl<$Res, SessionCompleteResultDto>;
  @useResult
  $Res call(
      {bool success,
      String message,
      String? newStatus,
      int pointsAwarded,
      DateTime? nextReviewAt,
      List<String> unmetConditions});
}

/// @nodoc
class _$SessionCompleteResultDtoCopyWithImpl<$Res,
        $Val extends SessionCompleteResultDto>
    implements $SessionCompleteResultDtoCopyWith<$Res> {
  _$SessionCompleteResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? newStatus = freezed,
    Object? pointsAwarded = null,
    Object? nextReviewAt = freezed,
    Object? unmetConditions = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      newStatus: freezed == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      pointsAwarded: null == pointsAwarded
          ? _value.pointsAwarded
          : pointsAwarded // ignore: cast_nullable_to_non_nullable
              as int,
      nextReviewAt: freezed == nextReviewAt
          ? _value.nextReviewAt
          : nextReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unmetConditions: null == unmetConditions
          ? _value.unmetConditions
          : unmetConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionCompleteResultDtoImplCopyWith<$Res>
    implements $SessionCompleteResultDtoCopyWith<$Res> {
  factory _$$SessionCompleteResultDtoImplCopyWith(
          _$SessionCompleteResultDtoImpl value,
          $Res Function(_$SessionCompleteResultDtoImpl) then) =
      __$$SessionCompleteResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String message,
      String? newStatus,
      int pointsAwarded,
      DateTime? nextReviewAt,
      List<String> unmetConditions});
}

/// @nodoc
class __$$SessionCompleteResultDtoImplCopyWithImpl<$Res>
    extends _$SessionCompleteResultDtoCopyWithImpl<$Res,
        _$SessionCompleteResultDtoImpl>
    implements _$$SessionCompleteResultDtoImplCopyWith<$Res> {
  __$$SessionCompleteResultDtoImplCopyWithImpl(
      _$SessionCompleteResultDtoImpl _value,
      $Res Function(_$SessionCompleteResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? message = null,
    Object? newStatus = freezed,
    Object? pointsAwarded = null,
    Object? nextReviewAt = freezed,
    Object? unmetConditions = null,
  }) {
    return _then(_$SessionCompleteResultDtoImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      newStatus: freezed == newStatus
          ? _value.newStatus
          : newStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      pointsAwarded: null == pointsAwarded
          ? _value.pointsAwarded
          : pointsAwarded // ignore: cast_nullable_to_non_nullable
              as int,
      nextReviewAt: freezed == nextReviewAt
          ? _value.nextReviewAt
          : nextReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unmetConditions: null == unmetConditions
          ? _value._unmetConditions
          : unmetConditions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionCompleteResultDtoImpl implements _SessionCompleteResultDto {
  const _$SessionCompleteResultDtoImpl(
      {required this.success,
      required this.message,
      this.newStatus,
      this.pointsAwarded = 0,
      this.nextReviewAt,
      final List<String> unmetConditions = const []})
      : _unmetConditions = unmetConditions;

  factory _$SessionCompleteResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionCompleteResultDtoImplFromJson(json);

  @override
  final bool success;
  @override
  final String message;
  @override
  final String? newStatus;
  @override
  @JsonKey()
  final int pointsAwarded;
  @override
  final DateTime? nextReviewAt;
  final List<String> _unmetConditions;
  @override
  @JsonKey()
  List<String> get unmetConditions {
    if (_unmetConditions is EqualUnmodifiableListView) return _unmetConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unmetConditions);
  }

  @override
  String toString() {
    return 'SessionCompleteResultDto(success: $success, message: $message, newStatus: $newStatus, pointsAwarded: $pointsAwarded, nextReviewAt: $nextReviewAt, unmetConditions: $unmetConditions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionCompleteResultDtoImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.newStatus, newStatus) ||
                other.newStatus == newStatus) &&
            (identical(other.pointsAwarded, pointsAwarded) ||
                other.pointsAwarded == pointsAwarded) &&
            (identical(other.nextReviewAt, nextReviewAt) ||
                other.nextReviewAt == nextReviewAt) &&
            const DeepCollectionEquality()
                .equals(other._unmetConditions, _unmetConditions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      success,
      message,
      newStatus,
      pointsAwarded,
      nextReviewAt,
      const DeepCollectionEquality().hash(_unmetConditions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionCompleteResultDtoImplCopyWith<_$SessionCompleteResultDtoImpl>
      get copyWith => __$$SessionCompleteResultDtoImplCopyWithImpl<
          _$SessionCompleteResultDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionCompleteResultDtoImplToJson(
      this,
    );
  }
}

abstract class _SessionCompleteResultDto implements SessionCompleteResultDto {
  const factory _SessionCompleteResultDto(
      {required final bool success,
      required final String message,
      final String? newStatus,
      final int pointsAwarded,
      final DateTime? nextReviewAt,
      final List<String> unmetConditions}) = _$SessionCompleteResultDtoImpl;

  factory _SessionCompleteResultDto.fromJson(Map<String, dynamic> json) =
      _$SessionCompleteResultDtoImpl.fromJson;

  @override
  bool get success;
  @override
  String get message;
  @override
  String? get newStatus;
  @override
  int get pointsAwarded;
  @override
  DateTime? get nextReviewAt;
  @override
  List<String> get unmetConditions;
  @override
  @JsonKey(ignore: true)
  _$$SessionCompleteResultDtoImplCopyWith<_$SessionCompleteResultDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SessionQuizSubmitDto _$SessionQuizSubmitDtoFromJson(Map<String, dynamic> json) {
  return _SessionQuizSubmitDto.fromJson(json);
}

/// @nodoc
mixin _$SessionQuizSubmitDto {
  bool get isCorrect => throw _privateConstructorUsedError;
  String get userAnswer => throw _privateConstructorUsedError;
  int get timeSpentMs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionQuizSubmitDtoCopyWith<SessionQuizSubmitDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionQuizSubmitDtoCopyWith<$Res> {
  factory $SessionQuizSubmitDtoCopyWith(SessionQuizSubmitDto value,
          $Res Function(SessionQuizSubmitDto) then) =
      _$SessionQuizSubmitDtoCopyWithImpl<$Res, SessionQuizSubmitDto>;
  @useResult
  $Res call({bool isCorrect, String userAnswer, int timeSpentMs});
}

/// @nodoc
class _$SessionQuizSubmitDtoCopyWithImpl<$Res,
        $Val extends SessionQuizSubmitDto>
    implements $SessionQuizSubmitDtoCopyWith<$Res> {
  _$SessionQuizSubmitDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? userAnswer = null,
    Object? timeSpentMs = null,
  }) {
    return _then(_value.copyWith(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      userAnswer: null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      timeSpentMs: null == timeSpentMs
          ? _value.timeSpentMs
          : timeSpentMs // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionQuizSubmitDtoImplCopyWith<$Res>
    implements $SessionQuizSubmitDtoCopyWith<$Res> {
  factory _$$SessionQuizSubmitDtoImplCopyWith(_$SessionQuizSubmitDtoImpl value,
          $Res Function(_$SessionQuizSubmitDtoImpl) then) =
      __$$SessionQuizSubmitDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isCorrect, String userAnswer, int timeSpentMs});
}

/// @nodoc
class __$$SessionQuizSubmitDtoImplCopyWithImpl<$Res>
    extends _$SessionQuizSubmitDtoCopyWithImpl<$Res, _$SessionQuizSubmitDtoImpl>
    implements _$$SessionQuizSubmitDtoImplCopyWith<$Res> {
  __$$SessionQuizSubmitDtoImplCopyWithImpl(_$SessionQuizSubmitDtoImpl _value,
      $Res Function(_$SessionQuizSubmitDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? userAnswer = null,
    Object? timeSpentMs = null,
  }) {
    return _then(_$SessionQuizSubmitDtoImpl(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      userAnswer: null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      timeSpentMs: null == timeSpentMs
          ? _value.timeSpentMs
          : timeSpentMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionQuizSubmitDtoImpl implements _SessionQuizSubmitDto {
  const _$SessionQuizSubmitDtoImpl(
      {required this.isCorrect,
      required this.userAnswer,
      required this.timeSpentMs});

  factory _$SessionQuizSubmitDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionQuizSubmitDtoImplFromJson(json);

  @override
  final bool isCorrect;
  @override
  final String userAnswer;
  @override
  final int timeSpentMs;

  @override
  String toString() {
    return 'SessionQuizSubmitDto(isCorrect: $isCorrect, userAnswer: $userAnswer, timeSpentMs: $timeSpentMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionQuizSubmitDtoImpl &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.userAnswer, userAnswer) ||
                other.userAnswer == userAnswer) &&
            (identical(other.timeSpentMs, timeSpentMs) ||
                other.timeSpentMs == timeSpentMs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isCorrect, userAnswer, timeSpentMs);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionQuizSubmitDtoImplCopyWith<_$SessionQuizSubmitDtoImpl>
      get copyWith =>
          __$$SessionQuizSubmitDtoImplCopyWithImpl<_$SessionQuizSubmitDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionQuizSubmitDtoImplToJson(
      this,
    );
  }
}

abstract class _SessionQuizSubmitDto implements SessionQuizSubmitDto {
  const factory _SessionQuizSubmitDto(
      {required final bool isCorrect,
      required final String userAnswer,
      required final int timeSpentMs}) = _$SessionQuizSubmitDtoImpl;

  factory _SessionQuizSubmitDto.fromJson(Map<String, dynamic> json) =
      _$SessionQuizSubmitDtoImpl.fromJson;

  @override
  bool get isCorrect;
  @override
  String get userAnswer;
  @override
  int get timeSpentMs;
  @override
  @JsonKey(ignore: true)
  _$$SessionQuizSubmitDtoImplCopyWith<_$SessionQuizSubmitDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SessionQuizResultDto _$SessionQuizResultDtoFromJson(Map<String, dynamic> json) {
  return _SessionQuizResultDto.fromJson(json);
}

/// @nodoc
mixin _$SessionQuizResultDto {
  bool get isCorrect => throw _privateConstructorUsedError;
  String get feedback => throw _privateConstructorUsedError;
  bool get sessionQuizPassed => throw _privateConstructorUsedError;
  bool get canComplete => throw _privateConstructorUsedError;
  int get scoreAwarded => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionQuizResultDtoCopyWith<SessionQuizResultDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionQuizResultDtoCopyWith<$Res> {
  factory $SessionQuizResultDtoCopyWith(SessionQuizResultDto value,
          $Res Function(SessionQuizResultDto) then) =
      _$SessionQuizResultDtoCopyWithImpl<$Res, SessionQuizResultDto>;
  @useResult
  $Res call(
      {bool isCorrect,
      String feedback,
      bool sessionQuizPassed,
      bool canComplete,
      int scoreAwarded});
}

/// @nodoc
class _$SessionQuizResultDtoCopyWithImpl<$Res,
        $Val extends SessionQuizResultDto>
    implements $SessionQuizResultDtoCopyWith<$Res> {
  _$SessionQuizResultDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? feedback = null,
    Object? sessionQuizPassed = null,
    Object? canComplete = null,
    Object? scoreAwarded = null,
  }) {
    return _then(_value.copyWith(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      feedback: null == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String,
      sessionQuizPassed: null == sessionQuizPassed
          ? _value.sessionQuizPassed
          : sessionQuizPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      canComplete: null == canComplete
          ? _value.canComplete
          : canComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      scoreAwarded: null == scoreAwarded
          ? _value.scoreAwarded
          : scoreAwarded // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionQuizResultDtoImplCopyWith<$Res>
    implements $SessionQuizResultDtoCopyWith<$Res> {
  factory _$$SessionQuizResultDtoImplCopyWith(_$SessionQuizResultDtoImpl value,
          $Res Function(_$SessionQuizResultDtoImpl) then) =
      __$$SessionQuizResultDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isCorrect,
      String feedback,
      bool sessionQuizPassed,
      bool canComplete,
      int scoreAwarded});
}

/// @nodoc
class __$$SessionQuizResultDtoImplCopyWithImpl<$Res>
    extends _$SessionQuizResultDtoCopyWithImpl<$Res, _$SessionQuizResultDtoImpl>
    implements _$$SessionQuizResultDtoImplCopyWith<$Res> {
  __$$SessionQuizResultDtoImplCopyWithImpl(_$SessionQuizResultDtoImpl _value,
      $Res Function(_$SessionQuizResultDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isCorrect = null,
    Object? feedback = null,
    Object? sessionQuizPassed = null,
    Object? canComplete = null,
    Object? scoreAwarded = null,
  }) {
    return _then(_$SessionQuizResultDtoImpl(
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      feedback: null == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String,
      sessionQuizPassed: null == sessionQuizPassed
          ? _value.sessionQuizPassed
          : sessionQuizPassed // ignore: cast_nullable_to_non_nullable
              as bool,
      canComplete: null == canComplete
          ? _value.canComplete
          : canComplete // ignore: cast_nullable_to_non_nullable
              as bool,
      scoreAwarded: null == scoreAwarded
          ? _value.scoreAwarded
          : scoreAwarded // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionQuizResultDtoImpl implements _SessionQuizResultDto {
  const _$SessionQuizResultDtoImpl(
      {required this.isCorrect,
      required this.feedback,
      required this.sessionQuizPassed,
      required this.canComplete,
      this.scoreAwarded = 0});

  factory _$SessionQuizResultDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionQuizResultDtoImplFromJson(json);

  @override
  final bool isCorrect;
  @override
  final String feedback;
  @override
  final bool sessionQuizPassed;
  @override
  final bool canComplete;
  @override
  @JsonKey()
  final int scoreAwarded;

  @override
  String toString() {
    return 'SessionQuizResultDto(isCorrect: $isCorrect, feedback: $feedback, sessionQuizPassed: $sessionQuizPassed, canComplete: $canComplete, scoreAwarded: $scoreAwarded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionQuizResultDtoImpl &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback) &&
            (identical(other.sessionQuizPassed, sessionQuizPassed) ||
                other.sessionQuizPassed == sessionQuizPassed) &&
            (identical(other.canComplete, canComplete) ||
                other.canComplete == canComplete) &&
            (identical(other.scoreAwarded, scoreAwarded) ||
                other.scoreAwarded == scoreAwarded));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isCorrect, feedback,
      sessionQuizPassed, canComplete, scoreAwarded);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionQuizResultDtoImplCopyWith<_$SessionQuizResultDtoImpl>
      get copyWith =>
          __$$SessionQuizResultDtoImplCopyWithImpl<_$SessionQuizResultDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionQuizResultDtoImplToJson(
      this,
    );
  }
}

abstract class _SessionQuizResultDto implements SessionQuizResultDto {
  const factory _SessionQuizResultDto(
      {required final bool isCorrect,
      required final String feedback,
      required final bool sessionQuizPassed,
      required final bool canComplete,
      final int scoreAwarded}) = _$SessionQuizResultDtoImpl;

  factory _SessionQuizResultDto.fromJson(Map<String, dynamic> json) =
      _$SessionQuizResultDtoImpl.fromJson;

  @override
  bool get isCorrect;
  @override
  String get feedback;
  @override
  bool get sessionQuizPassed;
  @override
  bool get canComplete;
  @override
  int get scoreAwarded;
  @override
  @JsonKey(ignore: true)
  _$$SessionQuizResultDtoImplCopyWith<_$SessionQuizResultDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
