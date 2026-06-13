import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/daily_learning_bloc.dart';

class DailyLearningScreen extends StatelessWidget {
  const DailyLearningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Generate New Plan',
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
                  Text('Failed to load plan: $message', style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DailyLearningBloc>().add(const DailyLearningEvent.loadToday());
                    },
                    child: const Text('Retry'),
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
            const Text(
              'Hôm nay bạn chưa có bài học nào!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<DailyLearningBloc>().add(const DailyLearningEvent.generateToday());
              },
              child: const Text('Tạo kế hoạch hôm nay'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header info
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: ${todayLearning.planDate}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${todayLearning.completedCount} / ${todayLearning.totalSentences} completed',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // List of sentences
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: todayLearning.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = todayLearning.items[index];
              final sentence = item.sentence;
              final isCompleted = item.isCompletedToday || item.progressStatus == 'mastered';
              
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isCompleted ? Colors.green : Colors.grey.shade300,
                    width: isCompleted ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: isCompleted ? Colors.green.withOpacity(0.2) : Colors.blue.withOpacity(0.1),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.play_arrow,
                      color: isCompleted ? Colors.green : Colors.blue,
                    ),
                  ),
                  title: Text(
                    sentence.englishText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(sentence.vietnameseText),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to sentence study screen
                    context.push('/learn/study/${sentence.id}');
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
