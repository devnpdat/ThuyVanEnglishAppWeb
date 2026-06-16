import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/rewards/data/repositories/rewards_repository.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class RewardsEvent extends Equatable {
  const RewardsEvent();

  @override
  List<Object?> get props => [];
}

class RewardsLoadEvent extends RewardsEvent {
  const RewardsLoadEvent();
}

class RewardsLoadHistoryEvent extends RewardsEvent {
  final int pageNumber;

  const RewardsLoadHistoryEvent({required this.pageNumber});

  @override
  List<Object?> get props => [pageNumber];
}

class LeaderboardLoadEvent extends RewardsEvent {
  const LeaderboardLoadEvent();
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class RewardsState extends Equatable {
  const RewardsState();

  @override
  List<Object?> get props => [];
}

class RewardsInitial extends RewardsState {
  const RewardsInitial();
}

class RewardsLoading extends RewardsState {
  const RewardsLoading();
}

class RewardsLoaded extends RewardsState {
  final int totalPoints;
  final int quizCorrectCount;
  final int streakDaysCount;
  final int plansCompletedCount;
  final String currentLevel;
  final int pointsToNextLevel;
  final int nextLevelThreshold;
  final int currentLevelThreshold;
  final List<RewardHistoryDto> rewardHistory;

  const RewardsLoaded({
    required this.totalPoints,
    required this.quizCorrectCount,
    required this.streakDaysCount,
    required this.plansCompletedCount,
    this.currentLevel = 'Bronze',
    this.pointsToNextLevel = 0,
    this.nextLevelThreshold = 1000,
    this.currentLevelThreshold = 0,
    this.rewardHistory = const [],
  });

  double get levelProgress {
    final range = nextLevelThreshold - currentLevelThreshold;
    if (range <= 0) return 1.0;
    final current = totalPoints - currentLevelThreshold;
    return (current / range).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
        totalPoints,
        quizCorrectCount,
        streakDaysCount,
        plansCompletedCount,
        currentLevel,
        rewardHistory,
      ];
}

class LeaderboardLoaded extends RewardsState {
  final List<LeaderboardEntryDto> leaderboard;
  final int currentUserRank;

  const LeaderboardLoaded({
    required this.leaderboard,
    required this.currentUserRank,
  });

  @override
  List<Object?> get props => [leaderboard, currentUserRank];
}

class RewardsError extends RewardsState {
  final String message;

  const RewardsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class RewardsBloc extends Bloc<RewardsEvent, RewardsState> {
  final RewardsRepository _rewardsRepository;

  RewardsBloc({RewardsRepository? rewardsRepository})
      : _rewardsRepository = rewardsRepository ?? GetIt.instance<RewardsRepository>(),
        super(const RewardsInitial()) {
    on<RewardsLoadEvent>(_onLoad);
    on<RewardsLoadHistoryEvent>(_onLoadHistory);
    on<LeaderboardLoadEvent>(_onLeaderboardLoad);
  }

  Future<void> _onLoad(
    RewardsLoadEvent event,
    Emitter<RewardsState> emit,
  ) async {
    emit(const RewardsLoading());
    try {
      // Load summary và history song song
      final results = await Future.wait([
        _rewardsRepository.getSummary(),
        _rewardsRepository.getHistory(maxResultCount: 10),
      ]);

      final summary = results[0] as RewardsSummaryDto;
      final history = results[1] as List<RewardHistoryDto>;

      emit(RewardsLoaded(
        totalPoints: summary.totalPoints,
        quizCorrectCount: summary.quizCorrectCount,
        streakDaysCount: summary.streakDaysCount,
        plansCompletedCount: summary.plansCompletedCount,
        currentLevel: summary.currentLevel,
        pointsToNextLevel: summary.pointsToNextLevel,
        nextLevelThreshold: summary.nextLevelThreshold,
        currentLevelThreshold: summary.currentLevelThreshold,
        rewardHistory: history,
      ));
    } catch (e) {
      emit(RewardsError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadHistory(
    RewardsLoadHistoryEvent event,
    Emitter<RewardsState> emit,
  ) async {
    try {
      final history = await _rewardsRepository.getHistory(
        skipCount: event.pageNumber * 20,
        maxResultCount: 20,
      );

      if (state is RewardsLoaded) {
        final current = state as RewardsLoaded;
        emit(RewardsLoaded(
          totalPoints: current.totalPoints,
          quizCorrectCount: current.quizCorrectCount,
          streakDaysCount: current.streakDaysCount,
          plansCompletedCount: current.plansCompletedCount,
          currentLevel: current.currentLevel,
          pointsToNextLevel: current.pointsToNextLevel,
          nextLevelThreshold: current.nextLevelThreshold,
          currentLevelThreshold: current.currentLevelThreshold,
          rewardHistory: [...current.rewardHistory, ...history],
        ));
      }
    } catch (_) {
      // History load failure — không block main state
    }
  }

  Future<void> _onLeaderboardLoad(
    LeaderboardLoadEvent event,
    Emitter<RewardsState> emit,
  ) async {
    // KHÔNG emit RewardsLoading() ở đây — sẽ xóa mất RewardsLoaded state
    // Screen tự xử lý placeholder khi _leaderboardData == null
    try {
      final leaderboard = await _rewardsRepository.getLeaderboard(limit: 10);
      emit(LeaderboardLoaded(
        leaderboard: leaderboard,
        currentUserRank: 0, // TODO: get actual user rank
      ));
    } catch (e) {
      emit(RewardsError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
