import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/review/presentation/bloc/review_bloc.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review'),
        elevation: 0,
      ),
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewInitial || state is ReviewLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReviewError) {
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

          if (state is ReviewCompleted) {
            return _buildCompletedScreen(context, state);
          }

          if (state is ReviewLoaded) {
            if (state.reviewItems.isEmpty) {
              return _buildNoReviewScreen(context);
            }
            return _buildReviewScreen(context, state);
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildReviewScreen(BuildContext context, ReviewLoaded state) {
    final currentItem = state.reviewItems[state.currentIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${state.currentIndex + 1} of ${state.reviewItems.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${state.reviewedToday} reviewed today',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (state.currentIndex + 1) / state.reviewItems.length,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 32),

          // Sentence card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  currentItem.englishText,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                Text(
                  currentItem.vietnameseText,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // How well did you remember?
          Text(
            'How well did you remember?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Quality buttons (0-5)
          _buildQualityButton(
            context,
            quality: 0,
            label: 'Complete blackout',
            color: Colors.red,
            icon: Icons.close,
          ),
          const SizedBox(height: 8),
          _buildQualityButton(
            context,
            quality: 3,
            label: 'Hard (incorrect, but remembered)',
            color: Colors.orange,
            icon: Icons.error_outline,
          ),
          const SizedBox(height: 8),
          _buildQualityButton(
            context,
            quality: 4,
            label: 'Good (correct with hesitation)',
            color: Colors.lightGreen,
            icon: Icons.check_circle_outline,
          ),
          const SizedBox(height: 8),
          _buildQualityButton(
            context,
            quality: 5,
            label: 'Perfect (instant recall)',
            color: Colors.green,
            icon: Icons.check_circle,
          ),
          const SizedBox(height: 24),

          // Skip button
          TextButton(
            onPressed: () {
              context.read<ReviewBloc>().add(const ReviewSkipEvent());
            },
            child: const Text('Skip for now'),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityButton(
    BuildContext context, {
    required int quality,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Get actual sentence ID
          context.read<ReviewBloc>().add(
            ReviewSubmitEvent(
              sentenceId: 'mock-id',
              quality: quality,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoReviewScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
              'All done for today!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No reviews scheduled right now. Come back tomorrow!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedScreen(BuildContext context, ReviewCompleted state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Review Complete!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${state.totalReviewed} sentences reviewed',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber[600]),
                  const SizedBox(width: 12),
                  Text(
                    '+${state.pointsEarned} points earned!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
