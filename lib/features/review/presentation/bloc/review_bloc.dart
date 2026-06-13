import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/di/service_locator.dart';
import 'package:english_learning_app/features/review/data/repositories/review_repository.dart';
import 'package:english_learning_app/features/review/data/dtos/review_dto.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class ReviewEvent extends Equatable {
  const ReviewEvent();

  @override
  List<Object?> get props => [];
}

class ReviewLoadTodayEvent extends ReviewEvent {
  const ReviewLoadTodayEvent();
}

class ReviewSubmitEvent extends ReviewEvent {
  final String sentenceId;
  final int quality; // 0=blackout → 5=perfect (SM-2 scale)

  const ReviewSubmitEvent({
    required this.sentenceId,
    required this.quality,
  });

  @override
  List<Object?> get props => [sentenceId, quality];
}

class ReviewSkipEvent extends ReviewEvent {
  const ReviewSkipEvent();
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {
  const ReviewInitial();
}

class ReviewLoading extends ReviewState {
  const ReviewLoading();
}

class ReviewLoaded extends ReviewState {
  final List<ReviewItemDto> reviewItems;
  final int currentIndex;
  final int totalDue;
  final int reviewedToday;

  const ReviewLoaded({
    required this.reviewItems,
    required this.currentIndex,
    required this.totalDue,
    required this.reviewedToday,
  });

  ReviewItemDto? get currentItem =>
      currentIndex < reviewItems.length ? reviewItems[currentIndex] : null;

  @override
  List<Object?> get props =>
      [reviewItems, currentIndex, totalDue, reviewedToday];
}

class ReviewSubmitting extends ReviewState {
  const ReviewSubmitting();
}

class ReviewCompleted extends ReviewState {
  final int totalReviewed;
  final int pointsEarned;

  const ReviewCompleted({
    required this.totalReviewed,
    required this.pointsEarned,
  });

  @override
  List<Object?> get props => [totalReviewed, pointsEarned];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository _reviewRepository;

  int _currentIndex = 0;
  int _pointsEarned = 0;
  List<ReviewItemDto> _reviewItems = [];
  int _reviewedToday = 0;
  final Stopwatch _stopwatch = Stopwatch();

  ReviewBloc({ReviewRepository? reviewRepository})
      : _reviewRepository = reviewRepository ?? getIt<ReviewRepository>(),
        super(const ReviewInitial()) {
    on<ReviewLoadTodayEvent>(_onLoadToday);
    on<ReviewSubmitEvent>(_onSubmit);
    on<ReviewSkipEvent>(_onSkip);
  }

  Future<void> _onLoadToday(
    ReviewLoadTodayEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(const ReviewLoading());
    try {
      final response = await _reviewRepository.getTodayReviews();
      _reviewItems = response.items;
      _currentIndex = 0;
      _pointsEarned = 0;
      _reviewedToday = response.reviewedToday;

      if (_reviewItems.isEmpty) {
        emit(const ReviewCompleted(totalReviewed: 0, pointsEarned: 0));
      } else {
        _stopwatch.reset();
        _stopwatch.start();
        emit(ReviewLoaded(
          reviewItems: _reviewItems,
          currentIndex: 0,
          totalDue: response.totalDue,
          reviewedToday: _reviewedToday,
        ));
      }
    } catch (e) {
      emit(ReviewError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onSubmit(
    ReviewSubmitEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewLoaded) return;
    final currentState = state as ReviewLoaded;

    emit(const ReviewSubmitting());
    try {
      _stopwatch.stop();
      final timeSpent = _stopwatch.elapsed.inSeconds.clamp(1, 300);

      final result = await _reviewRepository.submitReview(
        SubmitReviewRequest(
          sentenceId: event.sentenceId,
          quality: event.quality,
          timeSpentSeconds: timeSpent,
        ),
      );

      _pointsEarned += result.pointsEarned;
      _currentIndex++;
      _reviewedToday++;

      if (_currentIndex >= _reviewItems.length) {
        emit(ReviewCompleted(
          totalReviewed: _reviewItems.length,
          pointsEarned: _pointsEarned,
        ));
      } else {
        _stopwatch.reset();
        _stopwatch.start();
        emit(ReviewLoaded(
          reviewItems: _reviewItems,
          currentIndex: _currentIndex,
          totalDue: currentState.totalDue,
          reviewedToday: _reviewedToday,
        ));
      }
    } catch (e) {
      // Submit lỗi — vẫn cho phép next để không block user
      _currentIndex++;
      if (_currentIndex >= _reviewItems.length) {
        emit(ReviewCompleted(
          totalReviewed: _currentIndex,
          pointsEarned: _pointsEarned,
        ));
      } else {
        _stopwatch.reset();
        _stopwatch.start();
        emit(ReviewLoaded(
          reviewItems: _reviewItems,
          currentIndex: _currentIndex,
          totalDue: currentState.totalDue,
          reviewedToday: _reviewedToday,
        ));
      }
    }
  }

  Future<void> _onSkip(
    ReviewSkipEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (state is! ReviewLoaded) return;
    final currentState = state as ReviewLoaded;

    _currentIndex++;
    _stopwatch.reset();
    _stopwatch.start();

    if (_currentIndex >= _reviewItems.length) {
      emit(ReviewCompleted(
        totalReviewed: _currentIndex,
        pointsEarned: _pointsEarned,
      ));
    } else {
      emit(ReviewLoaded(
        reviewItems: _reviewItems,
        currentIndex: _currentIndex,
        totalDue: currentState.totalDue,
        reviewedToday: currentState.reviewedToday,
      ));
    }
  }
}
