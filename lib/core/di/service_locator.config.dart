// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:english_learning_app/core/services/audio_service.dart' as _i184;
import 'package:english_learning_app/core/services/audio_service_interface.dart'
    as _i239;
import 'package:english_learning_app/core/services/http_client.dart' as _i246;
import 'package:english_learning_app/core/services/local_storage_service.dart'
    as _i133;
import 'package:english_learning_app/core/services/sync_manager.dart' as _i1009;
import 'package:english_learning_app/features/ai/data/repositories/ai_repository.dart'
    as _i423;
import 'package:english_learning_app/features/auth/data/repositories/auth_repository.dart'
    as _i385;
import 'package:english_learning_app/features/home/data/repositories/dashboard_repository.dart'
    as _i731;
import 'package:english_learning_app/features/learning/data/repositories/daily_learning_repository.dart'
    as _i160;
import 'package:english_learning_app/features/learning/data/repositories/learning_plan_repository.dart'
    as _i98;
import 'package:english_learning_app/features/learning/data/repositories/learning_repository.dart'
    as _i1040;
import 'package:english_learning_app/features/learning/data/repositories/sentence_repository.dart'
    as _i596;
import 'package:english_learning_app/features/learning/data/repositories/topic_repository.dart'
    as _i707;
import 'package:english_learning_app/features/profile/data/repositories/user_profile_repository.dart'
    as _i852;
import 'package:english_learning_app/features/quiz/data/repositories/quiz_repository.dart'
    as _i337;
import 'package:english_learning_app/features/review/data/repositories/review_repository.dart'
    as _i836;
import 'package:english_learning_app/features/rewards/data/repositories/rewards_repository.dart'
    as _i15;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i246.HttpClient>(() => _i246.HttpClient());
    gh.singleton<_i133.LocalStorageService>(() => _i133.LocalStorageService());
    gh.singleton<_i239.IAudioService>(() => _i184.AudioService());
    gh.factory<_i731.DashboardRepository>(
        () => _i731.DashboardRepository(gh<_i246.HttpClient>()));
    gh.factory<_i385.AuthRepository>(
        () => _i385.AuthRepository(gh<_i246.HttpClient>()));
    gh.factory<_i160.DailyLearningRepository>(
        () => _i160.DailyLearningRepository(gh<_i246.HttpClient>()));
    gh.factory<_i596.SentenceRepository>(
        () => _i596.SentenceRepository(gh<_i246.HttpClient>()));
    gh.factory<_i707.TopicRepository>(
        () => _i707.TopicRepository(gh<_i246.HttpClient>()));
    gh.factory<_i1040.LearningRepository>(
        () => _i1040.LearningRepository(gh<_i246.HttpClient>()));
    gh.factory<_i98.LearningPlanRepository>(
        () => _i98.LearningPlanRepository(gh<_i246.HttpClient>()));
    gh.factory<_i15.RewardsRepository>(
        () => _i15.RewardsRepository(gh<_i246.HttpClient>()));
    gh.factory<_i337.QuizRepository>(
        () => _i337.QuizRepository(gh<_i246.HttpClient>()));
    gh.factory<_i852.UserProfileRepository>(
        () => _i852.UserProfileRepository(gh<_i246.HttpClient>()));
    gh.factory<_i423.AIRepository>(
        () => _i423.AIRepository(gh<_i246.HttpClient>()));
    gh.factory<_i836.ReviewRepository>(
        () => _i836.ReviewRepository(gh<_i246.HttpClient>()));
    gh.singleton<_i1009.SyncManager>(
        () => _i1009.SyncManager(gh<_i133.LocalStorageService>()));
    return this;
  }
}
