import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/features/auth/data/repositories/auth_repository.dart';
import 'package:english_learning_app/features/learning/data/repositories/topic_repository.dart';
import 'package:english_learning_app/features/learning/data/repositories/sentence_repository.dart';
import 'package:english_learning_app/features/learning/data/repositories/learning_repository.dart';
import 'package:english_learning_app/features/quiz/data/repositories/quiz_repository.dart';
import 'package:english_learning_app/features/review/data/repositories/review_repository.dart';
import 'package:english_learning_app/features/profile/data/repositories/user_profile_repository.dart';
import 'package:english_learning_app/features/rewards/data/repositories/rewards_repository.dart';
import 'package:english_learning_app/features/learning/data/repositories/learning_plan_repository.dart';
import 'package:english_learning_app/features/ai/data/repositories/ai_repository.dart';
import 'package:english_learning_app/features/home/data/repositories/dashboard_repository.dart';
import 'package:english_learning_app/features/learning/data/repositories/daily_learning_repository.dart';
import 'package:english_learning_app/core/services/audio_service.dart';

/// Service Locator — tất cả repositories và services được register ở đây
final getIt = GetIt.instance;

/// Initialize dependency injection
@injectableInit
void configureInjection() {
  // ── Core Infrastructure ───────────────────────────────────────────────────
  getIt.registerSingleton<HttpClient>(HttpClient());
  // AudioService dùng lazy — just_audio/audio_session cần WidgetsBinding đã attach xong
  // registerLazySingleton chỉ tạo instance khi getIt<AudioService>() được gọi lần đầu
  getIt.registerLazySingleton<AudioService>(() => AudioService());

  // ── Repositories ─────────────────────────────────────────────────────────
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<TopicRepository>(
    TopicRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<SentenceRepository>(
    SentenceRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<LearningRepository>(
    LearningRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<QuizRepository>(
    QuizRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<ReviewRepository>(
    ReviewRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<UserProfileRepository>(
    UserProfileRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<RewardsRepository>(
    RewardsRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<AIRepository>(
    AIRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<DashboardRepository>(
    DashboardRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<DailyLearningRepository>(
    DailyLearningRepository(getIt<HttpClient>()),
  );

  getIt.registerSingleton<LearningPlanRepository>(
    LearningPlanRepository(getIt<HttpClient>()),
  );
}

// ── Helper accessors ──────────────────────────────────────────────────────────
TopicRepository getTopicRepository() => getIt<TopicRepository>();
SentenceRepository getSentenceRepository() => getIt<SentenceRepository>();
LearningRepository getLearningRepository() => getIt<LearningRepository>();
QuizRepository getQuizRepository() => getIt<QuizRepository>();
ReviewRepository getReviewRepository() => getIt<ReviewRepository>();
UserProfileRepository getUserProfileRepository() => getIt<UserProfileRepository>();
RewardsRepository getRewardsRepository() => getIt<RewardsRepository>();
AIRepository getAIRepository() => getIt<AIRepository>();
AuthRepository getAuthRepository() => getIt<AuthRepository>();
LearningPlanRepository getLearningPlanRepository() => getIt<LearningPlanRepository>();
