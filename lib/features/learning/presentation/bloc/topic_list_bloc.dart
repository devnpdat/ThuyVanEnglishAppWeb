import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:english_learning_app/core/di/service_locator.dart';
import 'package:english_learning_app/features/learning/data/dtos/topic_dto.dart';
import 'package:english_learning_app/features/learning/data/repositories/topic_repository.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class TopicListEvent extends Equatable {
  const TopicListEvent();

  @override
  List<Object?> get props => [];
}

class TopicListInitialEvent extends TopicListEvent {
  final String? searchText;
  const TopicListInitialEvent({this.searchText});

  @override
  List<Object?> get props => [searchText];
}

class TopicListLoadMoreEvent extends TopicListEvent {
  const TopicListLoadMoreEvent();
}

class TopicListRefreshEvent extends TopicListEvent {
  const TopicListRefreshEvent();
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class TopicListState extends Equatable {
  const TopicListState();

  @override
  List<Object?> get props => [];
}

class TopicListInitial extends TopicListState {
  const TopicListInitial();
}

class TopicListLoading extends TopicListState {
  const TopicListLoading();
}

class TopicListLoaded extends TopicListState {
  final List<TopicDto> topics;
  final bool hasMoreToLoad;
  final int currentPage;
  final int totalCount;

  const TopicListLoaded({
    required this.topics,
    required this.hasMoreToLoad,
    required this.currentPage,
    this.totalCount = 0,
  });

  @override
  List<Object?> get props => [topics, hasMoreToLoad, currentPage, totalCount];
}

class TopicListError extends TopicListState {
  final String message;

  const TopicListError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class TopicListBloc extends Bloc<TopicListEvent, TopicListState> {
  final TopicRepository _topicRepository;

  static const int _pageSize = 20;
  int _pageIndex = 0;
  List<TopicDto> _allTopics = [];
  String? _currentSearch;

  TopicListBloc({TopicRepository? topicRepository})
      : _topicRepository = topicRepository ?? getIt<TopicRepository>(),
        super(const TopicListInitial()) {
    on<TopicListInitialEvent>(_onInitial);
    on<TopicListLoadMoreEvent>(_onLoadMore);
    on<TopicListRefreshEvent>(_onRefresh);
  }

  Future<void> _onInitial(
    TopicListInitialEvent event,
    Emitter<TopicListState> emit,
  ) async {
    emit(const TopicListLoading());
    try {
      _pageIndex = 0;
      _allTopics = [];
      _currentSearch = event.searchText;

      final result = await _topicRepository.getTopics(
        pageIndex: _pageIndex,
        pageSize: _pageSize,
        // _currentSearch could be sent to getTopics if repository supported it
      );

      _allTopics = result.items;

      emit(TopicListLoaded(
        topics: List.from(_allTopics),
        hasMoreToLoad: _allTopics.length < result.totalCount,
        currentPage: 0,
        totalCount: result.totalCount,
      ));
    } catch (e) {
      emit(TopicListError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadMore(
    TopicListLoadMoreEvent event,
    Emitter<TopicListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TopicListLoaded || !currentState.hasMoreToLoad) {
      return;
    }

    try {
      _pageIndex++;
      final result = await _topicRepository.getTopics(
        pageIndex: _pageIndex,
        pageSize: _pageSize,
      );

      _allTopics.addAll(result.items);

      emit(TopicListLoaded(
        topics: List.from(_allTopics),
        hasMoreToLoad: _allTopics.length < result.totalCount,
        currentPage: _pageIndex,
        totalCount: result.totalCount,
      ));
    } catch (e) {
      _pageIndex--; // Revert page index on failure
      emit(TopicListError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRefresh(
    TopicListRefreshEvent event,
    Emitter<TopicListState> emit,
  ) async {
    await _onInitial(
      TopicListInitialEvent(searchText: _currentSearch),
      emit,
    );
  }
}
