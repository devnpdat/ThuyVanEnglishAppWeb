import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/quiz/presentation/bloc/quiz_bloc.dart';

class QuizScreen extends StatelessWidget {
  final String? sentenceId;
  final String quizType;

  const QuizScreen({
    Key? key,
    this.sentenceId,
    this.quizType = 'daily',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        elevation: 0,
      ),
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizInitial || state is QuizLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is QuizError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (state is QuizCompleted) {
            return _buildCompletedScreen(context, state);
          }

          if (state is QuizLoaded) {
            return _buildQuizScreen(context, state);
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildQuizScreen(BuildContext context, QuizLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${state.currentQuestion} of ${state.totalQuestions}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${((state.currentQuestion / state.totalQuestions) * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.currentQuestion / state.totalQuestions,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 32),

          // Question
          Text(
            state.question,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // Options
          ...List.generate(
            state.options.length,
            (index) => _buildOptionButton(
              context,
              index,
              state.options[index],
              state.selectedOptionIndex,
              state.isAnswered,
              state.isCorrect,
              state.correctIndex,
            ),
          ),
          const SizedBox(height: 24),

          // Feedback (shown after answer)
          if (state.isAnswered) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: state.isCorrect
                    ? Colors.green[50]
                    : Colors.red[50],
                border: Border.all(
                  color: state.isCorrect
                      ? Colors.green[300]!
                      : Colors.red[300]!,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        state.isCorrect
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: state.isCorrect
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        state.isCorrect ? 'Correct!' : 'Incorrect',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: state.isCorrect
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(state.explanation),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<QuizBloc>().add(const QuizNextEvent());
                },
                child: const Text('Next Question'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context,
    int index,
    String option,
    int? selectedIndex,
    bool isAnswered,
    bool isCorrect,
    int correctIndex,
  ) {
    final isSelected = selectedIndex == index;
    final isCorrectOption = index == correctIndex;

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;

    if (isAnswered && isSelected) {
      backgroundColor = isCorrect ? Colors.green[50]! : Colors.red[50]!;
      borderColor = isCorrect ? Colors.green : Colors.red;
    } else if (isAnswered && isCorrectOption && !isCorrect) {
      backgroundColor = Colors.green[50]!;
      borderColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isAnswered
              ? null
              : () {
                  context.read<QuizBloc>().add(
                    QuizSubmitAnswerEvent(
                      isCorrect: isCorrectOption,
                      userAnswer: option,
                      selectedOptionIndex: index,
                    ),
                  );
                },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: borderColor,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? borderColor
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      String.fromCharCode(65 + index),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    option,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (isAnswered && isSelected)
                  Icon(
                    isCorrect ? Icons.check : Icons.close,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedScreen(
    BuildContext context,
    QuizCompleted state,
  ) {
    final percentage = (state.correctCount / state.totalCount * 100).toInt();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.celebration,
              size: 64,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Quiz Completed!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${state.correctCount} out of ${state.totalCount} correct',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: Colors.amber[600]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '+${state.scoreAwarded} points earned!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Lessons'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
