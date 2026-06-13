import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_learning_app/core/di/service_locator.dart';
import 'package:english_learning_app/core/config/app_config.dart';
import 'package:english_learning_app/features/profile/data/repositories/user_profile_repository.dart';
import 'package:english_learning_app/features/rewards/data/repositories/rewards_repository.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoadEvent extends ProfileEvent {
  const ProfileLoadEvent();
}

class ProfileUpdateEvent extends ProfileEvent {
  final String learningGoal;
  final String selfLevel;
  final int dailyTargetMinutes;

  const ProfileUpdateEvent({
    required this.learningGoal,
    required this.selfLevel,
    required this.dailyTargetMinutes,
  });

  @override
  List<Object?> get props => [learningGoal, selfLevel, dailyTargetMinutes];
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final String userId;
  final String email;
  final String displayName;
  final String learningGoal;
  final String selfLevel;
  final int dailyTargetMinutes;
  final int totalPointsEarned;
  final int streakDays;
  final int longestStreak;
  final bool hasProfile; // false nếu chưa tạo profile

  const ProfileLoaded({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.learningGoal,
    required this.selfLevel,
    required this.dailyTargetMinutes,
    required this.totalPointsEarned,
    required this.streakDays,
    required this.longestStreak,
    this.hasProfile = true,
  });

  @override
  List<Object?> get props => [
        userId,
        email,
        displayName,
        learningGoal,
        selfLevel,
        dailyTargetMinutes,
        totalPointsEarned,
        streakDays,
        longestStreak,
      ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserProfileRepository _userProfileRepository;
  final RewardsRepository _rewardsRepository;

  ProfileBloc({
    UserProfileRepository? userProfileRepository,
    RewardsRepository? rewardsRepository,
  })  : _userProfileRepository =
            userProfileRepository ?? getIt<UserProfileRepository>(),
        _rewardsRepository = rewardsRepository ?? getIt<RewardsRepository>(),
        super(const ProfileInitial()) {
    on<ProfileLoadEvent>(_onLoad);
    on<ProfileUpdateEvent>(_onUpdate);
  }

  Future<void> _onLoad(
    ProfileLoadEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    try {
      // Lấy stored auth info
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(AppConfig.userEmailKey) ?? '';
      final userId = prefs.getString(AppConfig.userIdKey) ?? '';
      final displayName = prefs.getString(AppConfig.userDisplayNameKey) ?? email;

      // Load profile + rewards song song
      final futures = await Future.wait([
        _userProfileRepository.getCurrentProfile().catchError((e) => null as UserProfileDto?),
        _rewardsRepository.getSummary().catchError((e) => null as RewardsSummaryDto?),
      ]);

      final profile = futures[0] as UserProfileDto?;
      final rewards = futures[1] as RewardsSummaryDto?;

      if (profile == null) {
        // Chưa có profile → hiển thị thông tin cơ bản từ auth
        emit(ProfileLoaded(
          userId: userId,
          email: email,
          displayName: displayName,
          learningGoal: 'conversation',
          selfLevel: 'Beginner',
          dailyTargetMinutes: 30,
          totalPointsEarned: rewards?.totalPoints ?? 0,
          streakDays: rewards?.streakDaysCount ?? 0,
          longestStreak: 0,
          hasProfile: false,
        ));
      } else {
        emit(ProfileLoaded(
          userId: profile.userId.isNotEmpty ? profile.userId : userId,
          email: email,
          displayName: displayName,
          learningGoal: profile.learningGoal,
          selfLevel: profile.selfLevel,
          dailyTargetMinutes: profile.dailyTargetMinutes,
          totalPointsEarned:
              rewards?.totalPoints ?? profile.totalPoints,
          streakDays: rewards?.streakDaysCount ?? profile.currentStreak,
          longestStreak: profile.longestStreak,
          hasProfile: true,
        ));
      }
    } catch (e) {
      emit(ProfileError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onUpdate(
    ProfileUpdateEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    try {
      final updated = await _userProfileRepository.updateProfile(
        UpdateUserProfileRequest(
          learningGoal: event.learningGoal,
          selfLevel: event.selfLevel,
          dailyTargetMinutes: event.dailyTargetMinutes,
        ),
      );

      emit(ProfileLoaded(
        userId: currentState.userId,
        email: currentState.email,
        displayName: currentState.displayName,
        learningGoal: updated.learningGoal,
        selfLevel: updated.selfLevel,
        dailyTargetMinutes: updated.dailyTargetMinutes,
        totalPointsEarned: currentState.totalPointsEarned,
        streakDays: currentState.streakDays,
        longestStreak: currentState.longestStreak,
        hasProfile: true,
      ));
    } catch (e) {
      emit(ProfileError(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
