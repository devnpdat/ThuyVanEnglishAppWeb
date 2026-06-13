// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_learning_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DailyLearningEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadToday,
    required TResult Function() generateToday,
    required TResult Function(String sentenceId) audioPlayed,
    required TResult Function(String sentenceId, String userInput)
        typingAttempt,
    required TResult Function(String sentenceId, bool isCorrect,
            String userAnswer, int timeSpentMs)
        quizSubmit,
    required TResult Function(String sentenceId) completeSession,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadToday,
    TResult? Function()? generateToday,
    TResult? Function(String sentenceId)? audioPlayed,
    TResult? Function(String sentenceId, String userInput)? typingAttempt,
    TResult? Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult? Function(String sentenceId)? completeSession,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadToday,
    TResult Function()? generateToday,
    TResult Function(String sentenceId)? audioPlayed,
    TResult Function(String sentenceId, String userInput)? typingAttempt,
    TResult Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult Function(String sentenceId)? completeSession,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadToday value) loadToday,
    required TResult Function(_GenerateToday value) generateToday,
    required TResult Function(_AudioPlayed value) audioPlayed,
    required TResult Function(_TypingAttempt value) typingAttempt,
    required TResult Function(_QuizSubmit value) quizSubmit,
    required TResult Function(_CompleteSession value) completeSession,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadToday value)? loadToday,
    TResult? Function(_GenerateToday value)? generateToday,
    TResult? Function(_AudioPlayed value)? audioPlayed,
    TResult? Function(_TypingAttempt value)? typingAttempt,
    TResult? Function(_QuizSubmit value)? quizSubmit,
    TResult? Function(_CompleteSession value)? completeSession,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadToday value)? loadToday,
    TResult Function(_GenerateToday value)? generateToday,
    TResult Function(_AudioPlayed value)? audioPlayed,
    TResult Function(_TypingAttempt value)? typingAttempt,
    TResult Function(_QuizSubmit value)? quizSubmit,
    TResult Function(_CompleteSession value)? completeSession,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLearningEventCopyWith<$Res> {
  factory $DailyLearningEventCopyWith(
          DailyLearningEvent value, $Res Function(DailyLearningEvent) then) =
      _$DailyLearningEventCopyWithImpl<$Res, DailyLearningEvent>;
}

/// @nodoc
class _$DailyLearningEventCopyWithImpl<$Res, $Val extends DailyLearningEvent>
    implements $DailyLearningEventCopyWith<$Res> {
  _$DailyLearningEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoadTodayImplCopyWith<$Res> {
  factory _$$LoadTodayImplCopyWith(
          _$LoadTodayImpl value, $Res Function(_$LoadTodayImpl) then) =
      __$$LoadTodayImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadTodayImplCopyWithImpl<$Res>
    extends _$DailyLearningEventCopyWithImpl<$Res, _$LoadTodayImpl>
    implements _$$LoadTodayImplCopyWith<$Res> {
  __$$LoadTodayImplCopyWithImpl(
      _$LoadTodayImpl _value, $Res Function(_$LoadTodayImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadTodayImpl implements _LoadToday {
  const _$LoadTodayImpl();

  @override
  String toString() {
    return 'DailyLearningEvent.loadToday()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadTodayImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadToday,
    required TResult Function() generateToday,
    required TResult Function(String sentenceId) audioPlayed,
    required TResult Function(String sentenceId, String userInput)
        typingAttempt,
    required TResult Function(String sentenceId, bool isCorrect,
            String userAnswer, int timeSpentMs)
        quizSubmit,
    required TResult Function(String sentenceId) completeSession,
  }) {
    return loadToday();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadToday,
    TResult? Function()? generateToday,
    TResult? Function(String sentenceId)? audioPlayed,
    TResult? Function(String sentenceId, String userInput)? typingAttempt,
    TResult? Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult? Function(String sentenceId)? completeSession,
  }) {
    return loadToday?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadToday,
    TResult Function()? generateToday,
    TResult Function(String sentenceId)? audioPlayed,
    TResult Function(String sentenceId, String userInput)? typingAttempt,
    TResult Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult Function(String sentenceId)? completeSession,
    required TResult orElse(),
  }) {
    if (loadToday != null) {
      return loadToday();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadToday value) loadToday,
    required TResult Function(_GenerateToday value) generateToday,
    required TResult Function(_AudioPlayed value) audioPlayed,
    required TResult Function(_TypingAttempt value) typingAttempt,
    required TResult Function(_QuizSubmit value) quizSubmit,
    required TResult Function(_CompleteSession value) completeSession,
  }) {
    return loadToday(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadToday value)? loadToday,
    TResult? Function(_GenerateToday value)? generateToday,
    TResult? Function(_AudioPlayed value)? audioPlayed,
    TResult? Function(_TypingAttempt value)? typingAttempt,
    TResult? Function(_QuizSubmit value)? quizSubmit,
    TResult? Function(_CompleteSession value)? completeSession,
  }) {
    return loadToday?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadToday value)? loadToday,
    TResult Function(_GenerateToday value)? generateToday,
    TResult Function(_AudioPlayed value)? audioPlayed,
    TResult Function(_TypingAttempt value)? typingAttempt,
    TResult Function(_QuizSubmit value)? quizSubmit,
    TResult Function(_CompleteSession value)? completeSession,
    required TResult orElse(),
  }) {
    if (loadToday != null) {
      return loadToday(this);
    }
    return orElse();
  }
}

abstract class _LoadToday implements DailyLearningEvent {
  const factory _LoadToday() = _$LoadTodayImpl;
}

/// @nodoc
abstract class _$$GenerateTodayImplCopyWith<$Res> {
  factory _$$GenerateTodayImplCopyWith(
          _$GenerateTodayImpl value, $Res Function(_$GenerateTodayImpl) then) =
      __$$GenerateTodayImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GenerateTodayImplCopyWithImpl<$Res>
    extends _$DailyLearningEventCopyWithImpl<$Res, _$GenerateTodayImpl>
    implements _$$GenerateTodayImplCopyWith<$Res> {
  __$$GenerateTodayImplCopyWithImpl(
      _$GenerateTodayImpl _value, $Res Function(_$GenerateTodayImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GenerateTodayImpl implements _GenerateToday {
  const _$GenerateTodayImpl();

  @override
  String toString() {
    return 'DailyLearningEvent.generateToday()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GenerateTodayImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadToday,
    required TResult Function() generateToday,
    required TResult Function(String sentenceId) audioPlayed,
    required TResult Function(String sentenceId, String userInput)
        typingAttempt,
    required TResult Function(String sentenceId, bool isCorrect,
            String userAnswer, int timeSpentMs)
        quizSubmit,
    required TResult Function(String sentenceId) completeSession,
  }) {
    return generateToday();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadToday,
    TResult? Function()? generateToday,
    TResult? Function(String sentenceId)? audioPlayed,
    TResult? Function(String sentenceId, String userInput)? typingAttempt,
    TResult? Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult? Function(String sentenceId)? completeSession,
  }) {
    return generateToday?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadToday,
    TResult Function()? generateToday,
    TResult Function(String sentenceId)? audioPlayed,
    TResult Function(String sentenceId, String userInput)? typingAttempt,
    TResult Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult Function(String sentenceId)? completeSession,
    required TResult orElse(),
  }) {
    if (generateToday != null) {
      return generateToday();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadToday value) loadToday,
    required TResult Function(_GenerateToday value) generateToday,
    required TResult Function(_AudioPlayed value) audioPlayed,
    required TResult Function(_TypingAttempt value) typingAttempt,
    required TResult Function(_QuizSubmit value) quizSubmit,
    required TResult Function(_CompleteSession value) completeSession,
  }) {
    return generateToday(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadToday value)? loadToday,
    TResult? Function(_GenerateToday value)? generateToday,
    TResult? Function(_AudioPlayed value)? audioPlayed,
    TResult? Function(_TypingAttempt value)? typingAttempt,
    TResult? Function(_QuizSubmit value)? quizSubmit,
    TResult? Function(_CompleteSession value)? completeSession,
  }) {
    return generateToday?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadToday value)? loadToday,
    TResult Function(_GenerateToday value)? generateToday,
    TResult Function(_AudioPlayed value)? audioPlayed,
    TResult Function(_TypingAttempt value)? typingAttempt,
    TResult Function(_QuizSubmit value)? quizSubmit,
    TResult Function(_CompleteSession value)? completeSession,
    required TResult orElse(),
  }) {
    if (generateToday != null) {
      return generateToday(this);
    }
    return orElse();
  }
}

abstract class _GenerateToday implements DailyLearningEvent {
  const factory _GenerateToday() = _$GenerateTodayImpl;
}

/// @nodoc
abstract class _$$AudioPlayedImplCopyWith<$Res> {
  factory _$$AudioPlayedImplCopyWith(
          _$AudioPlayedImpl value, $Res Function(_$AudioPlayedImpl) then) =
      __$$AudioPlayedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sentenceId});
}

/// @nodoc
class __$$AudioPlayedImplCopyWithImpl<$Res>
    extends _$DailyLearningEventCopyWithImpl<$Res, _$AudioPlayedImpl>
    implements _$$AudioPlayedImplCopyWith<$Res> {
  __$$AudioPlayedImplCopyWithImpl(
      _$AudioPlayedImpl _value, $Res Function(_$AudioPlayedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentenceId = null,
  }) {
    return _then(_$AudioPlayedImpl(
      null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AudioPlayedImpl implements _AudioPlayed {
  const _$AudioPlayedImpl(this.sentenceId);

  @override
  final String sentenceId;

  @override
  String toString() {
    return 'DailyLearningEvent.audioPlayed(sentenceId: $sentenceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioPlayedImpl &&
            (identical(other.sentenceId, sentenceId) ||
                other.sentenceId == sentenceId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sentenceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioPlayedImplCopyWith<_$AudioPlayedImpl> get copyWith =>
      __$$AudioPlayedImplCopyWithImpl<_$AudioPlayedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadToday,
    required TResult Function() generateToday,
    required TResult Function(String sentenceId) audioPlayed,
    required TResult Function(String sentenceId, String userInput)
        typingAttempt,
    required TResult Function(String sentenceId, bool isCorrect,
            String userAnswer, int timeSpentMs)
        quizSubmit,
    required TResult Function(String sentenceId) completeSession,
  }) {
    return audioPlayed(sentenceId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadToday,
    TResult? Function()? generateToday,
    TResult? Function(String sentenceId)? audioPlayed,
    TResult? Function(String sentenceId, String userInput)? typingAttempt,
    TResult? Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult? Function(String sentenceId)? completeSession,
  }) {
    return audioPlayed?.call(sentenceId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadToday,
    TResult Function()? generateToday,
    TResult Function(String sentenceId)? audioPlayed,
    TResult Function(String sentenceId, String userInput)? typingAttempt,
    TResult Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult Function(String sentenceId)? completeSession,
    required TResult orElse(),
  }) {
    if (audioPlayed != null) {
      return audioPlayed(sentenceId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadToday value) loadToday,
    required TResult Function(_GenerateToday value) generateToday,
    required TResult Function(_AudioPlayed value) audioPlayed,
    required TResult Function(_TypingAttempt value) typingAttempt,
    required TResult Function(_QuizSubmit value) quizSubmit,
    required TResult Function(_CompleteSession value) completeSession,
  }) {
    return audioPlayed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadToday value)? loadToday,
    TResult? Function(_GenerateToday value)? generateToday,
    TResult? Function(_AudioPlayed value)? audioPlayed,
    TResult? Function(_TypingAttempt value)? typingAttempt,
    TResult? Function(_QuizSubmit value)? quizSubmit,
    TResult? Function(_CompleteSession value)? completeSession,
  }) {
    return audioPlayed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadToday value)? loadToday,
    TResult Function(_GenerateToday value)? generateToday,
    TResult Function(_AudioPlayed value)? audioPlayed,
    TResult Function(_TypingAttempt value)? typingAttempt,
    TResult Function(_QuizSubmit value)? quizSubmit,
    TResult Function(_CompleteSession value)? completeSession,
    required TResult orElse(),
  }) {
    if (audioPlayed != null) {
      return audioPlayed(this);
    }
    return orElse();
  }
}

abstract class _AudioPlayed implements DailyLearningEvent {
  const factory _AudioPlayed(final String sentenceId) = _$AudioPlayedImpl;

  String get sentenceId;
  @JsonKey(ignore: true)
  _$$AudioPlayedImplCopyWith<_$AudioPlayedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TypingAttemptImplCopyWith<$Res> {
  factory _$$TypingAttemptImplCopyWith(
          _$TypingAttemptImpl value, $Res Function(_$TypingAttemptImpl) then) =
      __$$TypingAttemptImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sentenceId, String userInput});
}

/// @nodoc
class __$$TypingAttemptImplCopyWithImpl<$Res>
    extends _$DailyLearningEventCopyWithImpl<$Res, _$TypingAttemptImpl>
    implements _$$TypingAttemptImplCopyWith<$Res> {
  __$$TypingAttemptImplCopyWithImpl(
      _$TypingAttemptImpl _value, $Res Function(_$TypingAttemptImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentenceId = null,
    Object? userInput = null,
  }) {
    return _then(_$TypingAttemptImpl(
      null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
      null == userInput
          ? _value.userInput
          : userInput // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TypingAttemptImpl implements _TypingAttempt {
  const _$TypingAttemptImpl(this.sentenceId, this.userInput);

  @override
  final String sentenceId;
  @override
  final String userInput;

  @override
  String toString() {
    return 'DailyLearningEvent.typingAttempt(sentenceId: $sentenceId, userInput: $userInput)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypingAttemptImpl &&
            (identical(other.sentenceId, sentenceId) ||
                other.sentenceId == sentenceId) &&
            (identical(other.userInput, userInput) ||
                other.userInput == userInput));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sentenceId, userInput);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TypingAttemptImplCopyWith<_$TypingAttemptImpl> get copyWith =>
      __$$TypingAttemptImplCopyWithImpl<_$TypingAttemptImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadToday,
    required TResult Function() generateToday,
    required TResult Function(String sentenceId) audioPlayed,
    required TResult Function(String sentenceId, String userInput)
        typingAttempt,
    required TResult Function(String sentenceId, bool isCorrect,
            String userAnswer, int timeSpentMs)
        quizSubmit,
    required TResult Function(String sentenceId) completeSession,
  }) {
    return typingAttempt(sentenceId, userInput);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadToday,
    TResult? Function()? generateToday,
    TResult? Function(String sentenceId)? audioPlayed,
    TResult? Function(String sentenceId, String userInput)? typingAttempt,
    TResult? Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult? Function(String sentenceId)? completeSession,
  }) {
    return typingAttempt?.call(sentenceId, userInput);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadToday,
    TResult Function()? generateToday,
    TResult Function(String sentenceId)? audioPlayed,
    TResult Function(String sentenceId, String userInput)? typingAttempt,
    TResult Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult Function(String sentenceId)? completeSession,
    required TResult orElse(),
  }) {
    if (typingAttempt != null) {
      return typingAttempt(sentenceId, userInput);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadToday value) loadToday,
    required TResult Function(_GenerateToday value) generateToday,
    required TResult Function(_AudioPlayed value) audioPlayed,
    required TResult Function(_TypingAttempt value) typingAttempt,
    required TResult Function(_QuizSubmit value) quizSubmit,
    required TResult Function(_CompleteSession value) completeSession,
  }) {
    return typingAttempt(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadToday value)? loadToday,
    TResult? Function(_GenerateToday value)? generateToday,
    TResult? Function(_AudioPlayed value)? audioPlayed,
    TResult? Function(_TypingAttempt value)? typingAttempt,
    TResult? Function(_QuizSubmit value)? quizSubmit,
    TResult? Function(_CompleteSession value)? completeSession,
  }) {
    return typingAttempt?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadToday value)? loadToday,
    TResult Function(_GenerateToday value)? generateToday,
    TResult Function(_AudioPlayed value)? audioPlayed,
    TResult Function(_TypingAttempt value)? typingAttempt,
    TResult Function(_QuizSubmit value)? quizSubmit,
    TResult Function(_CompleteSession value)? completeSession,
    required TResult orElse(),
  }) {
    if (typingAttempt != null) {
      return typingAttempt(this);
    }
    return orElse();
  }
}

abstract class _TypingAttempt implements DailyLearningEvent {
  const factory _TypingAttempt(
      final String sentenceId, final String userInput) = _$TypingAttemptImpl;

  String get sentenceId;
  String get userInput;
  @JsonKey(ignore: true)
  _$$TypingAttemptImplCopyWith<_$TypingAttemptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuizSubmitImplCopyWith<$Res> {
  factory _$$QuizSubmitImplCopyWith(
          _$QuizSubmitImpl value, $Res Function(_$QuizSubmitImpl) then) =
      __$$QuizSubmitImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String sentenceId, bool isCorrect, String userAnswer, int timeSpentMs});
}

/// @nodoc
class __$$QuizSubmitImplCopyWithImpl<$Res>
    extends _$DailyLearningEventCopyWithImpl<$Res, _$QuizSubmitImpl>
    implements _$$QuizSubmitImplCopyWith<$Res> {
  __$$QuizSubmitImplCopyWithImpl(
      _$QuizSubmitImpl _value, $Res Function(_$QuizSubmitImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentenceId = null,
    Object? isCorrect = null,
    Object? userAnswer = null,
    Object? timeSpentMs = null,
  }) {
    return _then(_$QuizSubmitImpl(
      null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
      null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      null == timeSpentMs
          ? _value.timeSpentMs
          : timeSpentMs // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$QuizSubmitImpl implements _QuizSubmit {
  const _$QuizSubmitImpl(
      this.sentenceId, this.isCorrect, this.userAnswer, this.timeSpentMs);

  @override
  final String sentenceId;
  @override
  final bool isCorrect;
  @override
  final String userAnswer;
  @override
  final int timeSpentMs;

  @override
  String toString() {
    return 'DailyLearningEvent.quizSubmit(sentenceId: $sentenceId, isCorrect: $isCorrect, userAnswer: $userAnswer, timeSpentMs: $timeSpentMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizSubmitImpl &&
            (identical(other.sentenceId, sentenceId) ||
                other.sentenceId == sentenceId) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.userAnswer, userAnswer) ||
                other.userAnswer == userAnswer) &&
            (identical(other.timeSpentMs, timeSpentMs) ||
                other.timeSpentMs == timeSpentMs));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, sentenceId, isCorrect, userAnswer, timeSpentMs);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizSubmitImplCopyWith<_$QuizSubmitImpl> get copyWith =>
      __$$QuizSubmitImplCopyWithImpl<_$QuizSubmitImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadToday,
    required TResult Function() generateToday,
    required TResult Function(String sentenceId) audioPlayed,
    required TResult Function(String sentenceId, String userInput)
        typingAttempt,
    required TResult Function(String sentenceId, bool isCorrect,
            String userAnswer, int timeSpentMs)
        quizSubmit,
    required TResult Function(String sentenceId) completeSession,
  }) {
    return quizSubmit(sentenceId, isCorrect, userAnswer, timeSpentMs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadToday,
    TResult? Function()? generateToday,
    TResult? Function(String sentenceId)? audioPlayed,
    TResult? Function(String sentenceId, String userInput)? typingAttempt,
    TResult? Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult? Function(String sentenceId)? completeSession,
  }) {
    return quizSubmit?.call(sentenceId, isCorrect, userAnswer, timeSpentMs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadToday,
    TResult Function()? generateToday,
    TResult Function(String sentenceId)? audioPlayed,
    TResult Function(String sentenceId, String userInput)? typingAttempt,
    TResult Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult Function(String sentenceId)? completeSession,
    required TResult orElse(),
  }) {
    if (quizSubmit != null) {
      return quizSubmit(sentenceId, isCorrect, userAnswer, timeSpentMs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadToday value) loadToday,
    required TResult Function(_GenerateToday value) generateToday,
    required TResult Function(_AudioPlayed value) audioPlayed,
    required TResult Function(_TypingAttempt value) typingAttempt,
    required TResult Function(_QuizSubmit value) quizSubmit,
    required TResult Function(_CompleteSession value) completeSession,
  }) {
    return quizSubmit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadToday value)? loadToday,
    TResult? Function(_GenerateToday value)? generateToday,
    TResult? Function(_AudioPlayed value)? audioPlayed,
    TResult? Function(_TypingAttempt value)? typingAttempt,
    TResult? Function(_QuizSubmit value)? quizSubmit,
    TResult? Function(_CompleteSession value)? completeSession,
  }) {
    return quizSubmit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadToday value)? loadToday,
    TResult Function(_GenerateToday value)? generateToday,
    TResult Function(_AudioPlayed value)? audioPlayed,
    TResult Function(_TypingAttempt value)? typingAttempt,
    TResult Function(_QuizSubmit value)? quizSubmit,
    TResult Function(_CompleteSession value)? completeSession,
    required TResult orElse(),
  }) {
    if (quizSubmit != null) {
      return quizSubmit(this);
    }
    return orElse();
  }
}

abstract class _QuizSubmit implements DailyLearningEvent {
  const factory _QuizSubmit(final String sentenceId, final bool isCorrect,
      final String userAnswer, final int timeSpentMs) = _$QuizSubmitImpl;

  String get sentenceId;
  bool get isCorrect;
  String get userAnswer;
  int get timeSpentMs;
  @JsonKey(ignore: true)
  _$$QuizSubmitImplCopyWith<_$QuizSubmitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CompleteSessionImplCopyWith<$Res> {
  factory _$$CompleteSessionImplCopyWith(_$CompleteSessionImpl value,
          $Res Function(_$CompleteSessionImpl) then) =
      __$$CompleteSessionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String sentenceId});
}

/// @nodoc
class __$$CompleteSessionImplCopyWithImpl<$Res>
    extends _$DailyLearningEventCopyWithImpl<$Res, _$CompleteSessionImpl>
    implements _$$CompleteSessionImplCopyWith<$Res> {
  __$$CompleteSessionImplCopyWithImpl(
      _$CompleteSessionImpl _value, $Res Function(_$CompleteSessionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sentenceId = null,
  }) {
    return _then(_$CompleteSessionImpl(
      null == sentenceId
          ? _value.sentenceId
          : sentenceId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CompleteSessionImpl implements _CompleteSession {
  const _$CompleteSessionImpl(this.sentenceId);

  @override
  final String sentenceId;

  @override
  String toString() {
    return 'DailyLearningEvent.completeSession(sentenceId: $sentenceId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteSessionImpl &&
            (identical(other.sentenceId, sentenceId) ||
                other.sentenceId == sentenceId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, sentenceId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteSessionImplCopyWith<_$CompleteSessionImpl> get copyWith =>
      __$$CompleteSessionImplCopyWithImpl<_$CompleteSessionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loadToday,
    required TResult Function() generateToday,
    required TResult Function(String sentenceId) audioPlayed,
    required TResult Function(String sentenceId, String userInput)
        typingAttempt,
    required TResult Function(String sentenceId, bool isCorrect,
            String userAnswer, int timeSpentMs)
        quizSubmit,
    required TResult Function(String sentenceId) completeSession,
  }) {
    return completeSession(sentenceId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loadToday,
    TResult? Function()? generateToday,
    TResult? Function(String sentenceId)? audioPlayed,
    TResult? Function(String sentenceId, String userInput)? typingAttempt,
    TResult? Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult? Function(String sentenceId)? completeSession,
  }) {
    return completeSession?.call(sentenceId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loadToday,
    TResult Function()? generateToday,
    TResult Function(String sentenceId)? audioPlayed,
    TResult Function(String sentenceId, String userInput)? typingAttempt,
    TResult Function(String sentenceId, bool isCorrect, String userAnswer,
            int timeSpentMs)?
        quizSubmit,
    TResult Function(String sentenceId)? completeSession,
    required TResult orElse(),
  }) {
    if (completeSession != null) {
      return completeSession(sentenceId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_LoadToday value) loadToday,
    required TResult Function(_GenerateToday value) generateToday,
    required TResult Function(_AudioPlayed value) audioPlayed,
    required TResult Function(_TypingAttempt value) typingAttempt,
    required TResult Function(_QuizSubmit value) quizSubmit,
    required TResult Function(_CompleteSession value) completeSession,
  }) {
    return completeSession(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_LoadToday value)? loadToday,
    TResult? Function(_GenerateToday value)? generateToday,
    TResult? Function(_AudioPlayed value)? audioPlayed,
    TResult? Function(_TypingAttempt value)? typingAttempt,
    TResult? Function(_QuizSubmit value)? quizSubmit,
    TResult? Function(_CompleteSession value)? completeSession,
  }) {
    return completeSession?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_LoadToday value)? loadToday,
    TResult Function(_GenerateToday value)? generateToday,
    TResult Function(_AudioPlayed value)? audioPlayed,
    TResult Function(_TypingAttempt value)? typingAttempt,
    TResult Function(_QuizSubmit value)? quizSubmit,
    TResult Function(_CompleteSession value)? completeSession,
    required TResult orElse(),
  }) {
    if (completeSession != null) {
      return completeSession(this);
    }
    return orElse();
  }
}

abstract class _CompleteSession implements DailyLearningEvent {
  const factory _CompleteSession(final String sentenceId) =
      _$CompleteSessionImpl;

  String get sentenceId;
  @JsonKey(ignore: true)
  _$$CompleteSessionImplCopyWith<_$CompleteSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DailyLearningState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TodayLearningDto todayLearning) loaded,
    required TResult Function(String message) error,
    required TResult Function(
            TypingResultDto result, TodayLearningDto currentLearning)
        typingResult,
    required TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)
        quizResult,
    required TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)
        completeResult,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TodayLearningDto todayLearning)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult? Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult? Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TodayLearningDto todayLearning)? loaded,
    TResult Function(String message)? error,
    TResult Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_TypingResult value) typingResult,
    required TResult Function(_QuizResult value) quizResult,
    required TResult Function(_CompleteResult value) completeResult,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_TypingResult value)? typingResult,
    TResult? Function(_QuizResult value)? quizResult,
    TResult? Function(_CompleteResult value)? completeResult,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_TypingResult value)? typingResult,
    TResult Function(_QuizResult value)? quizResult,
    TResult Function(_CompleteResult value)? completeResult,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyLearningStateCopyWith<$Res> {
  factory $DailyLearningStateCopyWith(
          DailyLearningState value, $Res Function(DailyLearningState) then) =
      _$DailyLearningStateCopyWithImpl<$Res, DailyLearningState>;
}

/// @nodoc
class _$DailyLearningStateCopyWithImpl<$Res, $Val extends DailyLearningState>
    implements $DailyLearningStateCopyWith<$Res> {
  _$DailyLearningStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$DailyLearningStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'DailyLearningState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TodayLearningDto todayLearning) loaded,
    required TResult Function(String message) error,
    required TResult Function(
            TypingResultDto result, TodayLearningDto currentLearning)
        typingResult,
    required TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)
        quizResult,
    required TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)
        completeResult,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TodayLearningDto todayLearning)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult? Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult? Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TodayLearningDto todayLearning)? loaded,
    TResult Function(String message)? error,
    TResult Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_TypingResult value) typingResult,
    required TResult Function(_QuizResult value) quizResult,
    required TResult Function(_CompleteResult value) completeResult,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_TypingResult value)? typingResult,
    TResult? Function(_QuizResult value)? quizResult,
    TResult? Function(_CompleteResult value)? completeResult,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_TypingResult value)? typingResult,
    TResult Function(_QuizResult value)? quizResult,
    TResult Function(_CompleteResult value)? completeResult,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements DailyLearningState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$DailyLearningStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'DailyLearningState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TodayLearningDto todayLearning) loaded,
    required TResult Function(String message) error,
    required TResult Function(
            TypingResultDto result, TodayLearningDto currentLearning)
        typingResult,
    required TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)
        quizResult,
    required TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)
        completeResult,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TodayLearningDto todayLearning)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult? Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult? Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TodayLearningDto todayLearning)? loaded,
    TResult Function(String message)? error,
    TResult Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_TypingResult value) typingResult,
    required TResult Function(_QuizResult value) quizResult,
    required TResult Function(_CompleteResult value) completeResult,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_TypingResult value)? typingResult,
    TResult? Function(_QuizResult value)? quizResult,
    TResult? Function(_CompleteResult value)? completeResult,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_TypingResult value)? typingResult,
    TResult Function(_QuizResult value)? quizResult,
    TResult Function(_CompleteResult value)? completeResult,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements DailyLearningState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$LoadedImplCopyWith<$Res> {
  factory _$$LoadedImplCopyWith(
          _$LoadedImpl value, $Res Function(_$LoadedImpl) then) =
      __$$LoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TodayLearningDto todayLearning});

  $TodayLearningDtoCopyWith<$Res> get todayLearning;
}

/// @nodoc
class __$$LoadedImplCopyWithImpl<$Res>
    extends _$DailyLearningStateCopyWithImpl<$Res, _$LoadedImpl>
    implements _$$LoadedImplCopyWith<$Res> {
  __$$LoadedImplCopyWithImpl(
      _$LoadedImpl _value, $Res Function(_$LoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todayLearning = null,
  }) {
    return _then(_$LoadedImpl(
      null == todayLearning
          ? _value.todayLearning
          : todayLearning // ignore: cast_nullable_to_non_nullable
              as TodayLearningDto,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TodayLearningDtoCopyWith<$Res> get todayLearning {
    return $TodayLearningDtoCopyWith<$Res>(_value.todayLearning, (value) {
      return _then(_value.copyWith(todayLearning: value));
    });
  }
}

/// @nodoc

class _$LoadedImpl implements _Loaded {
  const _$LoadedImpl(this.todayLearning);

  @override
  final TodayLearningDto todayLearning;

  @override
  String toString() {
    return 'DailyLearningState.loaded(todayLearning: $todayLearning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoadedImpl &&
            (identical(other.todayLearning, todayLearning) ||
                other.todayLearning == todayLearning));
  }

  @override
  int get hashCode => Object.hash(runtimeType, todayLearning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      __$$LoadedImplCopyWithImpl<_$LoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TodayLearningDto todayLearning) loaded,
    required TResult Function(String message) error,
    required TResult Function(
            TypingResultDto result, TodayLearningDto currentLearning)
        typingResult,
    required TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)
        quizResult,
    required TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)
        completeResult,
  }) {
    return loaded(todayLearning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TodayLearningDto todayLearning)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult? Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult? Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
  }) {
    return loaded?.call(todayLearning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TodayLearningDto todayLearning)? loaded,
    TResult Function(String message)? error,
    TResult Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(todayLearning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_TypingResult value) typingResult,
    required TResult Function(_QuizResult value) quizResult,
    required TResult Function(_CompleteResult value) completeResult,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_TypingResult value)? typingResult,
    TResult? Function(_QuizResult value)? quizResult,
    TResult? Function(_CompleteResult value)? completeResult,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_TypingResult value)? typingResult,
    TResult Function(_QuizResult value)? quizResult,
    TResult Function(_CompleteResult value)? completeResult,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _Loaded implements DailyLearningState {
  const factory _Loaded(final TodayLearningDto todayLearning) = _$LoadedImpl;

  TodayLearningDto get todayLearning;
  @JsonKey(ignore: true)
  _$$LoadedImplCopyWith<_$LoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$DailyLearningStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'DailyLearningState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TodayLearningDto todayLearning) loaded,
    required TResult Function(String message) error,
    required TResult Function(
            TypingResultDto result, TodayLearningDto currentLearning)
        typingResult,
    required TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)
        quizResult,
    required TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)
        completeResult,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TodayLearningDto todayLearning)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult? Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult? Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TodayLearningDto todayLearning)? loaded,
    TResult Function(String message)? error,
    TResult Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_TypingResult value) typingResult,
    required TResult Function(_QuizResult value) quizResult,
    required TResult Function(_CompleteResult value) completeResult,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_TypingResult value)? typingResult,
    TResult? Function(_QuizResult value)? quizResult,
    TResult? Function(_CompleteResult value)? completeResult,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_TypingResult value)? typingResult,
    TResult Function(_QuizResult value)? quizResult,
    TResult Function(_CompleteResult value)? completeResult,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements DailyLearningState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;
  @JsonKey(ignore: true)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TypingResultImplCopyWith<$Res> {
  factory _$$TypingResultImplCopyWith(
          _$TypingResultImpl value, $Res Function(_$TypingResultImpl) then) =
      __$$TypingResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TypingResultDto result, TodayLearningDto currentLearning});

  $TypingResultDtoCopyWith<$Res> get result;
  $TodayLearningDtoCopyWith<$Res> get currentLearning;
}

/// @nodoc
class __$$TypingResultImplCopyWithImpl<$Res>
    extends _$DailyLearningStateCopyWithImpl<$Res, _$TypingResultImpl>
    implements _$$TypingResultImplCopyWith<$Res> {
  __$$TypingResultImplCopyWithImpl(
      _$TypingResultImpl _value, $Res Function(_$TypingResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? currentLearning = null,
  }) {
    return _then(_$TypingResultImpl(
      null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as TypingResultDto,
      null == currentLearning
          ? _value.currentLearning
          : currentLearning // ignore: cast_nullable_to_non_nullable
              as TodayLearningDto,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TypingResultDtoCopyWith<$Res> get result {
    return $TypingResultDtoCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TodayLearningDtoCopyWith<$Res> get currentLearning {
    return $TodayLearningDtoCopyWith<$Res>(_value.currentLearning, (value) {
      return _then(_value.copyWith(currentLearning: value));
    });
  }
}

/// @nodoc

class _$TypingResultImpl implements _TypingResult {
  const _$TypingResultImpl(this.result, this.currentLearning);

  @override
  final TypingResultDto result;
  @override
  final TodayLearningDto currentLearning;

  @override
  String toString() {
    return 'DailyLearningState.typingResult(result: $result, currentLearning: $currentLearning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TypingResultImpl &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.currentLearning, currentLearning) ||
                other.currentLearning == currentLearning));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result, currentLearning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TypingResultImplCopyWith<_$TypingResultImpl> get copyWith =>
      __$$TypingResultImplCopyWithImpl<_$TypingResultImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TodayLearningDto todayLearning) loaded,
    required TResult Function(String message) error,
    required TResult Function(
            TypingResultDto result, TodayLearningDto currentLearning)
        typingResult,
    required TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)
        quizResult,
    required TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)
        completeResult,
  }) {
    return typingResult(result, currentLearning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TodayLearningDto todayLearning)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult? Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult? Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
  }) {
    return typingResult?.call(result, currentLearning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TodayLearningDto todayLearning)? loaded,
    TResult Function(String message)? error,
    TResult Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
    required TResult orElse(),
  }) {
    if (typingResult != null) {
      return typingResult(result, currentLearning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_TypingResult value) typingResult,
    required TResult Function(_QuizResult value) quizResult,
    required TResult Function(_CompleteResult value) completeResult,
  }) {
    return typingResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_TypingResult value)? typingResult,
    TResult? Function(_QuizResult value)? quizResult,
    TResult? Function(_CompleteResult value)? completeResult,
  }) {
    return typingResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_TypingResult value)? typingResult,
    TResult Function(_QuizResult value)? quizResult,
    TResult Function(_CompleteResult value)? completeResult,
    required TResult orElse(),
  }) {
    if (typingResult != null) {
      return typingResult(this);
    }
    return orElse();
  }
}

abstract class _TypingResult implements DailyLearningState {
  const factory _TypingResult(final TypingResultDto result,
      final TodayLearningDto currentLearning) = _$TypingResultImpl;

  TypingResultDto get result;
  TodayLearningDto get currentLearning;
  @JsonKey(ignore: true)
  _$$TypingResultImplCopyWith<_$TypingResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$QuizResultImplCopyWith<$Res> {
  factory _$$QuizResultImplCopyWith(
          _$QuizResultImpl value, $Res Function(_$QuizResultImpl) then) =
      __$$QuizResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SessionQuizResultDto result, TodayLearningDto currentLearning});

  $SessionQuizResultDtoCopyWith<$Res> get result;
  $TodayLearningDtoCopyWith<$Res> get currentLearning;
}

/// @nodoc
class __$$QuizResultImplCopyWithImpl<$Res>
    extends _$DailyLearningStateCopyWithImpl<$Res, _$QuizResultImpl>
    implements _$$QuizResultImplCopyWith<$Res> {
  __$$QuizResultImplCopyWithImpl(
      _$QuizResultImpl _value, $Res Function(_$QuizResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? currentLearning = null,
  }) {
    return _then(_$QuizResultImpl(
      null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as SessionQuizResultDto,
      null == currentLearning
          ? _value.currentLearning
          : currentLearning // ignore: cast_nullable_to_non_nullable
              as TodayLearningDto,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $SessionQuizResultDtoCopyWith<$Res> get result {
    return $SessionQuizResultDtoCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TodayLearningDtoCopyWith<$Res> get currentLearning {
    return $TodayLearningDtoCopyWith<$Res>(_value.currentLearning, (value) {
      return _then(_value.copyWith(currentLearning: value));
    });
  }
}

/// @nodoc

class _$QuizResultImpl implements _QuizResult {
  const _$QuizResultImpl(this.result, this.currentLearning);

  @override
  final SessionQuizResultDto result;
  @override
  final TodayLearningDto currentLearning;

  @override
  String toString() {
    return 'DailyLearningState.quizResult(result: $result, currentLearning: $currentLearning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizResultImpl &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.currentLearning, currentLearning) ||
                other.currentLearning == currentLearning));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result, currentLearning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizResultImplCopyWith<_$QuizResultImpl> get copyWith =>
      __$$QuizResultImplCopyWithImpl<_$QuizResultImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TodayLearningDto todayLearning) loaded,
    required TResult Function(String message) error,
    required TResult Function(
            TypingResultDto result, TodayLearningDto currentLearning)
        typingResult,
    required TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)
        quizResult,
    required TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)
        completeResult,
  }) {
    return quizResult(result, currentLearning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TodayLearningDto todayLearning)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult? Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult? Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
  }) {
    return quizResult?.call(result, currentLearning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TodayLearningDto todayLearning)? loaded,
    TResult Function(String message)? error,
    TResult Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
    required TResult orElse(),
  }) {
    if (quizResult != null) {
      return quizResult(result, currentLearning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_TypingResult value) typingResult,
    required TResult Function(_QuizResult value) quizResult,
    required TResult Function(_CompleteResult value) completeResult,
  }) {
    return quizResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_TypingResult value)? typingResult,
    TResult? Function(_QuizResult value)? quizResult,
    TResult? Function(_CompleteResult value)? completeResult,
  }) {
    return quizResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_TypingResult value)? typingResult,
    TResult Function(_QuizResult value)? quizResult,
    TResult Function(_CompleteResult value)? completeResult,
    required TResult orElse(),
  }) {
    if (quizResult != null) {
      return quizResult(this);
    }
    return orElse();
  }
}

abstract class _QuizResult implements DailyLearningState {
  const factory _QuizResult(final SessionQuizResultDto result,
      final TodayLearningDto currentLearning) = _$QuizResultImpl;

  SessionQuizResultDto get result;
  TodayLearningDto get currentLearning;
  @JsonKey(ignore: true)
  _$$QuizResultImplCopyWith<_$QuizResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CompleteResultImplCopyWith<$Res> {
  factory _$$CompleteResultImplCopyWith(_$CompleteResultImpl value,
          $Res Function(_$CompleteResultImpl) then) =
      __$$CompleteResultImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {SessionCompleteResultDto result, TodayLearningDto currentLearning});

  $SessionCompleteResultDtoCopyWith<$Res> get result;
  $TodayLearningDtoCopyWith<$Res> get currentLearning;
}

/// @nodoc
class __$$CompleteResultImplCopyWithImpl<$Res>
    extends _$DailyLearningStateCopyWithImpl<$Res, _$CompleteResultImpl>
    implements _$$CompleteResultImplCopyWith<$Res> {
  __$$CompleteResultImplCopyWithImpl(
      _$CompleteResultImpl _value, $Res Function(_$CompleteResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? result = null,
    Object? currentLearning = null,
  }) {
    return _then(_$CompleteResultImpl(
      null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as SessionCompleteResultDto,
      null == currentLearning
          ? _value.currentLearning
          : currentLearning // ignore: cast_nullable_to_non_nullable
              as TodayLearningDto,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $SessionCompleteResultDtoCopyWith<$Res> get result {
    return $SessionCompleteResultDtoCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TodayLearningDtoCopyWith<$Res> get currentLearning {
    return $TodayLearningDtoCopyWith<$Res>(_value.currentLearning, (value) {
      return _then(_value.copyWith(currentLearning: value));
    });
  }
}

/// @nodoc

class _$CompleteResultImpl implements _CompleteResult {
  const _$CompleteResultImpl(this.result, this.currentLearning);

  @override
  final SessionCompleteResultDto result;
  @override
  final TodayLearningDto currentLearning;

  @override
  String toString() {
    return 'DailyLearningState.completeResult(result: $result, currentLearning: $currentLearning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteResultImpl &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.currentLearning, currentLearning) ||
                other.currentLearning == currentLearning));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result, currentLearning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteResultImplCopyWith<_$CompleteResultImpl> get copyWith =>
      __$$CompleteResultImplCopyWithImpl<_$CompleteResultImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(TodayLearningDto todayLearning) loaded,
    required TResult Function(String message) error,
    required TResult Function(
            TypingResultDto result, TodayLearningDto currentLearning)
        typingResult,
    required TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)
        quizResult,
    required TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)
        completeResult,
  }) {
    return completeResult(result, currentLearning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(TodayLearningDto todayLearning)? loaded,
    TResult? Function(String message)? error,
    TResult? Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult? Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult? Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
  }) {
    return completeResult?.call(result, currentLearning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(TodayLearningDto todayLearning)? loaded,
    TResult Function(String message)? error,
    TResult Function(TypingResultDto result, TodayLearningDto currentLearning)?
        typingResult,
    TResult Function(
            SessionQuizResultDto result, TodayLearningDto currentLearning)?
        quizResult,
    TResult Function(
            SessionCompleteResultDto result, TodayLearningDto currentLearning)?
        completeResult,
    required TResult orElse(),
  }) {
    if (completeResult != null) {
      return completeResult(result, currentLearning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Loaded value) loaded,
    required TResult Function(_Error value) error,
    required TResult Function(_TypingResult value) typingResult,
    required TResult Function(_QuizResult value) quizResult,
    required TResult Function(_CompleteResult value) completeResult,
  }) {
    return completeResult(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Loaded value)? loaded,
    TResult? Function(_Error value)? error,
    TResult? Function(_TypingResult value)? typingResult,
    TResult? Function(_QuizResult value)? quizResult,
    TResult? Function(_CompleteResult value)? completeResult,
  }) {
    return completeResult?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Loaded value)? loaded,
    TResult Function(_Error value)? error,
    TResult Function(_TypingResult value)? typingResult,
    TResult Function(_QuizResult value)? quizResult,
    TResult Function(_CompleteResult value)? completeResult,
    required TResult orElse(),
  }) {
    if (completeResult != null) {
      return completeResult(this);
    }
    return orElse();
  }
}

abstract class _CompleteResult implements DailyLearningState {
  const factory _CompleteResult(final SessionCompleteResultDto result,
      final TodayLearningDto currentLearning) = _$CompleteResultImpl;

  SessionCompleteResultDto get result;
  TodayLearningDto get currentLearning;
  @JsonKey(ignore: true)
  _$$CompleteResultImplCopyWith<_$CompleteResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
