import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/di/service_locator.dart';
import 'package:english_learning_app/features/quiz/data/repositories/quiz_repository.dart';
import 'package:english_learning_app/features/learning/data/dtos/sentence_dto.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class QuizStartEvent extends QuizEvent {
  final SentenceDto sentence;

  const QuizStartEvent({required this.sentence});

  @override
  List<Object?> get props => [sentence];
}

// Legacy support — used in app.dart
class QuizLoadEvent extends QuizEvent {
  final String sentenceId;
  final String quizType;
  final SentenceDto? sentence;

  const QuizLoadEvent({
    required this.sentenceId,
    required this.quizType,
    this.sentence,
  });

  @override
  List<Object?> get props => [sentenceId, quizType];
}

class QuizSubmitAnswerEvent extends QuizEvent {
  final bool isCorrect;
  final String userAnswer;
  final int selectedOptionIndex;

  const QuizSubmitAnswerEvent({
    required this.isCorrect,
    required this.userAnswer,
    this.selectedOptionIndex = 0,
  });

  @override
  List<Object?> get props => [isCorrect, userAnswer];
}

class QuizNextEvent extends QuizEvent {
  const QuizNextEvent();
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {
  const QuizInitial();
}

class QuizLoading extends QuizState {
  const QuizLoading();
}

class QuizLoaded extends QuizState {
  final SentenceDto sentence;
  final String question;
  final List<String> options;
  final int correctIndex;
  final int? selectedOptionIndex;
  final bool isAnswered;
  final bool isCorrect;
  final String explanation;
  final int currentQuestion;
  final int totalQuestions;

  const QuizLoaded({
    required this.sentence,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.selectedOptionIndex,
    required this.isAnswered,
    required this.isCorrect,
    required this.explanation,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  @override
  List<Object?> get props => [
        sentence,
        question,
        options,
        correctIndex,
        selectedOptionIndex,
        isAnswered,
        isCorrect,
        currentQuestion,
      ];
}

class QuizCompleted extends QuizState {
  final int correctCount;
  final int totalCount;
  final int scoreAwarded;

  const QuizCompleted({
    required this.correctCount,
    required this.totalCount,
    required this.scoreAwarded,
  });

  @override
  List<Object?> get props => [correctCount, totalCount, scoreAwarded];
}

class QuizError extends QuizState {
  final String message;

  const QuizError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _quizRepository;

  int _correctCount = 0;
  int _currentQuestion = 0;
  int _totalPoints = 0;
  SentenceDto? _currentSentence;
  List<SentenceDto> _sentences = [];
  final Stopwatch _stopwatch = Stopwatch();

  QuizBloc({QuizRepository? quizRepository})
      : _quizRepository = quizRepository ?? getIt<QuizRepository>(),
        super(const QuizInitial()) {
    on<QuizLoadEvent>(_onLoad);
    on<QuizStartEvent>(_onStart);
    on<QuizSubmitAnswerEvent>(_onSubmitAnswer);
    on<QuizNextEvent>(_onNext);
  }

  /// Load quiz từ một sentenceId (legacy route)
  Future<void> _onLoad(QuizLoadEvent event, Emitter<QuizState> emit) async {
    emit(const QuizLoading());
    try {
      if (event.sentence != null) {
        _sentences = [event.sentence!];
      } else {
        // Không có sentence → không thể tạo quiz
        emit(const QuizError(message: 'Không tìm thấy câu để làm quiz'));
        return;
      }
      _currentQuestion = 0;
      _correctCount = 0;
      _totalPoints = 0;
      _currentSentence = _sentences[0];
      _stopwatch.reset();
      _stopwatch.start();
      emit(_buildQuizState(_sentences[0], 1, _sentences.length));
    } catch (e) {
      emit(QuizError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  /// Start quiz từ một sentence cụ thể
  Future<void> _onStart(QuizStartEvent event, Emitter<QuizState> emit) async {
    emit(const QuizLoading());
    _sentences = [event.sentence];
    _currentQuestion = 0;
    _correctCount = 0;
    _totalPoints = 0;
    _currentSentence = event.sentence;
    _stopwatch.reset();
    _stopwatch.start();
    emit(_buildQuizState(event.sentence, 1, 1));
  }

  /// Submit câu trả lời — gửi lên API
  Future<void> _onSubmitAnswer(
      QuizSubmitAnswerEvent event, Emitter<QuizState> emit) async {
    if (state is! QuizLoaded) return;
    final currentState = state as QuizLoaded;

    if (event.isCorrect) _correctCount++;

    // Gọi API submit (non-blocking — lỗi không ảnh hưởng UX)
    _stopwatch.stop();
    final timeSpent = _stopwatch.elapsed.inSeconds.clamp(1, 300);
    try {
      await _quizRepository.submitQuizAttempt(
        CreateQuizAttemptRequest(
          sentenceId: currentState.sentence.id,
          quizType: 'multiple_choice',
          userAnswer: event.userAnswer,
          timeSpentSeconds: timeSpent,
          isCorrect: event.isCorrect,
        ),
      );
    } catch (_) {
      // Submit lỗi — tiếp tục mà không báo lỗi
    }

    emit(QuizLoaded(
      sentence: currentState.sentence,
      question: currentState.question,
      options: currentState.options,
      correctIndex: currentState.correctIndex,
      selectedOptionIndex: event.selectedOptionIndex,
      isAnswered: true,
      isCorrect: event.isCorrect,
      explanation: event.isCorrect
          ? '✅ Chính xác! Tuyệt vời! 🎉'
          : '❌ Chưa đúng. Đáp án: ${currentState.options[currentState.correctIndex]}',
      currentQuestion: currentState.currentQuestion,
      totalQuestions: currentState.totalQuestions,
    ));
  }

  Future<void> _onNext(QuizNextEvent event, Emitter<QuizState> emit) async {
    if (state is! QuizLoaded) return;
    final currentState = state as QuizLoaded;

    if (currentState.currentQuestion >= currentState.totalQuestions) {
      emit(QuizCompleted(
        correctCount: _correctCount,
        totalCount: currentState.totalQuestions,
        scoreAwarded: _correctCount * 10,
      ));
      return;
    }

    _currentQuestion++;
    if (_currentQuestion < _sentences.length) {
      _currentSentence = _sentences[_currentQuestion];
      _stopwatch.reset();
      _stopwatch.start();
      emit(_buildQuizState(
          _currentSentence!, _currentQuestion + 1, _sentences.length));
    } else {
      emit(QuizCompleted(
        correctCount: _correctCount,
        totalCount: currentState.totalQuestions,
        scoreAwarded: _correctCount * 10,
      ));
    }
  }

  /// Tạo quiz question từ một SentenceDto
  QuizLoaded _buildQuizState(
      SentenceDto sentence, int currentQ, int totalQ) {
    // Quiz: Tiếng Việt → Tiếng Anh
    final correctAnswer = sentence.englishText;
    final questionText = 'Dịch câu sau sang tiếng Anh:\n"${sentence.vietnameseText}"';

    // Tạo 3 lựa chọn sai bằng cách biến đổi câu đúng
    final wrong1 = _mutateAnswer(correctAnswer, 1);
    final wrong2 = _mutateAnswer(correctAnswer, 2);
    final wrong3 = _mutateAnswer(correctAnswer, 3);

    // Shuffle options
    final options = [correctAnswer, wrong1, wrong2, wrong3];
    options.shuffle();
    final correctIndex = options.indexOf(correctAnswer);

    return QuizLoaded(
      sentence: sentence,
      question: questionText,
      options: options,
      correctIndex: correctIndex,
      selectedOptionIndex: null,
      isAnswered: false,
      isCorrect: false,
      explanation: '',
      currentQuestion: currentQ,
      totalQuestions: totalQ,
    );
  }

  /// Tạo câu trả lời sai bằng cách thay thế từ
  String _mutateAnswer(String original, int seed) {
    final words = original.split(' ');
    if (words.length <= 1) return '$original (incorrect)';

    final idx = seed % words.length;
    final replacements = ['something', 'anything', 'everything', 'nothing', 'everything else'];
    final replacement = replacements[seed % replacements.length];
    words[idx] = replacement;
    return words.join(' ');
  }
}
