import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:english_learning_app/features/home/presentation/bloc/dashboard_bloc.dart';
import 'package:english_learning_app/features/home/data/dtos/dashboard_dto.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English Learning'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            tooltip: 'Admin — Quản lý câu',
            onPressed: () => context.push('/admin/sentences'),
          ),
          IconButton(
            icon: const Icon(Icons.psychology_alt_outlined),
            tooltip: 'Kiểm tra năng lực',
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang chuyển đến bài kiểm tra năng lực...'),
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
    
    String userDisplayName = 'Learner';
    authState.maybeWhen(
      authenticated: (_, __, displayName, token) {
        // Nếu displayName là token (quá dài), parse JWT để lấy tên
        if (displayName.length > 50) {
          // Parse JWT token để lấy claim "name" hoặc "sub"
          try {
            final parts = token.split('.');
            if (parts.length == 3) {
              final payload = parts[1];
              // Base64 decode (thêm padding nếu cần)
              String normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
              while (normalized.length % 4 != 0) {
                normalized += '=';
              }
              final decoded = const Utf8Decoder().convert(base64.decode(normalized));
              final Map<String, dynamic> json = jsonDecode(decoded);
              userDisplayName = json['name'] as String? ?? 
                                json['unique_name'] as String? ?? 
                                json['sub'] as String? ?? 
                                'Learner';
            }
          } catch (_) {
            userDisplayName = 'Learner';
          }
        } else {
          userDisplayName = displayName;
        }
      },
      orElse: () {},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $userDisplayName! 👋',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Let\'s learn English together today',
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
                color: levelColor.withValues(alpha: 0.1),
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
                    'Trình độ hiện tại',
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
              label: const Text('Test lại'),
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
            title: 'Streak',
            value: '${dashboard.streakDays}',
            icon: Icons.local_fire_department,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Points',
            value: '${dashboard.totalPoints}',
            icon: Icons.star,
            color: Colors.amber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'Mastered',
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
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
          'Quick Actions',
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
                label: 'Learn Today',
                icon: Icons.school,
                onTap: () => context.push('/daily-learning'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                label: 'Review',
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
                label: 'Rewards',
                icon: Icons.card_giftcard,
                onTap: () => context.push('/rewards'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                label: 'Library',
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
                label: 'Kế hoạch',
                icon: Icons.menu_book_rounded,
                onTap: () => context.push('/plans'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                label: 'Đã thuộc',
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
            color: const Color(0xFF4F6AF5).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4F6AF5).withOpacity(0.3),
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
          "Today's Progress",
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
                color: Colors.black.withOpacity(0.05),
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
                    'Sentences learned',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    '${dashboard.todayCompleted} / ${dashboard.todayTarget}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressValue.clamp(0.0, 1.0),
                  minHeight: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
