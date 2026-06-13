import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/learning_plan_bloc.dart';
import 'package:english_learning_app/features/learning/data/repositories/learning_plan_repository.dart';

/// Màn hình chi tiết Learning Plan — tiến độ + danh sách câu
class LearningPlanDetailScreen extends StatelessWidget {
  final String planId;
  final String planName;

  const LearningPlanDetailScreen({
    super.key,
    required this.planId,
    required this.planName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(planName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: BlocConsumer<LearningPlanBloc, LearningPlanState>(
        listener: (context, state) {
          if (state is LearningPlanErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('❌ ${state.message}'),
              backgroundColor: Colors.red[700],
            ));
          } else if (state is LearningPlanActivatedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('🚀 Đã kích hoạt "${state.plan.planName}"!'),
              backgroundColor: Colors.green[700],
              behavior: SnackBarBehavior.floating,
            ));
            context
                .read<LearningPlanBloc>()
                .add(LearningPlanLoadItemsEvent(planId));
          }
        },
        builder: (context, state) {
          if (state is LearningPlanInitialState) {
            context
                .read<LearningPlanBloc>()
                .add(LearningPlanLoadItemsEvent(planId));
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LearningPlanLoadingState ||
              state is LearningPlanActivatingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LearningPlanItemsLoadedState) {
            return _buildContent(context, state.items);
          }
          if (state is LearningPlanErrorState) {
            return _buildError(context, state.message);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, List<LearningPlanItemDto> items) {
    final completed = items.where((i) => i.isCompleted).length;
    final total = items.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      children: [
        // Progress header
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tiến độ',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 14)),
                    Text('$completed / $total câu',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ]),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 4),
              Text('${(progress * 100).toStringAsFixed(0)}% hoàn thành',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        if (items.isEmpty)
          const Expanded(
            child: Center(
              child: Text('Kế hoạch chưa có câu. Kích hoạt để thêm câu.'),
            ),
          )
        else
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => context
                  .read<LearningPlanBloc>()
                  .add(LearningPlanLoadItemsEvent(planId)),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (context, i) =>
                    _ItemTile(item: items[i], index: i + 1),
              ),
            ),
          ),
      ],
    );
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
            onPressed: () => context
                .read<LearningPlanBloc>()
                .add(LearningPlanLoadItemsEvent(planId)),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final LearningPlanItemDto item;
  final int index;
  const _ItemTile({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: item.isCompleted
              ? Colors.green.withValues(alpha: 0.3)
              : colorScheme.outlineVariant,
        ),
      ),
      color: item.isCompleted
          ? Colors.green.withValues(alpha: 0.05)
          : null,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: item.isCompleted
              ? Colors.green
              : colorScheme.primaryContainer,
          child: item.isCompleted
              ? const Icon(Icons.check_rounded,
                  color: Colors.white, size: 18)
              : Text('$index',
                  style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
        ),
        title: Text(
          item.englishText,
          style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: item.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
              color: item.isCompleted ? Colors.grey : null),
        ),
        subtitle: Text(item.vietnameseseText,
            style: const TextStyle(fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        trailing: item.topicName != null
            ? Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(item.topicName!,
                    style: const TextStyle(fontSize: 10)),
              )
            : null,
      ),
    );
  }
}
