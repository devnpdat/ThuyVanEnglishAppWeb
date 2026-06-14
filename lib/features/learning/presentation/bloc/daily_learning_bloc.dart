import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/learning/data/dtos/daily_learning_dto.dart';
import 'package:english_learning_app/features/learning/data/repositories/daily_learning_repository.dart';

part 'daily_learning_bloc.freezed.dart';

final _getIt = GetIt.instance;

// --- Events ---
@freezed
class DailyLearningEvent with _$DailyLearningEvent {
  const factory DailyLearningEvent.loadToday() = _LoadToday;
  const factory DailyLearningEvent.generateToday() = _GenerateToday;
  const factory DailyLearningEvent.audioPlayed(String sentenceId) = _AudioPlayed;
  const factory DailyLearningEvent.typingAttempt(String sentenceId, String userInput, int elapsedSeconds) = _TypingAttempt;
  const factory DailyLearningEvent.quizSubmit(String sentenceId, bool isCorrect, String userAnswer, int timeSpentMs) = _QuizSubmit;
  const factory DailyLearningEvent.completeSession(String sentenceId) = _CompleteSession;
}

// --- States ---
@freezed
class DailyLearningState with _$DailyLearningState {
  const factory DailyLearningState.initial() = _Initial;
  const factory DailyLearningState.loading() = _Loading;
  const factory DailyLearningState.loaded(TodayLearningDto todayLearning) = _Loaded;
  const factory DailyLearningState.error(String message) = _Error;
  const factory DailyLearningState.typingResult(TypingResultDto result, TodayLearningDto currentLearning) = _TypingResult;
  const factory DailyLearningState.quizResult(SessionQuizResultDto result, TodayLearningDto currentLearning) = _QuizResult;
  const factory DailyLearningState.completeResult(SessionCompleteResultDto result, TodayLearningDto currentLearning) = _CompleteResult;
}

// --- Bloc ---
class DailyLearningBloc extends Bloc<DailyLearningEvent, DailyLearningState> {
  final DailyLearningRepository _repository;

  DailyLearningBloc({DailyLearningRepository? repository})
      : _repository = repository ?? _getIt<DailyLearningRepository>(),
        super(const DailyLearningState.initial()) {
    on<_LoadToday>(_onLoadToday);
    on<_GenerateToday>(_onGenerateToday);
    on<_AudioPlayed>(_onAudioPlayed);
    on<_TypingAttempt>(_onTypingAttempt);
    on<_QuizSubmit>(_onQuizSubmit);
    on<_CompleteSession>(_onCompleteSession);
  }

  TodayLearningDto? get _currentLearning => state.maybeWhen(
        loaded: (learning) => learning,
        typingResult: (_, learning) => learning,
        quizResult: (_, learning) => learning,
        completeResult: (_, learning) => learning,
        orElse: () => null,
      );

  Future<void> _onLoadToday(_LoadToday event, Emitter<DailyLearningState> emit) async {
    emit(const DailyLearningState.loading());
    try {
      final todayLearning = await _repository.getTodayLearning();
      emit(DailyLearningState.loaded(todayLearning));
    } catch (e) {
      emit(DailyLearningState.error(e.toString()));
    }
  }

  Future<void> _onGenerateToday(_GenerateToday event, Emitter<DailyLearningState> emit) async {
    emit(const DailyLearningState.loading());
    try {
      final todayLearning = await _repository.generateTodayPlan();
      emit(DailyLearningState.loaded(todayLearning));
    } catch (e) {
      emit(DailyLearningState.error(e.toString()));
    }
  }

  Future<void> _onAudioPlayed(_AudioPlayed event, Emitter<DailyLearningState> emit) async {
    final current = _currentLearning;
    if (current == null) return;
    try {
      await _repository.recordAudioPlayed(event.sentenceId);
      // Ideally we would update the state, but we can just reload or update locally.
      // For simplicity, we just reload for now, or assume success and don't change state much.
    } catch (e) {
      // Ignored for now or could log
    }
  }

  Future<void> _onTypingAttempt(_TypingAttempt event, Emitter<DailyLearningState> emit) async {
    final current = _currentLearning;
    if (current == null) return;
    try {
      final result = await _repository.submitTypingAttempt(
        event.sentenceId, 
        TypingAttemptDto(userInput: event.userInput, elapsedSeconds: event.elapsedSeconds)
      );
      emit(DailyLearningState.typingResult(result, current));
    } catch (e) {
      emit(DailyLearningState.error(e.toString()));
    }
  }

  Future<void> _onQuizSubmit(_QuizSubmit event, Emitter<DailyLearningState> emit) async {
    final current = _currentLearning;
    if (current == null) return;
    try {
      final result = await _repository.submitSessionQuiz(
        event.sentenceId, 
        SessionQuizSubmitDto(
          isCorrect: event.isCorrect,
          userAnswer: event.userAnswer,
          timeSpentMs: event.timeSpentMs,
        )
      );
      emit(DailyLearningState.quizResult(result, current));
    } catch (e) {
      emit(DailyLearningState.error(e.toString()));
    }
  }

  Future<void> _onCompleteSession(_CompleteSession event, Emitter<DailyLearningState> emit) async {
    final current = _currentLearning;
    if (current == null) return;
    try {
      final result = await _repository.completeSession(event.sentenceId);
      emit(DailyLearningState.completeResult(result, current));
      
      // Mặc dù hoàn thành một session, cần lấy lại danh sách mới nhất để cập nhật status
      final updatedLearning = await _repository.getTodayLearning();
      emit(DailyLearningState.loaded(updatedLearning));
    } catch (e) {
      emit(DailyLearningState.error(e.toString()));
    }
  }
}
