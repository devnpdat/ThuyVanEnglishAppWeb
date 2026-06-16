import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:english_learning_app/features/home/presentation/bloc/dashboard_bloc.dart';
import 'package:english_learning_app/features/home/data/dtos/dashboard_dto.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isVietnamese = false; // false = EN, true = VI

  // Helper — trả text đúng ngôn ngữ
  String _t(String vi, String en) => _isVietnamese ? vi : en;

  @override
  void initState() {
    super.initState();
    // Load dashboard data mỗi khi màn hình được tạo/resume
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardBloc>().add(const DashboardEvent.load());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('App học Tiếng Anh của Thuỳ Vân', "Thuỳ Vân English")),
        elevation: 0,
        actions: [
          // Switch EN/VI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => setState(() => _isVietnamese = !_isVietnamese),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _isVietnamese
                      ? Colors.red.withValues(alpha: 0.15)
                      : const Color(0xFF4F6AF5).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isVietnamese ? Colors.red : const Color(0xFF4F6AF5),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _isVietnamese ? '🇻🇳 VI' : '🇺🇸 EN',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: _isVietnamese ? Colors.red[700] : const Color(0xFF4F6AF5),
                  ),
                ),
              ),
            ),
          ),
          // Admin icon - chỉ hiện cho devdatnp@gmail.com
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final isAdmin = authState.maybeWhen(
                authenticated: (_, email, __, ___) => email == 'devdatnp@gmail.com',
                orElse: () => false,
              );
              if (!isAdmin) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined),
                tooltip: 'Admin — Quản lý câu',
                onPressed: () => context.push('/admin/sentences'),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.psychology_alt_outlined),
            tooltip: _t('Kiểm tra năng lực', 'Placement Test'),
            onPressed: () => context.push('/placement-test'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load dashboard: $message', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<DashboardBloc>().add(const DashboardEvent.load()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            loaded: (dashboard) => _buildContent(context, dashboard),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DashboardDto dashboard) {
    // Redirect nếu chưa thi placement test
    if (!dashboard.hasTakenPlacementTest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/placement-test');
        }
      });
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(_t('Đang chuyển đến bài kiểm tra năng lực...', 'Redirecting to placement test...')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting section
          _buildGreetingSection(context),
          const SizedBox(height: 24),

          // Placement Test Level Card
          _buildPlacementLevelCard(context, dashboard),
          const SizedBox(height: 24),

          // Stats cards
          _buildStatsSection(context, dashboard),
          const SizedBox(height: 24),

          // Quick action buttons
          _buildQuickActionsSection(context),
          const SizedBox(height: 24),

          // Today's progress
          _buildTodayProgressSection(context, dashboard),
        ],
      ),
    );
  }

  Widget _buildGreetingSection(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    // Lấy displayName từ AuthState — đã được parse từ JWT khi login
    final userDisplayName = authState.maybeWhen(
      authenticated: (_, __, displayName, ___) =>
          displayName.isNotEmpty ? displayName : 'Learner',
      orElse: () => 'Learner',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('Chào mừng trở lại, $userDisplayName! 👋', 'Welcome back, $userDisplayName! 👋'),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _t('Hãy cùng học tiếng Anh hôm nay nhé', "Let's learn English together today"),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPlacementLevelCard(BuildContext context, DashboardDto dashboard) {
    final levelDisplay = dashboard.selfLevel ?? 'Unknown';
    IconData levelIcon;
    Color levelColor;

    switch (levelDisplay.toLowerCase()) {
      case 'beginner':
        levelIcon = Icons.school;
        levelColor = Colors.green;
        break;
      case 'intermediate':
        levelIcon = Icons.trending_up;
        levelColor = Colors.orange;
        break;
      case 'advanced':
        levelIcon = Icons.star;
        levelColor = Colors.purple;
        break;
      default:
        levelIcon = Icons.help_outline;
        levelColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: levelColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(levelIcon, color: levelColor, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t('Trình độ hiện tại', 'Current Level'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    levelDisplay,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: levelColor,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => context.push('/placement-test'),
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(_t('Test lại', 'Retest')),
              style: OutlinedButton.styleFrom(
                foregroundColor: levelColor,
                side: BorderSide(color: levelColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, DashboardDto dashboard) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: _t('Chuỗi ngày', 'Streak'),
            value: '${dashboard.streakDays}',
            icon: Icons.local_fire_department,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: _t('Điểm', 'Points'),
            value: '${dashboard.totalPoints}',
            icon: Icons.star,
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: _t('Đã thuộc', 'Mastered'),
            value: '${dashboard.totalSentencesMastered}',
            icon: Icons.check_circle,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t('Hành động nhanh', 'Quick Actions'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                label: _t('Học hôm nay', 'Learn Today'),
                icon: Icons.school,
                onTap: () => context.push('/daily-learning'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                label: _t('Ôn tập', 'Review'),
                icon: Icons.refresh,
                onTap: () => context.push('/review'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                label: _t('Phần thưởng', 'Rewards'),
                icon: Icons.card_giftcard,
                onTap: () => context.push('/rewards'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                label: _t('Thư viện', 'Library'),
                icon: Icons.library_books,
                onTap: () => context.push('/library'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                label: _t('Kế hoạch', 'Plans'),
                icon: Icons.menu_book_rounded,
                onTap: () => context.push('/plans'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                label: _t('Đã thuộc', 'Mastered'),
                icon: Icons.workspace_premium_rounded,
                onTap: () => context.push('/review/mastered'),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4F6AF5).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4F6AF5).withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFF4F6AF5), size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF4F6AF5),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayProgressSection(BuildContext context, DashboardDto dashboard) {
    final double progressValue = dashboard.todayTarget > 0 
        ? dashboard.todayCompleted / dashboard.todayTarget 
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _t("Tiến độ hôm nay", "Today's Progress"),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _t('Câu đã học hôm nay', 'Sentences learned today'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${dashboard.todayCompleted} / ${dashboard.todayTarget}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4F6AF5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressValue.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressValue >= 1.0 ? Colors.green : const Color(0xFF4F6AF5),
                  ),
                ),
              ),
              if (progressValue >= 1.0) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      _t('Hoàn thành mục tiêu hôm nay! 🎉', 'Daily goal achieved! 🎉'),
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
