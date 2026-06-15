import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:english_learning_app/features/auth/presentation/screens/login_screen.dart';
import 'package:english_learning_app/features/home/presentation/screens/home_screen.dart';
import 'package:english_learning_app/features/learning/presentation/screens/sentence_list_screen.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/sentence_list_bloc.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/topic_list_bloc.dart';
import 'package:english_learning_app/features/learning/presentation/screens/topic_list_screen.dart';
import 'package:english_learning_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:english_learning_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:english_learning_app/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:english_learning_app/features/quiz/presentation/bloc/quiz_bloc.dart';
import 'package:english_learning_app/features/review/presentation/screens/review_screen.dart';
import 'package:english_learning_app/features/review/presentation/bloc/review_bloc.dart';
import 'package:english_learning_app/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:english_learning_app/features/rewards/presentation/bloc/rewards_bloc.dart';
import 'package:english_learning_app/features/home/presentation/bloc/dashboard_bloc.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/daily_learning_bloc.dart';
import 'package:english_learning_app/features/learning/presentation/screens/daily_learning_screen.dart';
import 'package:english_learning_app/features/learning/presentation/screens/sentence_study_screen.dart';
import 'package:english_learning_app/features/learning/presentation/screens/learning_plans_screen.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/learning_plan_bloc.dart';
import 'package:english_learning_app/features/learning/presentation/screens/learning_plan_detail_screen.dart';
import 'package:english_learning_app/features/quiz/presentation/screens/quiz_stats_screen.dart';
import 'package:english_learning_app/features/review/presentation/screens/mastered_sentences_screen.dart';
import 'package:english_learning_app/features/admin/presentation/screens/admin_shell_screen.dart';
import 'package:english_learning_app/features/admin/presentation/screens/admin_topics_screen.dart';
import 'package:english_learning_app/features/admin/presentation/screens/admin_settings_screen.dart';
import 'package:english_learning_app/features/admin/presentation/screens/admin_users_screen.dart';
import 'package:english_learning_app/features/admin/presentation/screens/admin_sentences_screen.dart';
import 'package:english_learning_app/features/placement_test/presentation/bloc/placement_test_bloc.dart';
import 'package:english_learning_app/features/placement_test/presentation/screens/placement_test_screen.dart';
import 'package:english_learning_app/features/placement_test/presentation/screens/placement_result_screen.dart';
import 'package:english_learning_app/features/placement_test/data/dtos/placement_test_dto.dart';


// ─── Placeholder screen ───────────────────────────────────────────────────────

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  const _PlaceholderScreen({
    required this.title,
    this.icon = Icons.construction_rounded,
    this.description = 'Tính năng này đang được phát triển.\nHãy quay lại sau nhé!',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(icon, size: 48, color: Colors.orange[400]),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[600], fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 8),
              const Text('🚧', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay về trang chủ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── AuthBloc singleton (tồn tại suốt app lifecycle) ─────────────────────────

final _authBloc = AuthBloc()..add(const AuthCheckStatusEvent());

// ─── DashboardBloc singleton — tồn tại suốt app lifecycle ────────────────────
// Dùng singleton để có thể reload từ bất kỳ đâu (e.g. sau khi học xong câu)
final _dashboardBloc = DashboardBloc()..add(const DashboardEvent.load());

// Wire 401 handler — đá về login và logout AuthBloc
void _setup401Handler() {
  HttpClient.onUnauthorized = () {
    _authBloc.add(const AuthLogoutEvent());
    _router.go('/login');
  };
}

// ─── Router ───────────────────────────────────────────────────────────────────

final _router = GoRouter(
  initialLocation: '/login',
  observers: [_DashboardReloadObserver()],
  refreshListenable: _GoRouterRefreshStream(_authBloc.stream),
  redirect: (context, state) {
    final authState = _authBloc.state;
    final isAuthenticated = authState.maybeWhen(
      authenticated: (_, __, ___, ____) => true,
      orElse: () => false,
    );
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    final loc = state.matchedLocation;
    final onLogin = loc == '/login';
    final onPlacementTest = loc.startsWith('/placement-test');

    // Đang check status — không redirect
    if (isLoading) return null;

    if (!isAuthenticated && !onLogin) return '/login';
    if (isAuthenticated && onLogin) return '/';
    return null;
  },
  routes: [
    // Auth
    GoRoute(
      path: '/login',
      builder: (context, state) => BlocProvider.value(
        value: _authBloc,
        child: const LoginScreen(),
      ),
    ),

    // Home
    GoRoute(
      path: '/',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authBloc),
          // Dùng singleton _dashboardBloc để reload được từ bất kỳ đâu
          BlocProvider.value(value: _dashboardBloc),
        ],
        child: const HomeScreen(),
      ),
    ),

    // Profile
    GoRoute(
      path: '/profile',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _authBloc),
          BlocProvider(
            create: (_) => ProfileBloc()..add(const ProfileLoadEvent()),
          ),
        ],
        child: const ProfileScreen(),
      ),
    ),

    // Daily Learning Plan
    GoRoute(
      path: '/daily-learning',
      builder: (context, state) => BlocProvider(
        create: (_) => DailyLearningBloc()..add(const DailyLearningEvent.loadToday()),
        child: const DailyLearningScreen(),
      ),
    ),

    // Sentence Study Session
    GoRoute(
      path: '/learn/study/:id',
      builder: (context, state) {
        final sentenceId = state.pathParameters['id']!;
        return BlocProvider(
          create: (_) => DailyLearningBloc()..add(const DailyLearningEvent.loadToday()),
          child: SentenceStudyScreen(sentenceId: sentenceId),
        );
      },
    ),

    // Learn Today — sentences list
    GoRoute(
      path: '/learn/today',
      builder: (context, state) {
        final topicId = state.uri.queryParameters['topicId'];
        final difficulty = state.uri.queryParameters['difficulty'];
        return BlocProvider(
          create: (_) => SentenceListBloc()
            ..add(SentenceListInitialEvent(
              topicId: topicId,
              difficultyLevel: difficulty,
            )),
          child: const SentenceListScreen(),
        );
      },
    ),

    // Quiz screen
    GoRoute(
      path: '/quiz',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => QuizBloc()
            ..add(QuizLoadEvent(
              sentenceId: state.uri.queryParameters['sentenceId'] ?? '',
              quizType: state.uri.queryParameters['type'] ?? 'multiple_choice',
            )),
          child: const QuizScreen(),
        );
      },
    ),

    // Review screen
    GoRoute(
      path: '/review',
      builder: (context, state) => BlocProvider(
        create: (_) => ReviewBloc()..add(const ReviewLoadTodayEvent()),
        child: const ReviewScreen(),
      ),
    ),

    // Rewards screen — BLoC được khởi tạo không add event,
    // RewardsScreen.initState() tự dispatch RewardsLoadEvent + LeaderboardLoadEvent
    GoRoute(
      path: '/rewards',
      builder: (context, state) => BlocProvider(
        create: (_) => RewardsBloc(),
        child: const RewardsScreen(),
      ),
    ),

    // Library — topics list
    GoRoute(
      path: '/library',
      builder: (context, state) => BlocProvider(
        create: (_) => TopicListBloc(),
        child: const TopicListScreen(),
      ),
    ),

    // Learning Plans — danh sách + tạo mới
    GoRoute(
      path: '/plans',
      builder: (context, state) => BlocProvider(
        create: (_) => LearningPlanBloc(),
        child: const LearningPlansScreen(),
      ),
    ),

    // Learning Plan Detail
    GoRoute(
      path: '/plans/:id',
      builder: (context, state) {
        final planId = state.pathParameters['id']!;
        final planName = state.uri.queryParameters['name'] ?? 'Kế hoạch';
        return BlocProvider(
          create: (_) => LearningPlanBloc()
            ..add(LearningPlanLoadItemsEvent(planId)),
          child: LearningPlanDetailScreen(
              planId: planId, planName: planName),
        );
      },
    ),

    // Mastered Sentences
    GoRoute(
      path: '/review/mastered',
      builder: (context, state) => const MasteredSentencesScreen(),
    ),

    // Quiz Stats
    GoRoute(
      path: '/quiz/stats',
      builder: (context, state) => const QuizStatsScreen(),
    ),

    // ── Admin Panel ──────────────────────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => AdminShellScreen(child: child),
      routes: [
        GoRoute(
          path: '/admin/topics',
          builder: (_, __) => const AdminTopicsScreen(),
        ),
        GoRoute(
          path: '/admin/sentences',
          builder: (_, __) => const AdminSentencesScreen(),
        ),
        GoRoute(
          path: '/admin/settings',
          builder: (_, __) => const AdminSettingsScreen(),
        ),
        GoRoute(
          path: '/admin/users',
          builder: (_, __) => const AdminUsersScreen(),
        ),
      ],
    ),

    // ── Placement Test ───────────────────────────────────────────────────────

    // Màn hình làm bài kiểm tra năng lực
    GoRoute(
      path: '/placement-test',
      builder: (context, state) => BlocProvider(
        create: (_) => PlacementTestBloc()
          ..add(const PlacementTestLoadQuestionsEvent()),
        child: const PlacementTestScreen(),
      ),
    ),

    // Màn hình kết quả placement test
    GoRoute(
      path: '/placement-test/result',
      builder: (context, state) {
        final result = state.extra as PlacementTestResultDto?;
        if (result == null) {
          // Nếu navigate thẳng vào URL này mà không có data → về home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) context.go('/');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return PlacementResultScreen(result: result);
      },
    ),
  ],
);

// ─── GoRouter refresh helper ──────────────────────────────────────────────────

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// ─── Root App Widget ──────────────────────────────────────────────────────────

class EnglishLearningApp extends StatelessWidget {
  const EnglishLearningApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Setup 401 → auto redirect về login
    _setup401Handler();

    return BlocProvider.value(
      value: _authBloc,
      child: MaterialApp.router(
        title: 'English Learning App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF4F6AF5),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: const Color(0xFF4F6AF5),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        routerConfig: _router,
      ),
    );
  }
}

// ─── Helpers for LoginScreen ──────────────────────────────────────────────────

/// Gọi khi login thành công — trigger router redirect
void notifyLoginSuccess() {
  _router.refresh();
}

/// Trigger logout từ bất kỳ đâu
void triggerLogout() {
  _authBloc.add(const AuthLogoutEvent());
}

// ─── Dashboard reload observer ────────────────────────────────────────────────
/// NavigatorObserver để tự động reload DashboardBloc khi navigate về '/'
/// Giải quyết vấn đề dashboard stale sau khi học xong câu.
class _DashboardReloadObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Khi pop về '/' (HomeScreen) → reload dashboard
    if (previousRoute?.settings.name == '/' ||
        previousRoute?.settings.name == null) {
      _dashboardBloc.add(const DashboardEvent.load());
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // Khi go('/') replace route hiện tại → reload dashboard
    if (newRoute?.settings.name == '/') {
      _dashboardBloc.add(const DashboardEvent.load());
    }
  }
}
