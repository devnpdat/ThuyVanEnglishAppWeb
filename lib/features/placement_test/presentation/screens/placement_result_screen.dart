import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/placement_test/data/dtos/placement_test_dto.dart';

/// Màn hình kết quả sau khi hoàn thành bài kiểm tra năng lực
class PlacementResultScreen extends StatelessWidget {
  final PlacementTestResultDto result;

  const PlacementResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final levelInfo = _getLevelInfo(result.resultLevel);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Trophy / Level icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      levelInfo.color.withValues(alpha: 0.8),
                      levelInfo.color,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: levelInfo.color.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    levelInfo.emoji,
                    style: const TextStyle(fontSize: 52),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tiêu đề
              Text(
                'Kết quả bài test',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                levelInfo.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: levelInfo.color,
                    ),
              ),
              const SizedBox(height: 12),

              // Điểm tổng
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: levelInfo.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${result.totalScore}/${result.totalMaxScore} câu đúng',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: levelInfo.color,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  result.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Phase breakdown
              _PhaseBreakdown(result: result),
              const SizedBox(height: 32),

              // CTA buttons
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.go('/'),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Bắt đầu học ngay!'),
                  style: FilledButton.styleFrom(
                    backgroundColor: levelInfo.color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/profile'),
                  icon: const Icon(Icons.person_rounded),
                  label: const Text('Xem hồ sơ của tôi'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _LevelInfo _getLevelInfo(String level) => switch (level) {
        'beginner' => _LevelInfo(
            emoji: '🌱',
            title: 'Beginner',
            color: const Color(0xFF4CAF50),
          ),
        'elementary' => _LevelInfo(
            emoji: '📚',
            title: 'Elementary',
            color: const Color(0xFF2196F3),
          ),
        'intermediate' => _LevelInfo(
            emoji: '⚡',
            title: 'Intermediate',
            color: const Color(0xFF9C27B0),
          ),
        'upper_intermediate' => _LevelInfo(
            emoji: '🚀',
            title: 'Upper-Intermediate',
            color: const Color(0xFFFF9800),
          ),
        'advanced' => _LevelInfo(
            emoji: '🏆',
            title: 'Advanced',
            color: const Color(0xFFF44336),
          ),
        _ => _LevelInfo(
            emoji: '✅',
            title: level,
            color: const Color(0xFF4F6AF5),
          ),
      };
}

// ─── Phase breakdown card ─────────────────────────────────────────────────────

class _PhaseBreakdown extends StatelessWidget {
  final PlacementTestResultDto result;

  const _PhaseBreakdown({required this.result});

  @override
  Widget build(BuildContext context) {
    final phases = [
      ('Phase 1 — Beginner', result.phase1Score, result.phase1MaxScore, const Color(0xFF4CAF50)),
      ('Phase 2 — Elementary', result.phase2Score, result.phase2MaxScore, const Color(0xFF2196F3)),
      ('Phase 3 — Intermediate', result.phase3Score, result.phase3MaxScore, const Color(0xFF9C27B0)),
      ('Phase 4 — Upper-Int.', result.phase4Score, result.phase4MaxScore, const Color(0xFFFF9800)),
      ('Phase 5 — Advanced', result.phase5Score, result.phase5MaxScore, const Color(0xFFF44336)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết từng cấp độ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          ...phases.map((p) => _PhaseRow(
                label: p.$1,
                score: p.$2,
                max: p.$3,
                color: p.$4,
              )),
        ],
      ),
    );
  }
}

class _PhaseRow extends StatelessWidget {
  final String label;
  final int score;
  final int max;
  final Color color;

  const _PhaseRow({
    required this.label,
    required this.score,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = max > 0 ? score / max : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A5568),
                ),
              ),
              Text(
                '$score/$max',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: color.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Internal model ───────────────────────────────────────────────────────────

class _LevelInfo {
  final String emoji;
  final String title;
  final Color color;

  const _LevelInfo({
    required this.emoji,
    required this.title,
    required this.color,
  });
}
