import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/daily_learning_bloc.dart';

String _formatPlanDate(String isoDate) {
  try {
    final dt = DateTime.parse(isoDate);
    return DateFormat('dd/MM/yyyy').format(dt);
  } catch (_) {
    return isoDate;
  }
}

class DailyLearningScreen extends StatelessWidget {
  const DailyLearningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kế hoạch hôm nay'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Tạo kế hoạch mới',
            onPressed: () {
              context.read<DailyLearningBloc>().add(const DailyLearningEvent.generateToday());
            },
          ),
        ],
      ),
      body: BlocBuilder<DailyLearningBloc, DailyLearningState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi tải kế hoạch: $message',
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DailyLearningBloc>().add(const DailyLearningEvent.loadToday());
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            typingResult: (_, current) => _buildContent(context, current),
            quizResult: (_, current) => _buildContent(context, current),
            completeResult: (_, current) => _buildContent(context, current),
            loaded: (todayLearning) => _buildContent(context, todayLearning),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic todayLearning) {
    if (todayLearning.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Hôm nay bạn chưa có bài học nào!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<DailyLearningBloc>().add(const DailyLearningEvent.generateToday());
              },
              icon: const Icon(Icons.add),
              label: const Text('Tạo kế hoạch hôm nay'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // ── Header: ngày + tiến độ ──────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF4F6AF5).withValues(alpha: 0.06),
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF4F6AF5)),
              const SizedBox(width: 6),
              Text(
                _formatPlanDate(todayLearning.planDate),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: todayLearning.completedCount >= todayLearning.totalSentences
                      ? Colors.green
                      : const Color(0xFF4F6AF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${todayLearning.completedCount}/${todayLearning.totalSentences} câu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── List câu ────────────────────────────────────────────────────────
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: todayLearning.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = todayLearning.items[index];
              final sentence = item.sentence;
              final isCompleted = item.isCompletedToday || item.progressStatus == 'mastered';

              return Card(
                elevation: isCompleted ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isCompleted ? Colors.green.shade300 : Colors.grey.shade200,
                    width: isCompleted ? 1.5 : 1,
                  ),
                ),
                color: isCompleted ? Colors.green.withValues(alpha: 0.04) : Colors.white,
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? Colors.green.withValues(alpha: 0.15)
                          : const Color(0xFF4F6AF5).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.play_arrow,
                      color: isCompleted ? Colors.green : const Color(0xFF4F6AF5),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    sentence.englishText,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isCompleted ? Colors.grey[500] : Colors.black87,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                      decorationColor: Colors.grey[400],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      sentence.vietnameseText,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ),
                  trailing: isCompleted
                      ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                      : const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    // Bug 3 fix: reload BLoC khi quay lại để cập nhật completion state
                    context.push('/learn/study/${sentence.id}').then((_) {
                      if (context.mounted) {
                        context.read<DailyLearningBloc>()
                            .add(const DailyLearningEvent.loadToday());
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
