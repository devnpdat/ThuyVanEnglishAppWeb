// Rewards BLoC Unit Tests
// Bug coverage:
//   - #6 (File2): Leaderboard API trả về rỗng (data=[]) → state LeaderboardLoaded với list rỗng
//   - #6 (File2): History API trả về 400 Bad Request → xử lý graceful (không crash)
//   - Kiểm tra RewardsLoaded chứa data đúng sau load

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_learning_app/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:english_learning_app/features/rewards/data/repositories/rewards_repository.dart';

class MockRewardsRepository extends Mock implements RewardsRepository {}

RewardsSummaryDto _fakeSummary({int totalPoints = 10}) => RewardsSummaryDto(
      totalPoints: totalPoints,
      quizCorrectCount: 1,
      streakDaysCount: 1,
      plansCompletedCount: 1,
      currentLevel: 'Bronze',
      pointsToNextLevel: 990,
      currentLevelThreshold: 0,
      nextLevelThreshold: 1000,
    );

RewardHistoryDto _fakeHistory() => RewardHistoryDto(
      id: 'rh-1',
      points: 10,
      activityType: 'quiz_correct',
      description: 'Hoàn thành câu học',
      createdAt: DateTime(2026, 6, 1),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RewardsBloc', () {
    late MockRewardsRepository mockRepo;
    late RewardsBloc bloc;

    setUp(() {
      mockRepo = MockRewardsRepository();
      bloc = RewardsBloc(rewardsRepository: mockRepo);
    });

    tearDown(() => bloc.close());

    // ── Initial ────────────────────────────────────────────────────────────

    test('initial state là RewardsInitial', () {
      expect(bloc.state, isA<RewardsInitial>());
    });

    // ── Load thành công ────────────────────────────────────────────────────

    test('RewardsLoadEvent → emit RewardsLoaded với totalPoints đúng', () async {
      when(() => mockRepo.getSummary())
          .thenAnswer((_) async => _fakeSummary(totalPoints: 50));
      when(() => mockRepo.getHistory(maxResultCount: 10))
          .thenAnswer((_) async => [_fakeHistory()]);

      bloc.add(const RewardsLoadEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      expect(bloc.state, isA<RewardsLoaded>());
      final loaded = bloc.state as RewardsLoaded;
      expect(loaded.totalPoints, equals(50));
      expect(loaded.rewardHistory, hasLength(1));
      expect(loaded.rewardHistory.first.activityType, equals('quiz_correct'));
    });

    // ── Bug #6: Leaderboard API trả về rỗng ───────────────────────────────

    test('Bug#6: LeaderboardLoadEvent → API trả về [] → LeaderboardLoaded với list rỗng (không crash)', () async {
      // Simulate: server 200 OK nhưng data = [] (bug hiện tại trên prod)
      when(() => mockRepo.getLeaderboard(limit: 10))
          .thenAnswer((_) async => []);

      bloc.add(const LeaderboardLoadEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      // App KHÔNG crash, emit LeaderboardLoaded với list rỗng
      expect(bloc.state, isA<LeaderboardLoaded>());
      final state = bloc.state as LeaderboardLoaded;
      expect(state.leaderboard, isEmpty);
    });

    test('Bug#6: LeaderboardLoaded với data thực → list có đúng số entry', () async {
      final entries = [
        LeaderboardEntryDto(
          rank: 1,
          userId: 'u1',
          userName: 'devdatnp',
          totalPoints: 200,
          currentStreak: 5,
          isCurrentUser: true,
        ),
        LeaderboardEntryDto(
          rank: 2,
          userId: 'u2',
          userName: 'user2',
          totalPoints: 100,
          currentStreak: 2,
        ),
      ];

      when(() => mockRepo.getLeaderboard(limit: 10))
          .thenAnswer((_) async => entries);

      bloc.add(const LeaderboardLoadEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      expect(bloc.state, isA<LeaderboardLoaded>());
      final state = bloc.state as LeaderboardLoaded;
      expect(state.leaderboard, hasLength(2));
      expect(state.leaderboard.first.rank, equals(1));
      expect(state.leaderboard.first.totalPoints, equals(200));
    });

    test('Bug#6: Leaderboard API throw 400 → emit RewardsError, không crash', () async {
      when(() => mockRepo.getLeaderboard(limit: 10))
          .thenThrow(Exception('Lỗi server: 400'));

      bloc.add(const LeaderboardLoadEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      expect(bloc.state, isA<RewardsError>());
      final err = bloc.state as RewardsError;
      expect(err.message, isNotEmpty);
    });

    // ── Bug #6: History API 400 Bad Request ───────────────────────────────

    test('Bug#6: RewardsLoadEvent khi history API 400 → emit RewardsError', () async {
      when(() => mockRepo.getSummary())
          .thenAnswer((_) async => _fakeSummary());
      // History trả 400 → throw
      when(() => mockRepo.getHistory(maxResultCount: 10))
          .thenThrow(Exception('Lỗi server: 400'));

      bloc.add(const RewardsLoadEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      // Bloc phải catch lỗi và emit error state, không crash app
      expect(bloc.state, isA<RewardsError>());
    });

    test('Bug#6: RewardsLoadHistoryEvent khi đang ở RewardsLoaded + history lỗi → giữ nguyên RewardsLoaded', () async {
      // Setup: đang ở Loaded state
      when(() => mockRepo.getSummary())
          .thenAnswer((_) async => _fakeSummary());
      when(() => mockRepo.getHistory(maxResultCount: any(named: 'maxResultCount')))
          .thenAnswer((_) async => []);

      bloc.add(const RewardsLoadEvent());
      await Future.delayed(const Duration(milliseconds: 200));
      expect(bloc.state, isA<RewardsLoaded>());

      // Load history page 2 lỗi → bloc giữ nguyên state loaded (graceful fail)
      when(() => mockRepo.getHistory(
            skipCount: any(named: 'skipCount'),
            maxResultCount: any(named: 'maxResultCount'),
          )).thenThrow(Exception('Network error'));

      bloc.add(const RewardsLoadHistoryEvent(pageNumber: 1));
      await Future.delayed(const Duration(milliseconds: 200));

      // State vẫn là RewardsLoaded, không bị crash về RewardsError
      expect(bloc.state, isA<RewardsLoaded>());
    });

    // ── LevelProgress computation ──────────────────────────────────────────

    test('RewardsLoaded.levelProgress tính đúng (Bronze: 0→1000)', () async {
      when(() => mockRepo.getSummary())
          .thenAnswer((_) async => _fakeSummary(totalPoints: 500));
      when(() => mockRepo.getHistory(maxResultCount: 10))
          .thenAnswer((_) async => []);

      bloc.add(const RewardsLoadEvent());
      await Future.delayed(const Duration(milliseconds: 300));

      final loaded = bloc.state as RewardsLoaded;
      // 500/1000 = 0.5
      expect(loaded.levelProgress, closeTo(0.5, 0.01));
    });
  });
}
