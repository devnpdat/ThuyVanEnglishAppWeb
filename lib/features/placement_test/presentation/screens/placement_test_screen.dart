import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/placement_test/presentation/bloc/placement_test_bloc.dart';
import 'package:english_learning_app/features/placement_test/data/dtos/placement_test_dto.dart';

/// Màn hình làm bài kiểm tra năng lực (40 câu trắc nghiệm)
class PlacementTestScreen extends StatelessWidget {
  const PlacementTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlacementTestBloc, PlacementTestState>(
      listener: (context, state) {
        if (state is PlacementTestResult) {
          // Navigate sang màn hình kết quả
          context.go('/placement-test/result', extra: state.result);
        } else if (state is PlacementTestError) {
          _showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is PlacementTestLoading || state is PlacementTestInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is PlacementTestLoaded) {
          return _TestBody(state: state);
        }
        if (state is PlacementTestSubmitting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang chấm bài...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ─── Main body ────────────────────────────────────────────────────────────────

class _TestBody extends StatelessWidget {
  final PlacementTestLoaded state;

  const _TestBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final question = state.currentQuestion;
    final selectedOption = state.answers[question.id];
    final phase = question.phase;
    final total = state.totalQuestions;
    final current = state.currentIndex + 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Bài kiểm tra năng lực',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$current/$total',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F6AF5),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar
            LinearProgressIndicator(
              value: current / total,
              backgroundColor: const Color(0xFFE8EEFF),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4F6AF5)),
              minHeight: 4,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phase badge
                    _PhaseBadge(phase: phase),
                    const SizedBox(height: 20),

                    // Reading passage (nếu có)
                    if (question.readingPassage != null) ...[
                      _ReadingPassageCard(passage: question.readingPassage!),
                      const SizedBox(height: 20),
                    ],

                    // Question text
                    Text(
                      question.questionText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Options
                    _OptionTile(
                      label: 'A',
                      text: question.optionA,
                      selected: selectedOption == 'A',
                      onTap: () => _answer(context, question.id, 'A'),
                    ),
                    const SizedBox(height: 12),
                    _OptionTile(
                      label: 'B',
                      text: question.optionB,
                      selected: selectedOption == 'B',
                      onTap: () => _answer(context, question.id, 'B'),
                    ),
                    const SizedBox(height: 12),
                    _OptionTile(
                      label: 'C',
                      text: question.optionC,
                      selected: selectedOption == 'C',
                      onTap: () => _answer(context, question.id, 'C'),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            _BottomNav(state: state),
          ],
        ),
      ),
    );
  }

  void _answer(BuildContext context, String questionId, String option) {
    context.read<PlacementTestBloc>().add(
          PlacementTestAnswerSelectedEvent(
            questionId: questionId,
            selectedOption: option,
          ),
        );
  }
}

// ─── Phase badge ──────────────────────────────────────────────────────────────

class _PhaseBadge extends StatelessWidget {
  final int phase;

  const _PhaseBadge({required this.phase});

  static const _labels = {
    1: 'Beginner',
    2: 'Elementary',
    3: 'Intermediate',
    4: 'Upper-Intermediate',
    5: 'Advanced',
  };

  static const _colors = {
    1: Color(0xFF4CAF50),
    2: Color(0xFF2196F3),
    3: Color(0xFF9C27B0),
    4: Color(0xFFFF9800),
    5: Color(0xFFF44336),
  };

  @override
  Widget build(BuildContext context) {
    final label = _labels[phase] ?? 'Phase $phase';
    final color = _colors[phase] ?? const Color(0xFF4F6AF5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            'Phase $phase · $label',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reading passage card ─────────────────────────────────────────────────────

class _ReadingPassageCard extends StatelessWidget {
  final String passage;

  const _ReadingPassageCard({required this.passage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBCBFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book_rounded, size: 16, color: Color(0xFF4F6AF5)),
              SizedBox(width: 6),
              Text(
                'Đọc đoạn văn sau:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4F6AF5),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            passage,
            style: const TextStyle(
              fontSize: 14,
              height: 1.7,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Option tile ──────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final String label;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.label,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4F6AF5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF4F6AF5) : const Color(0xFFE2E8F0),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4F6AF5).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.25)
                    : const Color(0xFFF0F4FF),
                shape: BoxShape.circle,
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: selected ? Colors.white : const Color(0xFF4F6AF5),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: selected ? Colors.white : const Color(0xFF2D3748),
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom navigation bar ────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final PlacementTestLoaded state;

  const _BottomNav({required this.state});

  @override
  Widget build(BuildContext context) {
    final isLast = !state.canGoNext;
    final hasAnsweredCurrent =
        state.answers.containsKey(state.currentQuestion.id);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Prev button
          if (state.canGoPrev)
            TextButton.icon(
              onPressed: () => context.read<PlacementTestBloc>().add(
                    const PlacementTestPrevQuestionEvent(),
                  ),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Trước'),
            )
          else
            const SizedBox(width: 80),
          const Spacer(),

          // Answered counter
          Text(
            '${state.answeredCount}/${state.totalQuestions} đã trả lời',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),

          // Next / Submit button
          if (isLast && state.allAnswered)
            FilledButton.icon(
              onPressed: () => _onSubmit(context),
              icon: const Icon(Icons.check_circle_rounded, size: 18),
              label: const Text('Nộp bài'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            )
          else if (!isLast)
            FilledButton(
              onPressed: hasAnsweredCurrent
                  ? () => context.read<PlacementTestBloc>().add(
                        PlacementTestAnswerSelectedEvent(
                          questionId: state.currentQuestion.id,
                          selectedOption:
                              state.answers[state.currentQuestion.id] ?? '',
                        ),
                      )
                  : null,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tiếp'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            )
          else
            FilledButton.icon(
              onPressed: () => _onSubmit(context),
              icon: const Icon(Icons.check_circle_rounded, size: 18),
              label: const Text('Nộp bài'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF4F6AF5),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
        ],
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nộp bài?'),
        content: Text(
          'Bạn đã trả lời ${context.read<PlacementTestBloc>().state is PlacementTestLoaded ? (context.read<PlacementTestBloc>().state as PlacementTestLoaded).answeredCount : 0}'
          '/${state.totalQuestions} câu. Xác nhận nộp bài?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context, true);
              context
                  .read<PlacementTestBloc>()
                  .add(const PlacementTestSubmitEvent());
            },
            child: const Text('Nộp bài'),
          ),
        ],
      ),
    );
  }
}
