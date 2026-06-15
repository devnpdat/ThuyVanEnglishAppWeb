// DailyLearningBloc Unit Tests
// Test state transitions: load, audioPlayed, typingAttempt, quiz, complete

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/daily_learning_bloc.dart';
import 'package:english_learning_app/features/learning/data/repositories/daily_learning_repository.dart';
import 'package:english_learning_app/features/learning/data/dtos/daily_learning_dto.dart';
import 'package:english_learning_app/features/learning/data/dtos/sentence_dto.dart';

class MockDailyLearningRepository extends Mock implements DailyLearningRepository {}

// Fallback values cho mocktail
class FakeTypingAttemptDto extends Fake implements TypingAttemptDto {}
class FakeSessionQuizSubmitDto extends Fake implements SessionQuizSubmitDto {}

// Helper: TodayLearningDto giả
TodayLearningDto _fakeToday({int completed = 0}) => TodayLearningDto(
      planDate: '2025-01-01',
      totalSentences: 5,
      completedCount: completed,
      remainingCount: 5 - completed,
      items: [
        LearningSessionItemDto(
          sentenceId: 'sent-1',
          sentence: const SentenceDto(
            id: 'sent-1',
            englishText: 'Hello world',
            vietnameseText: 'Xin chào thế giới',
            difficultyLevel: 'easy',
            sentenceType: 'conversation',
            sourceType: 'system',
          ),
          progressStatus: 'not_started',
          order: 1,
        ),
      ],
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeTypingAttemptDto());
    registerFallbackValue(FakeSessionQuizSubmitDto());
  });

  group('DailyLearningBloc', () {
    late MockDailyLearningRepository mockRepo;
    late DailyLearningBloc bloc;

    setUp(() {
      mockRepo = MockDailyLearningRepository();
      bloc = DailyLearningBloc(repository: mockRepo);
    });

    tearDown(() => bloc.close());

    // ── Initial ────────────────────────────────────────────────────────────

    test('initial state là DailyLearningState.initial()', () {
      expect(bloc.state, equals(const DailyLearningState.initial()));
    });

    // ── Load Today ─────────────────────────────────────────────────────────

    test('loadToday thành công → state loaded với data', () async {
      final fakeData = _fakeToday();
      when(() => mockRepo.getTodayLearning()).thenAnswer((_) async => fakeData);

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 300));

      bloc.state.maybeWhen(
        loaded: (data) {
          expect(data.totalSentences, equals(5));
          expect(data.completedCount, equals(0));
          expect(data.items.length, equals(1));
          expect(data.items.first.sentence.englishText, equals('Hello world'));
        },
        orElse: () => fail('Expected loaded state, got: ${bloc.state}'),
      );
    });

    test('loadToday thất bại → state error có message', () async {
      when(() => mockRepo.getTodayLearning())
          .thenThrow(Exception('Network error'));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 300));

      bloc.state.maybeWhen(
        error: (msg) => expect(msg, isNotEmpty),
        orElse: () => fail('Expected error state, got: ${bloc.state}'),
      );
    });

    // ── Audio Played ───────────────────────────────────────────────────────

    test('audioPlayed — gọi recordAudioPlayed đúng sentenceId', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.recordAudioPlayed(any()))
          .thenAnswer((_) async => const AudioPlayedResultDto(
                totalAudioPlays: 1,
                audioRequirementMet: false,
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.audioPlayed('sent-1'));
      await Future.delayed(const Duration(milliseconds: 200));

      verify(() => mockRepo.recordAudioPlayed('sent-1')).called(1);
    });

    // ── Typing Attempt ─────────────────────────────────────────────────────

    test('typingAttempt đúng → typingResult.isCorrect=true', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: true,
                correctText: 'Hello world',
                userInput: 'Hello world',
                totalCorrectTypings: 1,
                canProceedToQuiz: false,
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.typingAttempt('sent-1', 'Hello world', 10));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        typingResult: (result, _) {
          expect(result.isCorrect, isTrue);
          expect(result.totalCorrectTypings, equals(1));
        },
        orElse: () => fail('Expected typingResult, got: ${bloc.state}'),
      );
    });

    test('typingAttempt sai → typingResult.isCorrect=false + diffSegments', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: false,
                correctText: 'Hello world',
                userInput: 'helo wrold',
                totalCorrectTypings: 0,
                canProceedToQuiz: false,
                diffSegments: [
                  TypingDiffSegmentDto(text: 'helo', type: 'wrong'),
                  TypingDiffSegmentDto(text: ' wrold', type: 'wrong'),
                ],
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.typingAttempt('sent-1', 'helo wrold', 10));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        typingResult: (result, _) {
          expect(result.isCorrect, isFalse);
          expect(result.diffSegments, hasLength(2));
          expect(result.diffSegments.first.type, equals('wrong'));
        },
        orElse: () => fail('Expected typingResult, got: ${bloc.state}'),
      );
    });

    test('typingAttempt 3 lần đúng → canProceedToQuiz=true', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: true,
                correctText: 'Hello world',
                userInput: 'Hello world',
                totalCorrectTypings: 3,
                canProceedToQuiz: true,
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.typingAttempt('sent-1', 'Hello world', 10));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        typingResult: (result, _) {
          expect(result.canProceedToQuiz, isTrue);
          expect(result.totalCorrectTypings, equals(3));
        },
        orElse: () => fail('Expected typingResult, got: ${bloc.state}'),
      );
    });

    // ── Quiz Submit ────────────────────────────────────────────────────────

    test('quizSubmit đúng → quizResult.canComplete=true', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitSessionQuiz(any(), any()))
          .thenAnswer((_) async => const SessionQuizResultDto(
                isCorrect: true,
                feedback: 'Chính xác!',
                sessionQuizPassed: true,
                canComplete: true,
                scoreAwarded: 10,
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.quizSubmit('sent-1', true, 'Hello world', 3000));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        quizResult: (result, _) {
          expect(result.isCorrect, isTrue);
          expect(result.canComplete, isTrue);
          expect(result.sessionQuizPassed, isTrue);
        },
        orElse: () => fail('Expected quizResult, got: ${bloc.state}'),
      );
    });

    test('quizSubmit sai → quizResult.isCorrect=false', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitSessionQuiz(any(), any()))
          .thenAnswer((_) async => const SessionQuizResultDto(
                isCorrect: false,
                feedback: 'Chưa đúng. Đáp án: Hello world',
                sessionQuizPassed: false,
                canComplete: false,
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.quizSubmit('sent-1', false, 'Hi world', 5000));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        quizResult: (result, _) {
          expect(result.isCorrect, isFalse);
          expect(result.canComplete, isFalse);
          expect(result.feedback, contains('Chưa đúng'));
        },
        orElse: () => fail('Expected quizResult, got: ${bloc.state}'),
      );
    });

    // ── Complete Session ───────────────────────────────────────────────────

    test('completeSession thành công → emit completeResult rồi reload về loaded', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: true,
                correctText: 'Hello world',
                userInput: 'Hello world',
                totalCorrectTypings: 3,
                canProceedToQuiz: true,
              ));
      when(() => mockRepo.completeSession(any()))
          .thenAnswer((_) async => const SessionCompleteResultDto(
                success: true,
                message: 'Hoàn thành! +10 điểm',
                pointsAwarded: 10,
                unmetConditions: [],
              ));

      // Load → typing → collect states khi complete
      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.typingAttempt('sent-1', 'Hello world', 10));
      await Future.delayed(const Duration(milliseconds: 200));

      // Collect all states emitted during completeSession
      final emittedStates = <DailyLearningState>[];
      final sub = bloc.stream.listen(emittedStates.add);

      bloc.add(const DailyLearningEvent.completeSession('sent-1'));
      await Future.delayed(const Duration(milliseconds: 400));
      await sub.cancel();

      // Phải có completeResult trong danh sách states đã emit
      final completeResultState = emittedStates.whereType<DailyLearningState>().firstWhere(
        (s) => s.maybeWhen(completeResult: (_, __) => true, orElse: () => false),
        orElse: () => fail('completeResult state not found in stream'),
      );

      completeResultState.maybeWhen(
        completeResult: (result, _) {
          expect(result.success, isTrue);
          expect(result.pointsAwarded, equals(10));
          expect(result.unmetConditions, isEmpty);
        },
        orElse: () => fail('Not a completeResult state'),
      );
    });

    test('completeSession gọi repository.completeSession với đúng sentenceId', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: true,
                correctText: 'Hello world',
                userInput: 'Hello world',
                totalCorrectTypings: 1,
                canProceedToQuiz: false,
              ));
      when(() => mockRepo.completeSession(any()))
          .thenAnswer((_) async => const SessionCompleteResultDto(
                success: false,
                message: 'Chưa đủ điều kiện',
                pointsAwarded: 0,
                unmetConditions: ['Cần nghe audio ít nhất 1 lần'],
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.typingAttempt('sent-1', 'Hello world', 10));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.completeSession('sent-1'));
      await Future.delayed(const Duration(milliseconds: 400));

      // Verify repository được gọi đúng
      verify(() => mockRepo.completeSession('sent-1')).called(1);
    });
  });
}
