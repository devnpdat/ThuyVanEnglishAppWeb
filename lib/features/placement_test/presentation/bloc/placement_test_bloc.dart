import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/placement_test/data/dtos/placement_test_dto.dart';
import 'package:english_learning_app/features/placement_test/data/repositories/placement_test_repository.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class PlacementTestEvent extends Equatable {
  const PlacementTestEvent();
  @override
  List<Object?> get props => [];
}

/// Load danh sách câu hỏi từ API
class PlacementTestLoadQuestionsEvent extends PlacementTestEvent {
  const PlacementTestLoadQuestionsEvent();
}

/// User chọn đáp án cho câu hỏi tại index
class PlacementTestAnswerSelectedEvent extends PlacementTestEvent {
  final String questionId;
  final String selectedOption;

  const PlacementTestAnswerSelectedEvent({
    required this.questionId,
    required this.selectedOption,
  });

  @override
  List<Object?> get props => [questionId, selectedOption];
}

/// Nộp bài
class PlacementTestSubmitEvent extends PlacementTestEvent {
  const PlacementTestSubmitEvent();
}

/// Reset để làm lại
class PlacementTestResetEvent extends PlacementTestEvent {
  const PlacementTestResetEvent();
}

class PlacementTestPrevQuestionEvent extends PlacementTestEvent {
  const PlacementTestPrevQuestionEvent();
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class PlacementTestState extends Equatable {
  const PlacementTestState();
  @override
  List<Object?> get props => [];
}

class PlacementTestInitial extends PlacementTestState {
  const PlacementTestInitial();
}

class PlacementTestLoading extends PlacementTestState {
  const PlacementTestLoading();
}

class PlacementTestLoaded extends PlacementTestState {
  final List<PlacementTestQuestionDto> questions;
  /// Map: questionId → selectedOption ("A"/"B"/"C")
  final Map<String, String> answers;
  /// Index câu hiện tại đang hiển thị (0-based)
  final int currentIndex;

  const PlacementTestLoaded({
    required this.questions,
    required this.answers,
    required this.currentIndex,
  });

  int get totalQuestions => questions.length;
  int get answeredCount => answers.length;
  bool get allAnswered => answeredCount >= totalQuestions;

  PlacementTestQuestionDto get currentQuestion => questions[currentIndex];

  bool get canGoNext => currentIndex < totalQuestions - 1;
  bool get canGoPrev => currentIndex > 0;

  PlacementTestLoaded copyWith({
    List<PlacementTestQuestionDto>? questions,
    Map<String, String>? answers,
    int? currentIndex,
  }) {
    return PlacementTestLoaded(
      questions: questions ?? this.questions,
      answers: answers ?? Map.from(this.answers),
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object?> get props => [questions, answers, currentIndex];
}

class PlacementTestSubmitting extends PlacementTestState {
  const PlacementTestSubmitting();
}

class PlacementTestResult extends PlacementTestState {
  final PlacementTestResultDto result;

  const PlacementTestResult({required this.result});

  @override
  List<Object?> get props => [result];
}

class PlacementTestError extends PlacementTestState {
  final String message;

  const PlacementTestError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class PlacementTestBloc extends Bloc<PlacementTestEvent, PlacementTestState> {
  final PlacementTestRepository _repository;

  PlacementTestBloc({PlacementTestRepository? repository})
      : _repository = repository ?? GetIt.instance<PlacementTestRepository>(),
        super(const PlacementTestInitial()) {
    on<PlacementTestLoadQuestionsEvent>(_onLoadQuestions);
    on<PlacementTestAnswerSelectedEvent>(_onAnswerSelected);
    on<PlacementTestPrevQuestionEvent>(_onPrevQuestion);
    on<PlacementTestSubmitEvent>(_onSubmit);
    on<PlacementTestResetEvent>(_onReset);
  }

  Future<void> _onLoadQuestions(
    PlacementTestLoadQuestionsEvent event,
    Emitter<PlacementTestState> emit,
  ) async {
    emit(const PlacementTestLoading());
    try {
      final dto = await _repository.getQuestions();
      emit(PlacementTestLoaded(
        questions: dto.questions,
        answers: {},
        currentIndex: 0,
      ));
    } catch (e) {
      emit(PlacementTestError(message: e.toString()));
    }
  }

  void _onAnswerSelected(
    PlacementTestAnswerSelectedEvent event,
    Emitter<PlacementTestState> emit,
  ) {
    final current = state;
    if (current is! PlacementTestLoaded) return;

    final newAnswers = Map<String, String>.from(current.answers);
    newAnswers[event.questionId] = event.selectedOption;

    // Tự động chuyển sang câu kế nếu chưa ở câu cuối
    final nextIndex = current.canGoNext
        ? current.currentIndex + 1
        : current.currentIndex;

    emit(current.copyWith(answers: newAnswers, currentIndex: nextIndex));
  }

  void _onPrevQuestion(
    PlacementTestPrevQuestionEvent event,
    Emitter<PlacementTestState> emit,
  ) {
    final current = state;
    if (current is! PlacementTestLoaded) return;
    if (!current.canGoPrev) return;

    emit(current.copyWith(currentIndex: current.currentIndex - 1));
  }

  Future<void> _onSubmit(
    PlacementTestSubmitEvent event,
    Emitter<PlacementTestState> emit,
  ) async {
    final current = state;
    if (current is! PlacementTestLoaded) return;

    emit(const PlacementTestSubmitting());
    try {
      final submitDto = PlacementTestSubmitDto(
        answers: current.answers.entries
            .map((e) => PlacementTestAnswerDto(
                  questionId: e.key,
                  selectedOption: e.value,
                ))
            .toList(),
      );
      final result = await _repository.submit(submitDto);
      emit(PlacementTestResult(result: result));
    } catch (e) {
      emit(PlacementTestError(message: e.toString()));
    }
  }

  void _onReset(
    PlacementTestResetEvent event,
    Emitter<PlacementTestState> emit,
  ) {
    emit(const PlacementTestInitial());
  }
}
