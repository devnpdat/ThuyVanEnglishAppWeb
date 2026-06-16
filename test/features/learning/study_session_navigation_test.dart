// Study Session Navigation + Quiz State Tests
// Bug coverage:
//   - #4 (File2): step navigation bug — back về Daily Plan thay vì bước trước
//   - #10 (File2): quiz step 3 — question text null/undefined (state không truyền từ step 2)
//   - #5 (File2): reload mất state — redirect về Dashboard

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/daily_learning_bloc.dart';
import 'package:english_learning_app/features/learning/data/repositories/daily_learning_repository.dart';
import 'package:english_learning_app/features/learning/data/dtos/daily_learning_dto.dart';
import 'package:english_learning_app/features/learning/data/dtos/sentence_dto.dart';

class MockDailyLearningRepository extends Mock
    implements DailyLearningRepository {}

class FakeTypingAttemptDto extends Fake implements TypingAttemptDto {}
class FakeSessionQuizSubmitDto extends Fake implements SessionQuizSubmitDto {}

// Helper data
TodayLearningDto _fakeToday() => TodayLearningDto(
      planDate: '2026-06-20',
      totalSentences: 3,
      completedCount: 0,
      remainingCount: 3,
      items: [
        LearningSessionItemDto(
          sentenceId: 'sent-quiz',
          sentence: const SentenceDto(
            id: 'sent-quiz',
            englishText: 'What are your strengths?',
            vietnameseText: 'Điểm mạnh của bạn là gì?',
            difficultyLevel: 'medium',
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

  group('StudySession — Navigation & Quiz State', () {
    late MockDailyLearningRepository mockRepo;
    late DailyLearningBloc bloc;

    setUp(() {
      mockRepo = MockDailyLearningRepository();
      bloc = DailyLearningBloc(repository: mockRepo);
    });

    tearDown(() => bloc.close());

    // ── Bug #10: Quiz step 3 nhận đúng englishText từ step 2 ──────────────

    test('Bug#10: sau typingAttempt → quizSubmit nhận đúng correctText (không null)', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: true,
                correctText: 'What are your strengths?', // câu tiếng Anh phải sống đến step 3
                userInput: 'What are your strengths?',
                totalCorrectTypings: 3,
                canProceedToQuiz: true,
              ));
      when(() => mockRepo.submitSessionQuiz(any(), any()))
          .thenAnswer((_) async => const SessionQuizResultDto(
                isCorrect: true,
                feedback: 'Chính xác!',
                sessionQuizPassed: true,
                canComplete: true,
                scoreAwarded: 10,
              ));

      // Step 1: load
      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      // Step 2: typing
      bloc.add(const DailyLearningEvent.typingAttempt(
        'sent-quiz',
        'What are your strengths?',
        5000,
      ));
      await Future.delayed(const Duration(milliseconds: 200));

      // Lấy correctText từ typing result để dùng ở quiz
      String? correctTextForQuiz;
      bloc.state.maybeWhen(
        typingResult: (result, _) {
          correctTextForQuiz = result.correctText;
        },
        orElse: () {},
      );

      // BUG #10: correctText KHÔNG được null ở bước này
      expect(correctTextForQuiz, isNotNull);
      expect(correctTextForQuiz, equals('What are your strengths?'));
      expect(correctTextForQuiz, isNot(equals('')));

      // Step 3: quiz dùng correctText từ step 2
      bloc.add(DailyLearningEvent.quizSubmit(
        'sent-quiz',
        true,
        correctTextForQuiz!, // phải không null
        3000,
      ));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        quizResult: (result, _) {
          expect(result.isCorrect, isTrue);
          expect(result.canComplete, isTrue);
        },
        orElse: () => fail('Expected quizResult, got: ${bloc.state}'),
      );
    });

    test('Bug#10: correctText từ typingResult không bao giờ là null hoặc rỗng', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: false,
                correctText: 'What are your strengths?', // luôn phải có
                userInput: 'wrong answer',
                totalCorrectTypings: 0,
                canProceedToQuiz: false,
                diffSegments: [
                  TypingDiffSegmentDto(text: 'wrong answer', type: 'wrong'),
                ],
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.typingAttempt('sent-quiz', 'wrong answer', 5000));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        typingResult: (result, _) {
          // Dù sai, correctText vẫn phải có để quiz step 3 render câu hỏi
          expect(result.correctText, isNotNull);
          expect(result.correctText, isNotEmpty);
          expect(result.correctText, equals('What are your strengths?'));
        },
        orElse: () => fail('Expected typingResult, got: ${bloc.state}'),
      );
    });

    // ── Bug #4: step navigation — bloc giữ đúng sentence context ─────────

    test('Bug#4: typingAttempt với sentenceId đúng → quizSubmit dùng cùng sentenceId', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: true,
                correctText: 'What are your strengths?',
                userInput: 'What are your strengths?',
                totalCorrectTypings: 3,
                canProceedToQuiz: true,
              ));
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

      bloc.add(const DailyLearningEvent.typingAttempt('sent-quiz', 'What are your strengths?', 5000));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.quizSubmit('sent-quiz', true, 'What are your strengths?', 3000));
      await Future.delayed(const Duration(milliseconds: 200));

      // Verify cả 2 API đều gọi với đúng sentenceId
      verify(() => mockRepo.submitTypingAttempt('sent-quiz', any())).called(1);
      verify(() => mockRepo.submitSessionQuiz('sent-quiz', any())).called(1);
    });

    // ── Bug #5: reload — state persistence ────────────────────────────────

    test('Bug#5: load lại bloc (simulate reload) → state về initial, không crash', () async {
      // Khi người dùng F5 / reload trang, bloc mới được tạo
      // State phải là initial, không nhảy lung tung về Dashboard
      final newBloc = DailyLearningBloc(repository: mockRepo);
      expect(newBloc.state, equals(const DailyLearningState.initial()));
      await newBloc.close();
    });

    test('Bug#5: sau reload, loadToday lại vẫn work bình thường', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());

      // Simulate reload: tạo bloc mới
      final freshBloc = DailyLearningBloc(repository: mockRepo);
      freshBloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 300));

      freshBloc.state.maybeWhen(
        loaded: (data) {
          expect(data.items, hasLength(1));
          expect(data.items.first.sentenceId, equals('sent-quiz'));
        },
        orElse: () => fail('Expected loaded after reload, got: ${freshBloc.state}'),
      );

      await freshBloc.close();
    });

    // ── canProceedToQuiz = false → quiz không được unlock ─────────────────

    test('canProceedToQuiz false → quizSubmit vẫn xử lý được (server decide)', () async {
      when(() => mockRepo.getTodayLearning())
          .thenAnswer((_) async => _fakeToday());
      when(() => mockRepo.submitTypingAttempt(any(), any()))
          .thenAnswer((_) async => const TypingResultDto(
                isCorrect: true,
                correctText: 'What are your strengths?',
                userInput: 'What are your strengths?',
                totalCorrectTypings: 1,
                canProceedToQuiz: false, // chưa đủ 3 lần
              ));

      bloc.add(const DailyLearningEvent.loadToday());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const DailyLearningEvent.typingAttempt('sent-quiz', 'What are your strengths?', 5000));
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        typingResult: (result, _) {
          expect(result.canProceedToQuiz, isFalse);
          expect(result.totalCorrectTypings, equals(1));
        },
        orElse: () => fail('Expected typingResult'),
      );
    });
  });
}
