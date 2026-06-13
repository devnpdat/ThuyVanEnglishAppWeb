import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/quiz/data/repositories/quiz_repository.dart';

// ─── State ────────────────────────────────────────────────────────────────────

abstract class QuizStatsViewState {}

class QuizStatsViewInitial extends QuizStatsViewState {}

class QuizStatsViewLoading extends QuizStatsViewState {}

class QuizStatsViewLoaded extends QuizStatsViewState {
  final QuizStats stats;
  QuizStatsViewLoaded(this.stats);
}

class QuizStatsViewError extends QuizStatsViewState {
  final String message;
  QuizStatsViewError(this.message);
}

// ─── Cubit ────────────────────────────────────────────────────────────────────

class QuizStatsCubit extends Cubit<QuizStatsViewState> {
  final QuizRepository _repo;

  QuizStatsCubit()
      : _repo = GetIt.instance<QuizRepository>(),
        super(QuizStatsViewInitial()) {
    load();
  }

  Future<void> load() async {
    emit(QuizStatsViewLoading());
    try {
      final stats = await _repo.getQuizStats();
      emit(QuizStatsViewLoaded(stats));
    } catch (e) {
      emit(QuizStatsViewError(
          e.toString().replaceAll('Exception: ', '')));
    }
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

/// Màn hình thống kê Quiz
class QuizStatsScreen extends StatelessWidget {
  const QuizStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuizStatsCubit(),
      child: const _QuizStatsBody(),
    );
  }
}

class _QuizStatsBody extends StatelessWidget {
  const _QuizStatsBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Thống kê Quiz 📊',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<QuizStatsCubit, QuizStatsViewState>(
        builder: (context, state) {
          if (state is QuizStatsViewLoading ||
              state is QuizStatsViewInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is QuizStatsViewError) {
            return _buildError(context, state.message);
          }
          if (state is QuizStatsViewLoaded) {
            return _buildStats(context, state.stats);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStats(BuildContext context, QuizStats stats) {
    final colorScheme = Theme.of(context).colorScheme;
    final successPct = (stats.successRate * 100).toStringAsFixed(1);
    final successColor = stats.successRate >= 0.7
        ? Colors.green
        : stats.successRate >= 0.5
            ? Colors.orange
            : Colors.red;

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<QuizStatsCubit>().load(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text('Tỷ lệ đúng tổng thể',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Text(
                  '$successPct%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 56,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: stats.successRate,
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Stats grid
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                icon: Icons.quiz_rounded,
                label: 'Tổng lần quiz',
                value: '${stats.totalAttempts}',
                color: colorScheme.primary,
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                icon: Icons.check_circle_rounded,
                label: 'Trả lời đúng',
                value: '${stats.correctAnswers}',
                color: Colors.green,
              )),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _StatCard(
                icon: Icons.cancel_rounded,
                label: 'Trả lời sai',
                value:
                    '${stats.totalAttempts - stats.correctAnswers}',
                color: Colors.red,
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _StatCard(
                icon: Icons.trending_up_rounded,
                label: 'Tỷ lệ đúng',
                value: '$successPct%',
                color: successColor,
              )),
            ],
          ),
          const SizedBox(height: 24),
          // Encouragement
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  _emoji(stats.successRate),
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _message(stats.successRate),
                    style: const TextStyle(
                        fontSize: 14, height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _emoji(double rate) {
    if (rate >= 0.9) return '🏆';
    if (rate >= 0.7) return '🎯';
    if (rate >= 0.5) return '📈';
    return '💪';
  }

  String _message(double rate) {
    if (rate >= 0.9) return 'Xuất sắc! Bạn đang làm rất tốt. Tiếp tục duy trì nhé!';
    if (rate >= 0.7) return 'Tốt lắm! Tỷ lệ đúng trên 70%. Hãy cố lên 90%!';
    if (rate >= 0.5) return 'Đang tiến bộ! Hãy ôn lại các câu sai để cải thiện nhé.';
    return 'Cố lên! Luyện tập đều đặn hàng ngày sẽ giúp bạn cải thiện nhanh.';
  }

  Widget _buildError(BuildContext context, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(msg, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () =>
                context.read<QuizStatsCubit>().load(),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
