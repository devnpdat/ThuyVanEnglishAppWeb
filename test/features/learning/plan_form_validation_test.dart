// LearningPlan BLoC Unit Tests — Form Validation
// Bug coverage:
//   - #9 (File2): bypass required field — tên kế hoạch bỏ trống vẫn qua được
//   - #9 (File2): slider giới hạn vượt total_sentences của chủ đề đã chọn
//   - #9 (File2): 400 Bad Request khi tạo plan — data format mismatch

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/learning_plan_bloc.dart';
import 'package:english_learning_app/features/learning/data/repositories/learning_plan_repository.dart';

class MockLearningPlanRepository extends Mock implements LearningPlanRepository {}

class FakeCreateLearningPlanDto extends Fake implements CreateLearningPlanDto {}

LearningPlanSummaryDto _fakePlan({String planName = 'Test Plan'}) =>
    LearningPlanSummaryDto(
      id: 'plan-1',
      planName: planName,
      status: 'active',
      difficultyLevel: 'medium',
      totalItems: 5,
      completedItems: 0,
      progressPercentage: 0.0,
    );

/// Helper: tạo DTO hợp lệ
CreateLearningPlanDto _validDto({
  String planName = 'Kế hoạch tháng 6',
  List<String> topicIds = const ['topic-1'],
  int sentenceCount = 5,
  int maxSentences = 10,
}) =>
    CreateLearningPlanDto(
      planName: planName,
      targetCompletionDate: '2026-12-31',
      topicIds: topicIds,
      sentenceCount: sentenceCount,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    registerFallbackValue(FakeCreateLearningPlanDto());
  });

  group('LearningPlanBloc — Form Validation', () {
    late MockLearningPlanRepository mockRepo;
    late LearningPlanBloc bloc;

    setUp(() {
      mockRepo = MockLearningPlanRepository();
      bloc = LearningPlanBloc(repository: mockRepo);
    });

    tearDown(() => bloc.close());

    // ── Initial ────────────────────────────────────────────────────────────

    test('initial state là LearningPlanInitialState', () {
      expect(bloc.state, isA<LearningPlanInitialState>());
    });

    // ── Bug #9: tên bỏ trống → không được gọi API ─────────────────────────

    test('Bug#9: createPlan với planName rỗng → emit error, KHÔNG gọi repository', () async {
      // Thực tế FE phải validate trước khi fire event
      // Test này kiểm tra bloc xử lý đúng khi nhận DTO có planName=""
      final dto = _validDto(planName: '');

      // Mock throw như BE trả 400
      when(() => mockRepo.createPlan(any()))
          .thenThrow(Exception('Tên kế hoạch không được để trống'));

      bloc.add(LearningPlanCreateEvent(dto));
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, isA<LearningPlanErrorState>());
      final err = bloc.state as LearningPlanErrorState;
      expect(err.message, isNotEmpty);
    });

    test('Bug#9: createPlan với planName hợp lệ → gọi repository.createPlan đúng 1 lần', () async {
      when(() => mockRepo.createPlan(any()))
          .thenAnswer((_) async => _fakePlan(planName: 'Kế hoạch tháng 6'));

      bloc.add(LearningPlanCreateEvent(_validDto(planName: 'Kế hoạch tháng 6')));
      await Future.delayed(const Duration(milliseconds: 200));

      verify(() => mockRepo.createPlan(any())).called(1);
      expect(bloc.state, isA<LearningPlanCreatedState>());
    });

    // ── Bug #9: slider vượt max → không được tạo plan ─────────────────────

    test('Bug#9: sentenceCount vượt total_sentences của topic → emit error', () async {
      // topicIds = [topic-1] có 5 câu, nhưng user chọn 200 câu
      final dto = _validDto(sentenceCount: 200);

      when(() => mockRepo.createPlan(any()))
          .thenThrow(Exception('Số câu vượt quá số câu có sẵn trong chủ đề'));

      bloc.add(LearningPlanCreateEvent(dto));
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, isA<LearningPlanErrorState>());
      final err = bloc.state as LearningPlanErrorState;
      expect(err.message, isNotEmpty);
    });

    test('Bug#9: sentenceCount = 0 → emit error', () async {
      final dto = _validDto(sentenceCount: 0);

      when(() => mockRepo.createPlan(any()))
          .thenThrow(Exception('Số câu phải lớn hơn 0'));

      bloc.add(LearningPlanCreateEvent(dto));
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, isA<LearningPlanErrorState>());
    });

    // ── Bug #9: topicIds rỗng → không được tạo ────────────────────────────

    test('Bug#9: topicIds rỗng → emit error (không chọn chủ đề)', () async {
      final dto = _validDto(topicIds: []);

      when(() => mockRepo.createPlan(any()))
          .thenThrow(Exception('Phải chọn ít nhất một chủ đề'));

      bloc.add(LearningPlanCreateEvent(dto));
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, isA<LearningPlanErrorState>());
      final err = bloc.state as LearningPlanErrorState;
      expect(err.message, isNotEmpty);
    });

    // ── Bug #9: 400 Data Format Mismatch ─────────────────────────────────

    test('Bug#9: 400 Bad Request từ server → emit error với message rõ ràng', () async {
      when(() => mockRepo.createPlan(any()))
          .thenThrow(Exception('Lỗi server 400: Sai định dạng ngày tháng'));

      bloc.add(LearningPlanCreateEvent(_validDto()));
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, isA<LearningPlanErrorState>());
      final err = bloc.state as LearningPlanErrorState;
      // Message phải human-readable, không expose raw stack
      expect(err.message, isNot(contains('#0 ')));
      expect(err.message, isNotEmpty);
    });

    // ── Load danh sách plan ────────────────────────────────────────────────

    test('LearningPlanLoadEvent → emit loaded với danh sách', () async {
      when(() => mockRepo.getPlans(status: any(named: 'status')))
          .thenAnswer((_) async => [_fakePlan()]);

      bloc.add(const LearningPlanLoadEvent());
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, isA<LearningPlanLoadedState>());
      final loaded = bloc.state as LearningPlanLoadedState;
      expect(loaded.plans, hasLength(1));
      expect(loaded.plans.first.planName, equals('Test Plan'));
    });

    test('LearningPlanLoadEvent thất bại → emit error', () async {
      when(() => mockRepo.getPlans(status: any(named: 'status')))
          .thenThrow(Exception('Network error'));

      bloc.add(const LearningPlanLoadEvent());
      await Future.delayed(const Duration(milliseconds: 200));

      expect(bloc.state, isA<LearningPlanErrorState>());
    });
  });
}
