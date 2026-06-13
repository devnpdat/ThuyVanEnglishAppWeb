import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/di/service_locator.dart';
import 'package:english_learning_app/features/learning/data/dtos/sentence_dto.dart';
import 'package:english_learning_app/features/learning/data/repositories/sentence_repository.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class SentenceListEvent extends Equatable {
  const SentenceListEvent();

  @override
  List<Object?> get props => [];
}

class SentenceListInitialEvent extends SentenceListEvent {
  final String? topicId;
  final String? difficultyLevel;
  final String? searchText;

  const SentenceListInitialEvent({
    this.topicId,
    this.difficultyLevel,
    this.searchText,
  });

  @override
  List<Object?> get props => [topicId, difficultyLevel, searchText];
}

class SentenceListLoadMoreEvent extends SentenceListEvent {
  const SentenceListLoadMoreEvent();
}

class SentenceListRefreshEvent extends SentenceListEvent {
  const SentenceListRefreshEvent();
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class SentenceListState extends Equatable {
  const SentenceListState();

  @override
  List<Object?> get props => [];
}

class SentenceListInitial extends SentenceListState {
  const SentenceListInitial();
}

class SentenceListLoading extends SentenceListState {
  const SentenceListLoading();
}

class SentenceListLoaded extends SentenceListState {
  final List<SentenceDto> sentences;
  final bool hasMoreToLoad;
  final int currentPage;
  final int totalCount;

  const SentenceListLoaded({
    required this.sentences,
    required this.hasMoreToLoad,
    required this.currentPage,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [sentences, hasMoreToLoad, currentPage, totalCount];
}

class SentenceListError extends SentenceListState {
  final String message;

  const SentenceListError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class SentenceListBloc extends Bloc<SentenceListEvent, SentenceListState> {
  final SentenceRepository _sentenceRepository;

  static const int _pageSize = 20;
  int _skipCount = 0;
  List<SentenceDto> _allSentences = [];
  String? _currentTopicId;
  String? _currentDifficulty;
  String? _currentSearch;

  SentenceListBloc({SentenceRepository? sentenceRepository})
      : _sentenceRepository =
            sentenceRepository ?? getIt<SentenceRepository>(),
        super(const SentenceListInitial()) {
    on<SentenceListInitialEvent>(_onInitial);
    on<SentenceListLoadMoreEvent>(_onLoadMore);
    on<SentenceListRefreshEvent>(_onRefresh);
  }

  Future<void> _onInitial(
    SentenceListInitialEvent event,
    Emitter<SentenceListState> emit,
  ) async {
    emit(const SentenceListLoading());
    try {
      _skipCount = 0;
      _allSentences = [];
      _currentTopicId = event.topicId;
      _currentDifficulty = event.difficultyLevel;
      _currentSearch = event.searchText;

      final result = await _sentenceRepository.getSentences(
        topicId: _currentTopicId,
        difficultyLevel: _currentDifficulty,
        searchText: _currentSearch,
        skipCount: 0,
        maxResultCount: _pageSize,
      );

      _allSentences = result.items;
      _skipCount = _allSentences.length;

      emit(SentenceListLoaded(
        sentences: List.from(_allSentences),
        hasMoreToLoad: _allSentences.length < result.totalCount,
        currentPage: 0,
        totalCount: result.totalCount,
      ));
    } catch (e) {
      emit(SentenceListError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadMore(
    SentenceListLoadMoreEvent event,
    Emitter<SentenceListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! SentenceListLoaded || !currentState.hasMoreToLoad) {
      return;
    }

    try {
      final result = await _sentenceRepository.getSentences(
        topicId: _currentTopicId,
        difficultyLevel: _currentDifficulty,
        searchText: _currentSearch,
        skipCount: _skipCount,
        maxResultCount: _pageSize,
      );

      _allSentences.addAll(result.items);
      _skipCount = _allSentences.length;

      emit(SentenceListLoaded(
        sentences: List.from(_allSentences),
        hasMoreToLoad: _allSentences.length < result.totalCount,
        currentPage: currentState.currentPage + 1,
        totalCount: result.totalCount,
      ));
    } catch (e) {
      // Load more failure — keep current state, just show snackbar
      emit(SentenceListError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRefresh(
    SentenceListRefreshEvent event,
    Emitter<SentenceListState> emit,
  ) async {
    await _onInitial(
      SentenceListInitialEvent(
        topicId: _currentTopicId,
        difficultyLevel: _currentDifficulty,
        searchText: _currentSearch,
      ),
      emit,
    );
  }
}
