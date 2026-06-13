import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:english_learning_app/core/di/service_locator.dart';
import 'package:english_learning_app/features/home/data/dtos/dashboard_dto.dart';
import 'package:english_learning_app/features/home/data/repositories/dashboard_repository.dart';

part 'dashboard_bloc.freezed.dart';

// --- Events ---
@freezed
class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.load() = _Load;
}

// --- States ---
@freezed
class DashboardState with _$DashboardState {
  const factory DashboardState.initial() = _Initial;
  const factory DashboardState.loading() = _Loading;
  const factory DashboardState.loaded(DashboardDto dashboard) = _Loaded;
  const factory DashboardState.error(String message) = _Error;
}

// --- Bloc ---
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _repository;

  DashboardBloc({DashboardRepository? repository})
      : _repository = repository ?? getIt<DashboardRepository>(),
        super(const DashboardState.initial()) {
    on<_Load>(_onLoad);
  }

  Future<void> _onLoad(_Load event, Emitter<DashboardState> emit) async {
    emit(const DashboardState.loading());
    try {
      final dashboard = await _repository.getDashboardStats();
      emit(DashboardState.loaded(dashboard));
    } catch (e) {
      emit(DashboardState.error(e.toString()));
    }
  }
}
