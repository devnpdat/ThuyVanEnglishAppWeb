import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/learning/data/repositories/learning_plan_repository.dart';

// ─── Events ───────────────────────────────────────────────────────────────────

abstract class LearningPlanEvent {
  const LearningPlanEvent();
}

class LearningPlanLoadEvent extends LearningPlanEvent {
  final String? statusFilter;
  const LearningPlanLoadEvent({this.statusFilter});
}

class LearningPlanCreateEvent extends LearningPlanEvent {
  final CreateLearningPlanDto dto;
  const LearningPlanCreateEvent(this.dto);
}

class LearningPlanActivateEvent extends LearningPlanEvent {
  final String planId;
  const LearningPlanActivateEvent(this.planId);
}

class LearningPlanLoadItemsEvent extends LearningPlanEvent {
  final String planId;
  const LearningPlanLoadItemsEvent(this.planId);
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class LearningPlanState {
  const LearningPlanState();
}

class LearningPlanInitialState extends LearningPlanState {
  const LearningPlanInitialState();
}

class LearningPlanLoadingState extends LearningPlanState {
  const LearningPlanLoadingState();
}

class LearningPlanCreatingState extends LearningPlanState {
  const LearningPlanCreatingState();
}

class LearningPlanActivatingState extends LearningPlanState {
  const LearningPlanActivatingState();
}

class LearningPlanLoadedState extends LearningPlanState {
  final List<LearningPlanSummaryDto> plans;
  const LearningPlanLoadedState(this.plans);
}

class LearningPlanItemsLoadedState extends LearningPlanState {
  final String planId;
  final List<LearningPlanItemDto> items;
  const LearningPlanItemsLoadedState(this.planId, this.items);
}

class LearningPlanCreatedState extends LearningPlanState {
  final LearningPlanSummaryDto plan;
  const LearningPlanCreatedState(this.plan);
}

class LearningPlanActivatedState extends LearningPlanState {
  final LearningPlanSummaryDto plan;
  const LearningPlanActivatedState(this.plan);
}

class LearningPlanErrorState extends LearningPlanState {
  final String message;
  const LearningPlanErrorState(this.message);
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class LearningPlanBloc extends Bloc<LearningPlanEvent, LearningPlanState> {
  final LearningPlanRepository _repository;

  LearningPlanBloc({LearningPlanRepository? repository})
      : _repository =
            repository ?? GetIt.instance<LearningPlanRepository>(),
        super(const LearningPlanInitialState()) {
    on<LearningPlanLoadEvent>(_onLoad);
    on<LearningPlanCreateEvent>(_onCreate);
    on<LearningPlanActivateEvent>(_onActivate);
    on<LearningPlanLoadItemsEvent>(_onLoadItems);
  }

  Future<void> _onLoad(
      LearningPlanLoadEvent event, Emitter<LearningPlanState> emit) async {
    emit(const LearningPlanLoadingState());
    try {
      final plans =
          await _repository.getPlans(status: event.statusFilter);
      emit(LearningPlanLoadedState(plans));
    } catch (e) {
      emit(LearningPlanErrorState(
          e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onCreate(
      LearningPlanCreateEvent event, Emitter<LearningPlanState> emit) async {
    emit(const LearningPlanCreatingState());
    try {
      final plan = await _repository.createPlan(event.dto);
      emit(LearningPlanCreatedState(plan));
    } catch (e) {
      emit(LearningPlanErrorState(
          e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onActivate(
      LearningPlanActivateEvent event,
      Emitter<LearningPlanState> emit) async {
    emit(const LearningPlanActivatingState());
    try {
      final plan = await _repository.activatePlan(event.planId);
      emit(LearningPlanActivatedState(plan));
    } catch (e) {
      emit(LearningPlanErrorState(
          e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLoadItems(
      LearningPlanLoadItemsEvent event,
      Emitter<LearningPlanState> emit) async {
    emit(const LearningPlanLoadingState());
    try {
      final items = await _repository.getPlanItems(event.planId);
      emit(LearningPlanItemsLoadedState(event.planId, items));
    } catch (e) {
      emit(LearningPlanErrorState(
          e.toString().replaceAll('Exception: ', '')));
    }
  }
}
