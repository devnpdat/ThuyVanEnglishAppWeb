// Dashboard BLoC Unit Tests
// Bug coverage:
//   - #10 (File3): streak/points/mastered = 0, không auto-refetch khi quay về Dashboard
//   - #12 (File3): Today's Progress không cập nhật sau khi học xong câu

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/home/presentation/bloc/dashboard_bloc.dart';
import 'package:english_learning_app/features/home/data/repositories/dashboard_repository.dart';
import 'package:english_learning_app/features/home/data/dtos/dashboard_dto.dart';

class MockDashboardRepository extends Mock implements DashboardRepository {}

DashboardDto _fakeDashboard({
  int streakDays = 5,
  int totalPoints = 120,
  int totalSentencesMastered = 10,
  int todayCompleted = 3,
  int todayTarget = 5,
}) =>
    DashboardDto(
      streakDays: streakDays,
      totalPoints: totalPoints,
      totalSentencesMastered: totalSentencesMastered,
      todayCompleted: todayCompleted,
      todayTarget: todayTarget,
      totalSentencesLearned: 20,
      reviewDueToday: 2,
      rank: 1,
      overallAccuracy: 0.85,
      hasTakenPlacementTest: true,
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashboardBloc', () {
    late MockDashboardRepository mockRepo;
    late DashboardBloc bloc;

    setUp(() {
      mockRepo = MockDashboardRepository();
      bloc = DashboardBloc(repository: mockRepo);
    });

    tearDown(() => bloc.close());

    // ── Initial ────────────────────────────────────────────────────────────

    test('initial state là DashboardState.initial()', () {
      expect(bloc.state, equals(const DashboardState.initial()));
    });

    // ── Load thành công ────────────────────────────────────────────────────

    test('load thành công → emit loading rồi loaded với data thực', () async {
      when(() => mockRepo.getDashboardStats())
          .thenAnswer((_) async => _fakeDashboard());

      final states = <DashboardState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const DashboardEvent.load());
      await Future.delayed(const Duration(milliseconds: 300));
      await sub.cancel();

      expect(states.first, equals(const DashboardState.loading()));
      expect(states.last.runtimeType.toString(), contains('Loaded'));
      states.last.maybeWhen(
        loaded: (dashboard) {
          expect(dashboard.streakDays, equals(5));
          expect(dashboard.totalPoints, equals(120));
          expect(dashboard.totalSentencesMastered, equals(10));
          expect(dashboard.todayCompleted, equals(3));
          expect(dashboard.todayTarget, equals(5));
        },
        orElse: () => fail('Expected loaded state'),
      );
    });

    // ── Bug #10: streak/points/mastered phải phản ánh data thực ──────────

    test('Bug#10: load sau khi học xong → streak/points/mastered > 0', () async {
      // Simulate: user đã học xong, data từ BE trả về giá trị thực
      when(() => mockRepo.getDashboardStats())
          .thenAnswer((_) async => _fakeDashboard(
                streakDays: 3,
                totalPoints: 50,
                totalSentencesMastered: 4,
              ));

      bloc.add(const DashboardEvent.load());
      await Future.delayed(const Duration(milliseconds: 300));

      bloc.state.maybeWhen(
        loaded: (dashboard) {
          // Phải có giá trị > 0, không bị cache = 0
          expect(dashboard.streakDays, greaterThan(0));
          expect(dashboard.totalPoints, greaterThan(0));
          expect(dashboard.totalSentencesMastered, greaterThan(0));
        },
        orElse: () => fail('Expected loaded state, got: ${bloc.state}'),
      );
    });

    // ── Bug #12: Today's Progress phải cập nhật sau load ──────────────────

    test('Bug#12: load lần 2 → Today Progress cập nhật ngay, không giữ stale data', () async {
      // Lần đầu: 0 câu xong
      when(() => mockRepo.getDashboardStats())
          .thenAnswer((_) async => _fakeDashboard(todayCompleted: 0, todayTarget: 5));

      bloc.add(const DashboardEvent.load());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        loaded: (d) => expect(d.todayCompleted, equals(0)),
        orElse: () => fail('Expected loaded'),
      );

      // User học xong 1 câu, load lại Dashboard
      when(() => mockRepo.getDashboardStats())
          .thenAnswer((_) async => _fakeDashboard(todayCompleted: 1, todayTarget: 5));

      bloc.add(const DashboardEvent.load());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        loaded: (d) {
          // PHẢI là 1, không được vẫn là 0 (stale)
          expect(d.todayCompleted, equals(1));
        },
        orElse: () => fail('Expected loaded, got: ${bloc.state}'),
      );
    });

    test('Bug#12: load 2 lần → repository.getDashboardStats gọi đúng 2 lần (refetch)', () async {
      when(() => mockRepo.getDashboardStats())
          .thenAnswer((_) async => _fakeDashboard());

      bloc.add(const DashboardEvent.load());
      await Future.delayed(const Duration(milliseconds: 200));
      bloc.add(const DashboardEvent.load());
      await Future.delayed(const Duration(milliseconds: 200));

      // Mỗi lần navigate về Dashboard phải gọi lại API
      verify(() => mockRepo.getDashboardStats()).called(2);
    });

    // ── Load thất bại ──────────────────────────────────────────────────────

    test('load thất bại → emit error với message', () async {
      when(() => mockRepo.getDashboardStats())
          .thenThrow(Exception('Network error'));

      bloc.add(const DashboardEvent.load());
      await Future.delayed(const Duration(milliseconds: 300));

      bloc.state.maybeWhen(
        error: (msg) => expect(msg, isNotEmpty),
        orElse: () => fail('Expected error state, got: ${bloc.state}'),
      );
    });

    test('load error → message không expose raw exception stack', () async {
      when(() => mockRepo.getDashboardStats())
          .thenThrow(Exception('Server error 500'));

      bloc.add(const DashboardEvent.load());
      await Future.delayed(const Duration(milliseconds: 200));

      bloc.state.maybeWhen(
        error: (msg) {
          expect(msg, isNotEmpty);
          // Không show stack trace cho user
          expect(msg, isNot(contains('#0')));
        },
        orElse: () => fail('Expected error'),
      );
    });
  });
}
