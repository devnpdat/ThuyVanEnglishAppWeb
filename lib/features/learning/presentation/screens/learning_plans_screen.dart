import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/learning_plan_bloc.dart';
import 'package:english_learning_app/features/learning/data/repositories/learning_plan_repository.dart';

/// Màn hình danh sách Learning Plans + tạo plan mới
class LearningPlansScreen extends StatelessWidget {
  const LearningPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Kế hoạch học tập',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded),
            tooltip: 'Tạo kế hoạch mới',
            onPressed: () => _showCreatePlanDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<LearningPlanBloc, LearningPlanState>(
        listener: (context, state) {
          if (state is LearningPlanCreatedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('✅ Đã tạo "${state.plan.planName}"'),
              backgroundColor: Colors.green[700],
              behavior: SnackBarBehavior.floating,
            ));
            context
                .read<LearningPlanBloc>()
                .add(const LearningPlanLoadEvent());
          } else if (state is LearningPlanActivatedState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('🚀 Đã kích hoạt "${state.plan.planName}"'),
              backgroundColor: Colors.blue[700],
              behavior: SnackBarBehavior.floating,
            ));
            context
                .read<LearningPlanBloc>()
                .add(const LearningPlanLoadEvent());
          } else if (state is LearningPlanErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('❌ ${state.message}'),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          if (state is LearningPlanInitialState) {
            context
                .read<LearningPlanBloc>()
                .add(const LearningPlanLoadEvent());
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LearningPlanLoadingState ||
              state is LearningPlanCreatingState ||
              state is LearningPlanActivatingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LearningPlanLoadedState) {
            return _buildPlanList(context, state.plans);
          }
          if (state is LearningPlanErrorState) {
            return _buildError(context, state.message);
          }
          // Fallback for other states — trigger reload
          context
              .read<LearningPlanBloc>()
              .add(const LearningPlanLoadEvent());
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildPlanList(
      BuildContext context, List<LearningPlanSummaryDto> plans) {
    if (plans.isEmpty) return _buildEmpty(context);
    return RefreshIndicator(
      onRefresh: () async => context
          .read<LearningPlanBloc>()
          .add(const LearningPlanLoadEvent()),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, i) => _PlanCard(
          plan: plans[i],
          onTap: () => context.push(
              '/plans/${plans[i].id}?name=${Uri.encodeComponent(plans[i].planName)}'),
          onActivate: plans[i].status == 'draft'
              ? () => context
                  .read<LearningPlanBloc>()
                  .add(LearningPlanActivateEvent(plans[i].id))
              : null,
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.indigo[300]!,
                  Colors.purple[300]!
                ]),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.menu_book_rounded,
                  size: 48, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('Chưa có kế hoạch nào',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'Tạo kế hoạch học tập để\ntheo dõi tiến độ học hiệu quả hơn',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], height: 1.5),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _showCreatePlanDialog(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Tạo kế hoạch đầu tiên'),
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
                  .add(const LearningPlanLoadEvent()),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlanDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<LearningPlanBloc>(),
        child: const _CreatePlanSheet(),
      ),
    );
  }
}

// ─── Plan Card ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final LearningPlanSummaryDto plan;
  final VoidCallback onTap;
  final VoidCallback? onActivate;

  const _PlanCard({
    required this.plan,
    required this.onTap,
    this.onActivate,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor(plan.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: Text(plan.planName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(_statusIcon(plan.status),
                        size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(_statusLabel(plan.status),
                        style: TextStyle(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
              ]),
              if (plan.description?.isNotEmpty == true) ...[
                const SizedBox(height: 6),
                Text(plan.description!,
                    style: TextStyle(
                        color: Colors.grey[600], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 12),
              if (plan.status == 'active' ||
                  plan.status == 'completed') ...[
                Row(children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: plan.progressPercentage / 100,
                        backgroundColor:
                            colorScheme.surfaceContainerHighest,
                        color: statusColor,
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${plan.completedItems}/${plan.totalItems}',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600)),
                ]),
                const SizedBox(height: 8),
              ],
              Row(children: [
                Text(_diffLabel(plan.difficultyLevel),
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500])),
                if (plan.targetCompletionDate != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.calendar_today_rounded,
                      size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                      plan.targetCompletionDate!.length >= 10
                          ? plan.targetCompletionDate!.substring(0, 10)
                          : plan.targetCompletionDate!,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[500])),
                ],
                const Spacer(),
                if (onActivate != null)
                  TextButton.icon(
                    onPressed: onActivate,
                    icon: const Icon(Icons.play_arrow_rounded, size: 16),
                    label: const Text('Kích hoạt',
                        style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4)),
                  ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String s) => switch (s) {
        'active' => Colors.green,
        'completed' => Colors.blue,
        'cancelled' => Colors.grey,
        _ => Colors.orange,
      };

  String _statusLabel(String s) => switch (s) {
        'active' => 'Đang học',
        'completed' => 'Hoàn thành',
        'cancelled' => 'Đã hủy',
        _ => 'Bản nháp',
      };

  IconData _statusIcon(String s) => switch (s) {
        'active' => Icons.play_circle_rounded,
        'completed' => Icons.check_circle_rounded,
        'cancelled' => Icons.cancel_rounded,
        _ => Icons.edit_note_rounded,
      };

  String _diffLabel(String d) => switch (d) {
        'easy' => '🟢 Dễ',
        'hard' => '🔴 Khó',
        _ => '🟡 Trung bình',
      };
}

// ─── Create Plan Bottom Sheet ─────────────────────────────────────────────────

class _CreatePlanSheet extends StatefulWidget {
  const _CreatePlanSheet();

  @override
  State<_CreatePlanSheet> createState() => _CreatePlanSheetState();
}

class _CreatePlanSheetState extends State<_CreatePlanSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _difficulty = 'medium';
  int _sentenceCount = 50;
  DateTime _targetDate =
      DateTime.now().add(const Duration(days: 30));
  final List<String> _selectedTopicSlugs = [];

  final _quickTopics = const [
    ('greeting', '👋', 'Greeting'),
    ('shopping', '🛒', 'Shopping'),
    ('travel', '✈️', 'Travel'),
    ('work', '💼', 'Work'),
    ('food', '🍔', 'Food'),
    ('technology', '💻', 'Technology'),
    ('health', '💊', 'Health'),
    ('family', '👨‍👩‍👧', 'Family'),
    ('sports', '⚽', 'Sports'),
    ('ielts-speaking', '🎓', 'IELTS'),
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTopicSlugs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Vui lòng chọn ít nhất 1 chủ đề')));
      return;
    }
    context.read<LearningPlanBloc>().add(
          LearningPlanCreateEvent(
            CreateLearningPlanDto(
              planName: _nameCtrl.text.trim(),
              description: _descCtrl.text.trim().isEmpty
                  ? null
                  : _descCtrl.text.trim(),
              targetCompletionDate:
                  _targetDate.toIso8601String().substring(0, 10),
              difficultyLevel: _difficulty,
              topicIds: _selectedTopicSlugs,
              sentenceCount: _sentenceCount,
            ),
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Tạo kế hoạch học',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tên kế hoạch *',
                  hintText: 'VD: IELTS Speaking 30 ngày',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.book_rounded),
                ),
                validator: (v) => (v?.trim().isEmpty ?? true)
                    ? 'Vui lòng nhập tên'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Mô tả (tuỳ chọn)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description_rounded),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Chủ đề *',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: _quickTopics.map((t) {
                  final isSelected = _selectedTopicSlugs.contains(t.$1);
                  return FilterChip(
                    label: Text('${t.$2} ${t.$3}'),
                    selected: isSelected,
                    onSelected: (v) => setState(() {
                      if (v) {
                        _selectedTopicSlugs.add(t.$1);
                      } else {
                        _selectedTopicSlugs.remove(t.$1);
                      }
                    }),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Độ khó',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'easy', label: Text('Dễ')),
                  ButtonSegment(
                      value: 'medium', label: Text('Trung bình')),
                  ButtonSegment(value: 'hard', label: Text('Khó')),
                ],
                selected: {_difficulty},
                onSelectionChanged: (s) =>
                    setState(() => _difficulty = s.first),
              ),
              const SizedBox(height: 16),
              Row(children: [
                const Text('Số câu: ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                Text('$_sentenceCount câu',
                    style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold)),
              ]),
              Slider(
                value: _sentenceCount.toDouble(),
                min: 10,
                max: 200,
                divisions: 19,
                label: '$_sentenceCount',
                onChanged: (v) =>
                    setState(() => _sentenceCount = v.round()),
              ),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.calendar_today_rounded, size: 16),
                const SizedBox(width: 8),
                const Text('Mục tiêu hoàn thành: ',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _targetDate,
                      firstDate:
                          DateTime.now().add(const Duration(days: 1)),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setState(() => _targetDate = picked);
                    }
                  },
                  child: Text(
                      '${_targetDate.day}/${_targetDate.month}/${_targetDate.year}'),
                ),
              ]),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Tạo kế hoạch',
                      style: TextStyle(fontSize: 16)),
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
