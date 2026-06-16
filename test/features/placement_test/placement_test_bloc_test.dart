// PlacementTest BLoC Unit Tests
// Bug coverage:
//   - #12 (File3): 40 câu → kết quả hiển thị 13/25 (sai totalMaxScore)
//   - #12 (File3): hardcode số câu mỗi phase gây sai lệch (9/5 vô lý)
//   - Logic tính điểm phải dùng totalQuestions từ data, không hardcode

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_learning_app/features/placement_test/presentation/bloc/placement_test_bloc.dart';
import 'package:english_learning_app/features/placement_test/data/repositories/placement_test_repository.dart';
import 'package:english_learning_app/features/placement_test/data/dtos/placement_test_dto.dart';

class MockPlacementTestRepository extends Mock implements PlacementTestRepository {}

class FakePlacementTestSubmitDto extends Fake implements PlacementTestSubmitDto {}

List<PlacementTestQuestionDto> _fakeQuestions({int count = 40}) {
  return List.generate(
    count,
    (i) => PlacementTestQuestionDto(
      id: 'q-$i',
      phase: (i ~/ 8) + 1,
      orderInPhase: (i % 8) + 1,
      questionText: 'Question $i',
      questionType: 'multiple_choice',
      optionA: 'A$i',
      optionB: 'B$i',
      optionC: 'C$i',
    ),
  );
}

PlacementTestQuestionsDto _fakeQuestionsDto({int count = 40}) =>
    PlacementTestQuestionsDto(
      totalQuestions: count,
      questions: _fakeQuestions(count: count),
    );

PlacementTestResultDto _fakeResult({
  int totalScore = 33,
  int totalMaxScore = 40,
}) =>
    PlacementTestResultDto(
      totalScore: totalScore,
      totalMaxScore: totalMaxScore,
      resultLevel: 'Intermediate',
      phase1Score: 10,
      phase2Score: 7,
      phase3Score: 8,
      phase4Score: 4,
      phase5Score: 4,
      phase1MaxScore: 12,
      phase2MaxScore: 8,
      phase3MaxScore: 12,
      phase4MaxScore: 4,
      phase5MaxScore: 4,
      message: 'Chúc mừng! Bạn đạt trình độ Intermediate.',
      updatedSelfLevel: 'intermediate',
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakePlacementTestSubmitDto());
  });

  group('PlacementTestBloc', () {
    late MockPlacementTestRepository mockRepo;
    late PlacementTestBloc bloc;

    setUp(() {
      mockRepo = MockPlacementTestRepository();
      bloc = PlacementTestBloc(repository: mockRepo);
    });

    tearDown(() => bloc.close());

    // ── Initial ────────────────────────────────────────────────────────────

    test('initial state là PlacementTestInitial', () {
      expect(bloc.state, isA<PlacementTestInitial>());
    });

    // ── Load questions ─────────────────────────────────────────────────────

    test('loadQuestions 40 câu → PlacementTestLoaded với totalQuestions = 40', () async {
      when(() => mockRepo.getQuestions())
          .thenAnswer((_) async => _fakeQuestionsDto(count: 40));

      bloc.add(const PlacementTestLoadQuestionsEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      expect(bloc.state, isA<PlacementTestLoaded>());
      final loaded = bloc.state as PlacementTestLoaded;
      // PHẢI là 40, không hardcode
      expect(loaded.totalQuestions, equals(40));
      expect(loaded.questions, hasLength(40));
    });

    // ── Bug #12: totalMaxScore phải = totalQuestions, không hardcode 25 ───

    test('Bug#12: submit 40 câu → result.totalMaxScore = 40 (không hardcode 25)', () async {
      when(() => mockRepo.getQuestions())
          .thenAnswer((_) async => _fakeQuestionsDto(count: 40));
      when(() => mockRepo.submit(any()))
          .thenAnswer((_) async => _fakeResult(
                totalScore: 33,
              ));

      bloc.add(const PlacementTestLoadQuestionsEvent());
      await Future.delayed(const Duration(milliseconds: 200));

      // Trả lời tất cả 40 câu
      final loaded = bloc.state as PlacementTestLoaded;
      for (final q in loaded.questions) {
        bloc.add(PlacementTestAnswerSelectedEvent(
          questionId: q.id,
          selectedOption: 'A',
        ));
      }
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const PlacementTestSubmitEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      expect(bloc.state, isA<PlacementTestResult>());
      final result = bloc.state as PlacementTestResult;

      // BUG: phải = 40, không phải 25 (hardcoded cũ)
      expect(result.result.totalMaxScore, equals(40));
      expect(result.result.totalScore, equals(33));

      // Điểm không được phi lý (không thể > totalMaxScore)
      expect(result.result.totalScore, lessThanOrEqualTo(result.result.totalMaxScore));
    });

    test('Bug#12: totalScore/totalMaxScore không bao giờ có phân số phi lý như 9/5', () async {
      when(() => mockRepo.getQuestions())
          .thenAnswer((_) async => _fakeQuestionsDto(count: 40));
      when(() => mockRepo.submit(any()))
          .thenAnswer((_) async => _fakeResult(
                totalScore: 33,
                totalMaxScore: 40,
              ));

      bloc.add(const PlacementTestLoadQuestionsEvent());
      await Future.delayed(const Duration(milliseconds: 200));

      final loaded = bloc.state as PlacementTestLoaded;
      for (final q in loaded.questions) {
        bloc.add(PlacementTestAnswerSelectedEvent(
          questionId: q.id,
          selectedOption: 'A',
        ));
      }
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.add(const PlacementTestSubmitEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      final result = (bloc.state as PlacementTestResult).result;

      // Kiểm tra từng phase: score <= maxScore (không phi lý như 9/5)
      expect(result.phase1Score, lessThanOrEqualTo(result.phase1MaxScore));
      expect(result.phase2Score, lessThanOrEqualTo(result.phase2MaxScore));
      expect(result.phase3Score, lessThanOrEqualTo(result.phase3MaxScore));
      expect(result.phase4Score, lessThanOrEqualTo(result.phase4MaxScore));
      expect(result.phase5Score, lessThanOrEqualTo(result.phase5MaxScore));

      // Tổng phase scores phải = totalScore
      final sumPhases = result.phase1Score +
          result.phase2Score +
          result.phase3Score +
          result.phase4Score +
          result.phase5Score;
      expect(sumPhases, equals(result.totalScore));
    });

    // ── Answer navigation ──────────────────────────────────────────────────

    test('answerSelected → tự động chuyển sang câu tiếp theo', () async {
      when(() => mockRepo.getQuestions())
          .thenAnswer((_) async => _fakeQuestionsDto(count: 5));

      bloc.add(const PlacementTestLoadQuestionsEvent());
      await Future.delayed(const Duration(milliseconds: 200));

      var loaded = bloc.state as PlacementTestLoaded;
      expect(loaded.currentIndex, equals(0));

      bloc.add(PlacementTestAnswerSelectedEvent(
        questionId: loaded.questions[0].id,
        selectedOption: 'A',
      ));
      await Future.delayed(const Duration(milliseconds: 100));

      loaded = bloc.state as PlacementTestLoaded;
      expect(loaded.currentIndex, equals(1));
      expect(loaded.answeredCount, equals(1));
    });

    test('prevQuestion → quay lại câu trước', () async {
      when(() => mockRepo.getQuestions())
          .thenAnswer((_) async => _fakeQuestionsDto(count: 5));

      bloc.add(const PlacementTestLoadQuestionsEvent());
      await Future.delayed(const Duration(milliseconds: 200));

      var loaded = bloc.state as PlacementTestLoaded;
      bloc.add(PlacementTestAnswerSelectedEvent(
        questionId: loaded.questions[0].id,
        selectedOption: 'B',
      ));
      await Future.delayed(const Duration(milliseconds: 100));

      bloc.add(const PlacementTestPrevQuestionEvent());
      await Future.delayed(const Duration(milliseconds: 100));

      loaded = bloc.state as PlacementTestLoaded;
      expect(loaded.currentIndex, equals(0));
    });

    test('allAnswered chỉ true khi đủ tất cả câu', () async {
      when(() => mockRepo.getQuestions())
          .thenAnswer((_) async => _fakeQuestionsDto(count: 3));

      bloc.add(const PlacementTestLoadQuestionsEvent());
      await Future.delayed(const Duration(milliseconds: 200));

      var loaded = bloc.state as PlacementTestLoaded;
      expect(loaded.allAnswered, isFalse);

      for (final q in loaded.questions) {
        bloc.add(PlacementTestAnswerSelectedEvent(
          questionId: q.id,
          selectedOption: 'A',
        ));
      }
      await Future.delayed(const Duration(milliseconds: 200));

      loaded = bloc.state as PlacementTestLoaded;
      expect(loaded.allAnswered, isTrue);
    });

    // ── Reset ──────────────────────────────────────────────────────────────

    test('resetEvent → về PlacementTestInitial', () async {
      bloc.add(const PlacementTestResetEvent());
      await Future.delayed(const Duration(milliseconds: 100));
      expect(bloc.state, isA<PlacementTestInitial>());
    });
  });
}
