import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/daily_learning_bloc.dart';
import 'package:english_learning_app/features/learning/data/dtos/daily_learning_dto.dart';
import 'package:english_learning_app/core/services/audio_service.dart';
import 'package:english_learning_app/core/di/service_locator.dart';
import 'package:english_learning_app/features/learning/data/dtos/sentence_dto.dart';

class SentenceStudyScreen extends StatefulWidget {
  final String sentenceId;
  const SentenceStudyScreen({Key? key, required this.sentenceId}) : super(key: key);

  @override
  State<SentenceStudyScreen> createState() => _SentenceStudyScreenState();
}

class _SentenceStudyScreenState extends State<SentenceStudyScreen> {
  final _typingController = TextEditingController();
  final _quizController   = TextEditingController();

  int  _currentStep    = 0; // 0:Nghe 1:Gõ 2:Quiz 3:Xong
  bool _isPlaying      = false;
  int  _audioPlayCount = 0;
  late AudioService _audioService;

  // ── Auto-repeat settings ──────────────────────────────────────────────────
  bool   _autoRepeat     = false;
  double _repeatInterval = 2.0; // giây giữa 2 lần đọc
  Timer? _repeatTimer;

  // ── Quiz state ────────────────────────────────────────────────────────────
  final _quizStartTime = DateTime.now();
  int?  _pointsAwarded;
  bool  _quizAnswered  = false;
  bool  _quizCorrect   = false;

  // ── Sentence cache để dùng trong timer ───────────────────────────────────
  SentenceDto? _cachedSentence;

  @override
  void initState() {
    super.initState();
    _audioService = getIt<AudioService>();
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _typingController.dispose();
    _quizController.dispose();
    super.dispose();
  }

  // ── Audio helpers ─────────────────────────────────────────────────────────

  Future<void> _playAudio(String audioUrl, String text) async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    try {
      if (audioUrl.isNotEmpty) {
        await _audioService.playAudioUrl(audioUrl);
      } else {
        await _audioService.speak(text, language: 'en-US');
      }
      if (!mounted) return;
      setState(() => _audioPlayCount++);
      context.read<DailyLearningBloc>().add(
        DailyLearningEvent.audioPlayed(widget.sentenceId),
      );
    } catch (e) {
      debugPrint('Audio error: $e');
    } finally {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  void _startAutoRepeat() {
    _repeatTimer?.cancel();
    if (_cachedSentence == null) return;
    final sentence = _cachedSentence!;
    _repeatTimer = Timer.periodic(
      Duration(milliseconds: (_repeatInterval * 1000).round()),
      (_) {
        if (!_autoRepeat || !mounted) {
          _repeatTimer?.cancel();
          return;
        }
        _playAudio(sentence.audioUrl ?? '', sentence.englishText);
      },
    );
  }

  void _toggleAutoRepeat() {
    setState(() => _autoRepeat = !_autoRepeat);
    if (_autoRepeat) {
      _startAutoRepeat();
    } else {
      _repeatTimer?.cancel();
    }
  }

  // ── Step navigation ───────────────────────────────────────────────────────

  void _goToStep(int step) {
    _repeatTimer?.cancel();
    setState(() {
      _autoRepeat  = false;
      _currentStep = step;
    });
    // Không auto-play — user tự bấm nút loa
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyLearningBloc, DailyLearningState>(
      listener: (context, state) {
        state.maybeWhen(
          typingResult: (result, _) {
            if (result.isCorrect || result.canProceedToQuiz) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✅ Chính xác! Tiếp tục nào!'),
                  backgroundColor: Colors.green[700],
                  duration: const Duration(seconds: 1),
                ),
              );
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) setState(() => _currentStep = 2);
              });
            }
          },
          quizResult: (result, _) {
            setState(() {
              _quizAnswered = true;
              _quizCorrect  = result.isCorrect;
            });
            if (result.canComplete) {
              Future.delayed(const Duration(milliseconds: 1200), () {
                if (mounted) {
                  context.read<DailyLearningBloc>().add(
                    DailyLearningEvent.completeSession(widget.sentenceId),
                  );
                }
              });
            }
          },
          completeResult: (result, _) {
            if (result.success) {
              setState(() {
                _currentStep  = 3;
                _pointsAwarded = result.pointsAwarded;
              });
            } else if (result.unmetConditions.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('⚠️ ${result.unmetConditions.join(', ')}'),
                  backgroundColor: Colors.orange[700],
                ),
              );
            }
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final currentLearning = state.maybeWhen(
          loaded:        (data) => data,
          typingResult:  (_, data) => data,
          quizResult:    (_, data) => data,
          completeResult:(_, data) => data,
          orElse: () => null,
        );
        if (currentLearning == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        LearningSessionItemDto? item;
        try {
          item = currentLearning.items.firstWhere(
            (i) => i.sentence.id == widget.sentenceId,
          );
        } catch (_) {}
        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Study Session')),
            body: const Center(child: Text('Không tìm thấy câu.')),
          );
        }

        final sentence = item.sentence;
        _cachedSentence ??= sentence; // cache để timer dùng

        // Không auto-play — user tự bấm nút loa

        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Study Session'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / 4,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildStepRow(),
                      const SizedBox(height: 24),
                      Expanded(
                        child: _buildStepContent(sentence, state),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  // ── Step indicator ────────────────────────────────────────────────────────

  Widget _buildStepRow() {
    final steps = ['🔊 Nghe', '⌨️ Gõ', '📝 Quiz', '🌟 Xong'];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: _currentStep > i ~/ 2 ? Colors.green : Colors.grey.shade300,
            ),
          );
        }
        final idx     = i ~/ 2;
        final isActive = _currentStep == idx;
        final isDone   = _currentStep > idx;
        return Column(children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: isDone
                ? Colors.green
                : isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text('${idx + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    )),
          ),
          const SizedBox(height: 2),
          Text(steps[idx],
              style: TextStyle(
                fontSize: 9,
                color: isDone
                    ? Colors.green
                    : isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              )),
        ]);
      }),
    );
  }

  Widget _buildStepContent(SentenceDto sentence, DailyLearningState state) {
    switch (_currentStep) {
      case 0: return _buildListenStep(sentence);
      case 1: return _buildTypeStep(sentence, state);
      case 2: return _buildQuizStep(sentence, state);
      case 3: return _buildCompleteStep();
      default: return const SizedBox();
    }
  }

  // ── Step 0: Nghe ──────────────────────────────────────────────────────────

  Widget _buildListenStep(SentenceDto sentence) {
    final imageUrl = sentence.imageUrl;
    final audioUrl = sentence.audioUrl ?? '';

    return SingleChildScrollView(
      child: Column(
        children: [
          // Ảnh minh hoạ câu
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
              ),
            )
          else
            _buildImagePlaceholder(),

          const SizedBox(height: 20),

          // Nghĩa tiếng Việt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              sentence.vietnameseText.isNotEmpty
                  ? sentence.vietnameseText
                  : '(Không có bản dịch)',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey, height: 1.4),
            ),
          ),

          const SizedBox(height: 24),

          // Nút phát audio
          GestureDetector(
            onTap: () => _playAudio(audioUrl, sentence.englishText),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: _isPlaying ? Colors.blue.shade200 : Colors.blue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.graphic_eq : Icons.volume_up,
                color: Colors.white, size: 36,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _audioPlayCount == 0 ? 'Tự động đọc...' : 'Đã nghe $_audioPlayCount lần',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),

          if (_audioPlayCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              sentence.englishText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blueGrey),
            ),
          ],

          const SizedBox(height: 20),

          // ── Auto-repeat controls ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tự động đọc lại', style: TextStyle(fontWeight: FontWeight.w500)),
                    Switch(
                      value: _autoRepeat,
                      onChanged: (_) => _toggleAutoRepeat(),
                    ),
                  ],
                ),
                if (_autoRepeat) ...[
                  Row(
                    children: [
                      Text(
                        'Khoảng cách: ${_repeatInterval.toStringAsFixed(1)}s',
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  Slider(
                    value: _repeatInterval,
                    min: 0.5, max: 10.0, divisions: 19,
                    label: '${_repeatInterval.toStringAsFixed(1)}s',
                    onChanged: (v) {
                      setState(() => _repeatInterval = v);
                      if (_autoRepeat) _startAutoRepeat(); // reset timer
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: _audioPlayCount > 0
                ? () => setState(() => _currentStep = 1)
                : null,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Tiếp tục → Bước Gõ'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          if (_audioPlayCount == 0)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Đang phát tự động...', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.indigo.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 48, color: Colors.blue.shade300),
          const SizedBox(height: 8),
          Text('Chưa có ảnh minh hoạ',
              style: TextStyle(color: Colors.blue.shade400, fontSize: 13)),
        ],
      ),
    );
  }

  // ── Step 1: Gõ ───────────────────────────────────────────────────────────

  Widget _buildTypeStep(SentenceDto sentence, DailyLearningState state) {
    final lastResult = state.maybeWhen(
      typingResult: (res, _) => res,
      orElse: () => null,
    );
    final audioUrl = sentence.audioUrl ?? '';

    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Gõ lại câu tiếng Anh bạn vừa nghe:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            IconButton(
              icon: Icon(_isPlaying ? Icons.stop : Icons.replay),
              color: Colors.blue,
              onPressed: () => _playAudio(audioUrl, sentence.englishText),
              tooltip: 'Nghe lại',
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Diff feedback
        if (lastResult != null && !lastResult.isCorrect && lastResult.diffSegments.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gần đúng! (${lastResult.totalCorrectTypings} lần đúng)',
                  style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 2, runSpacing: 2,
                  children: lastResult.diffSegments.map((seg) {
                    Color color;
                    TextDecoration deco = TextDecoration.none;
                    switch (seg.type) {
                      case 'wrong':
                      case 'extra':
                        color = Colors.red;
                        deco  = TextDecoration.lineThrough;
                        break;
                      case 'missing':
                        color = Colors.orange;
                        break;
                      default:
                        color = Colors.green[700]!;
                    }
                    return Text(seg.text,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          decoration: deco,
                        ));
                  }).toList(),
                ),
              ],
            ),
          ),

        // Input — Enter xuống dòng, Shift+Enter submit (hoặc dùng nút)
        TextField(
          controller: _typingController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Nhập câu tiếng Anh...\n(Enter = xuống dòng, nhấn Kiểm tra để nộp)',
            hintMaxLines: 2,
            suffixIcon: _typingController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _typingController.clear()),
                  )
                : null,
          ),
          maxLines: 4,
          minLines: 2,
          onChanged: (_) => setState(() {}),
          // Enter = newline, không submit
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: 8),

        if (lastResult != null)
          Text(
            'Số lần gõ đúng: ${lastResult.totalCorrectTypings}/3',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),

        const Spacer(),
        ElevatedButton.icon(
          onPressed: _typingController.text.trim().isEmpty
              ? null
              : () {
                  context.read<DailyLearningBloc>().add(
                    DailyLearningEvent.typingAttempt(
                      widget.sentenceId,
                      _typingController.text.trim(),
                    ),
                  );
                },
          icon: const Icon(Icons.check),
          label: const Text('Kiểm tra'),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
        ),
      ],
    );
  }

  // ── Step 2: Quiz ──────────────────────────────────────────────────────────

  Widget _buildQuizStep(SentenceDto sentence, DailyLearningState state) {
    final quizResult = state.maybeWhen(
      quizResult: (res, _) => res,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Column(
            children: [
              Icon(Icons.quiz, color: Colors.orange, size: 32),
              SizedBox(height: 8),
              Text('Quiz nhanh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Dịch câu tiếng Việt sang tiếng Anh:',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            sentence.vietnameseText.isNotEmpty ? sentence.vietnameseText : sentence.englishText,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
          ),
        ),
        const SizedBox(height: 16),

        if (!_quizAnswered) ...[
          TextField(
            controller: _quizController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nhập bản dịch tiếng Anh...',
              labelText: 'Câu trả lời',
            ),
            maxLines: 3,
            minLines: 2,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
        ],

        if (_quizAnswered && quizResult != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _quizCorrect ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _quizCorrect ? Colors.green.shade300 : Colors.red.shade300,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Icon(
                    _quizCorrect ? Icons.check_circle : Icons.cancel,
                    color: _quizCorrect ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _quizCorrect ? 'Chính xác! 🎉' : 'Chưa đúng',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _quizCorrect ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                ]),
                const SizedBox(height: 6),
                Text(quizResult.feedback, style: const TextStyle(fontSize: 13)),
                if (!_quizCorrect) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Đáp án đúng: ${sentence.englishText}',
                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),

        const Spacer(),

        if (!_quizAnswered)
          ElevatedButton.icon(
            onPressed: _quizController.text.trim().isEmpty
                ? null
                : () {
                    final answer   = _quizController.text.trim();
                    final isCorrect = answer.toLowerCase() == sentence.englishText.toLowerCase();
                    final timeMs   = DateTime.now().difference(_quizStartTime).inMilliseconds;
                    context.read<DailyLearningBloc>().add(
                      DailyLearningEvent.quizSubmit(widget.sentenceId, isCorrect, answer, timeMs),
                    );
                  },
            icon: const Icon(Icons.send),
            label: const Text('Nộp câu trả lời'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          )
        else if (!_quizCorrect)
          ElevatedButton.icon(
            onPressed: () {
              final timeMs = DateTime.now().difference(_quizStartTime).inMilliseconds;
              context.read<DailyLearningBloc>().add(
                DailyLearningEvent.quizSubmit(widget.sentenceId, false, _quizController.text.trim(), timeMs),
              );
            },
            icon: const Icon(Icons.skip_next),
            label: const Text('Tiếp tục (bỏ qua)'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.orange,
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 2),
                SizedBox(width: 12),
                Text('Đang hoàn thành...'),
              ],
            ),
          ),
      ],
    );
  }

  // ── Step 3: Xong ─────────────────────────────────────────────────────────

  Widget _buildCompleteStep() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.star, size: 80, color: Colors.amber),
        const SizedBox(height: 16),
        const Text('🎉 Hoàn thành xuất sắc!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        const Text('Bạn đã hoàn thành việc học câu này.'),
        if (_pointsAwarded != null && _pointsAwarded! > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber),
            ),
            child: Text('+$_pointsAwarded điểm 🌟',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
          ),
        ],
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          label: const Text('Quay lại danh sách'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
