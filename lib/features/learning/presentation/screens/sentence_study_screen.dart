import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/daily_learning_bloc.dart';
import 'package:english_learning_app/features/learning/data/dtos/daily_learning_dto.dart';
import 'package:english_learning_app/core/services/audio_service_interface.dart';
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
  late IAudioService _audioService;

  // ── Typing time tracking ──────────────────────────────────────────────────
  DateTime? _typingStartTime;

  // ── Auto-repeat settings ──────────────────────────────────────────────────
  bool   _autoRepeat     = false;
  double _repeatInterval = 2.0;
  Timer? _repeatTimer;

  // ── Audio speed ───────────────────────────────────────────────────────────
  double _ttsSpeed = 0.85;

  // ── Quiz state ────────────────────────────────────────────────────────────
  final _quizStartTime = DateTime.now();
  int?  _pointsAwarded;
  bool  _quizAnswered  = false;
  bool  _quizCorrect   = false;
  bool  _quizPassed    = false;   // true: làm đúng, false: bỏ qua

  // ── Sentence cache ────────────────────────────────────────────────────────
  SentenceDto? _cachedSentence;

  @override
  void initState() {
    super.initState();
    _audioService = getIt<IAudioService>();
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _typingController.dispose();
    _quizController.dispose();
    super.dispose();
  }

  // ── Sanitize: bỏ dấu câu, trim, lowercase trước khi so khớp ────────────────
  // Bug 7 fix: gõ đúng từ nhưng thiếu dấu phẩy/chấm vẫn được tính đúng
  // Normalize NFC/NFD về chung 1 dạng để so sánh tiếng Việt chính xác
  String _sanitize(String s) {
    // Bước 1: xoá dấu câu và ký tự đặc biệt
    var r = s
        .replaceAll(RegExp(r"[,.!?;:\-()\[\]{}']"), '')
        .replaceAll('"', '')
        // Xoá unicode quotes/dashes thật (không phải escape sai)
        .replaceAll('\u2013', '').replaceAll('\u2014', '')
        .replaceAll('\u201c', '').replaceAll('\u201d', '')
        .replaceAll('\u2018', '').replaceAll('\u2019', '');
    // Bước 2: chuẩn hoá whitespace (fix: dùng r'\s+' thay vì r'\\s+')
    r = r.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();
    // Bước 3: normalise NFC/NFD → chuyển về NFD để so sánh đồng nhất
    // Tiếng Việt có thể lưu 'à' dạng NFC (1 code point) hoặc 'a'+dấu huyền (2 CP)
    // Cả 2 đều decompose về 'a\u0300', so sánh chuẩn
    return _toNfd(r);
  }

  /// Chuyển pre-composed Vietnamese characters về NFD (decomposed form)
  /// để so sánh NFC và NFD đồng nhất. Chỉ xử lý ký tự tiếng Việt phổ biến.
  String _toNfd(String s) {
    // Latin-1 Supplement: các chữ có dấu cơ bản
    return s
        // A
        .replaceAll('\u00C0', 'A\u0300').replaceAll('\u00E0', 'a\u0300')
        .replaceAll('\u00C1', 'A\u0301').replaceAll('\u00E1', 'a\u0301')
        .replaceAll('\u00C2', 'A\u0302').replaceAll('\u00E2', 'a\u0302')
        .replaceAll('\u00C3', 'A\u0303').replaceAll('\u00E3', 'a\u0303')
        // E
        .replaceAll('\u00C8', 'E\u0300').replaceAll('\u00E8', 'e\u0300')
        .replaceAll('\u00C9', 'E\u0301').replaceAll('\u00E9', 'e\u0301')
        .replaceAll('\u00CA', 'E\u0302').replaceAll('\u00EA', 'e\u0302')
        .replaceAll('\u00CB', 'E\u0308').replaceAll('\u00EB', 'e\u0308')
        // I
        .replaceAll('\u00CC', 'I\u0300').replaceAll('\u00EC', 'i\u0300')
        .replaceAll('\u00CD', 'I\u0301').replaceAll('\u00ED', 'i\u0301')
        .replaceAll('\u00CE', 'I\u0302').replaceAll('\u00EE', 'i\u0302')
        // O
        .replaceAll('\u00D2', 'O\u0300').replaceAll('\u00F2', 'o\u0300')
        .replaceAll('\u00D3', 'O\u0301').replaceAll('\u00F3', 'o\u0301')
        .replaceAll('\u00D4', 'O\u0302').replaceAll('\u00F4', 'o\u0302')
        .replaceAll('\u00D5', 'O\u0303').replaceAll('\u00F5', 'o\u0303')
        // U
        .replaceAll('\u00D9', 'U\u0300').replaceAll('\u00F9', 'u\u0300')
        .replaceAll('\u00DA', 'U\u0301').replaceAll('\u00FA', 'u\u0301')
        .replaceAll('\u00DB', 'U\u0302').replaceAll('\u00FB', 'u\u0302')
        // Y
        .replaceAll('\u00DD', 'Y\u0301').replaceAll('\u00FD', 'y\u0301')
        .replaceAll('\u0178', 'Y\u0308').replaceAll('\u00FF', 'y\u0308')
        // Ă/ă, Â/â, Đ/đ, Ê/ê, Ô/ô, Ơ/ơ, Ư/ư
        .replaceAll('\u0102', 'A\u0306').replaceAll('\u0103', 'a\u0306')
        .replaceAll('\u00C2', 'A\u0302').replaceAll('\u00E2', 'a\u0302')
        .replaceAll('\u0110', 'D\u0301').replaceAll('\u0111', 'd\u0301')
        .replaceAll('\u00CA', 'E\u0302').replaceAll('\u00EA', 'e\u0302')
        .replaceAll('\u00D4', 'O\u0302').replaceAll('\u00F4', 'o\u0302')
        .replaceAll('\u01A0', 'O\u031B').replaceAll('\u01A1', 'o\u031B')
        .replaceAll('\u01AF', 'U\u031B').replaceAll('\u01B0', 'u\u031B')
        // Latin Extended Additional: chữ việt có dấu kép (A+circumflex+grave...)
        .replaceAll('\u1EA0', 'a\u0323').replaceAll('\u1EA1', 'a\u0323')
        .replaceAll('\u1EA2', 'a\u0309').replaceAll('\u1EA3', 'a\u0309')
        .replaceAll('\u1EA4', 'a\u0302\u0301').replaceAll('\u1EA5', 'a\u0302\u0301')
        .replaceAll('\u1EA6', 'a\u0302\u0300').replaceAll('\u1EA7', 'a\u0302\u0300')
        .replaceAll('\u1EA8', 'a\u0302\u0309').replaceAll('\u1EA9', 'a\u0302\u0309')
        .replaceAll('\u1EAA', 'a\u0302\u0303').replaceAll('\u1EAB', 'a\u0302\u0303')
        .replaceAll('\u1EAC', 'a\u0302\u0323').replaceAll('\u1EAD', 'a\u0302\u0323')
        .replaceAll('\u1EAE', 'a\u0306\u0301').replaceAll('\u1EAF', 'a\u0306\u0301')
        .replaceAll('\u1EB0', 'a\u0306\u0300').replaceAll('\u1EB1', 'a\u0306\u0300')
        .replaceAll('\u1EB2', 'a\u0306\u0309').replaceAll('\u1EB3', 'a\u0306\u0309')
        .replaceAll('\u1EB4', 'a\u0306\u0303').replaceAll('\u1EB5', 'a\u0306\u0303')
        .replaceAll('\u1EB6', 'a\u0306\u0323').replaceAll('\u1EB7', 'a\u0306\u0323')
        // E dấu kép
        .replaceAll('\u1EB8', 'e\u0323').replaceAll('\u1EB9', 'e\u0323')
        .replaceAll('\u1EBA', 'e\u0309').replaceAll('\u1EBB', 'e\u0309')
        .replaceAll('\u1EBC', 'e\u0303').replaceAll('\u1EBD', 'e\u0303')
        .replaceAll('\u1EBE', 'e\u0302\u0301').replaceAll('\u1EBF', 'e\u0302\u0301')
        .replaceAll('\u1EC0', 'e\u0302\u0300').replaceAll('\u1EC1', 'e\u0302\u0300')
        .replaceAll('\u1EC2', 'e\u0302\u0309').replaceAll('\u1EC3', 'e\u0302\u0309')
        .replaceAll('\u1EC4', 'e\u0302\u0303').replaceAll('\u1EC5', 'e\u0302\u0303')
        .replaceAll('\u1EC6', 'e\u0302\u0323').replaceAll('\u1EC7', 'e\u0302\u0323')
        // I
        .replaceAll('\u1EC8', 'i\u0309').replaceAll('\u1EC9', 'i\u0309')
        .replaceAll('\u1ECA', 'i\u0323').replaceAll('\u1ECB', 'i\u0323')
        // O dấu kép
        .replaceAll('\u1ECC', 'o\u0323').replaceAll('\u1ECD', 'o\u0323')
        .replaceAll('\u1ECE', 'o\u0309').replaceAll('\u1ECF', 'o\u0309')
        .replaceAll('\u1ED0', 'o\u0302\u0301').replaceAll('\u1ED1', 'o\u0302\u0301')
        .replaceAll('\u1ED2', 'o\u0302\u0300').replaceAll('\u1ED3', 'o\u0302\u0300')
        .replaceAll('\u1ED4', 'o\u0302\u0309').replaceAll('\u1ED5', 'o\u0302\u0309')
        .replaceAll('\u1ED6', 'o\u0302\u0303').replaceAll('\u1ED7', 'o\u0302\u0303')
        .replaceAll('\u1ED8', 'o\u0302\u0323').replaceAll('\u1ED9', 'o\u0302\u0323')
        .replaceAll('\u1EDA', 'o\u031B\u0301').replaceAll('\u1EDB', 'o\u031B\u0301')
        .replaceAll('\u1EDC', 'o\u031B\u0300').replaceAll('\u1EDD', 'o\u031B\u0300')
        .replaceAll('\u1EDE', 'o\u031B\u0309').replaceAll('\u1EDF', 'o\u031B\u0309')
        .replaceAll('\u1EE0', 'o\u031B\u0303').replaceAll('\u1EE1', 'o\u031B\u0303')
        .replaceAll('\u1EE2', 'o\u031B\u0323').replaceAll('\u1EE3', 'o\u031B\u0323')
        // U dấu kép
        .replaceAll('\u1EE4', 'u\u0323').replaceAll('\u1EE5', 'u\u0323')
        .replaceAll('\u1EE6', 'u\u0309').replaceAll('\u1EE7', 'u\u0309')
        .replaceAll('\u1EE8', 'u\u031B\u0301').replaceAll('\u1EE9', 'u\u031B\u0301')
        .replaceAll('\u1EEA', 'u\u031B\u0300').replaceAll('\u1EEB', 'u\u031B\u0300')
        .replaceAll('\u1EEC', 'u\u031B\u0309').replaceAll('\u1EED', 'u\u031B\u0309')
        .replaceAll('\u1EEE', 'u\u031B\u0303').replaceAll('\u1EEF', 'u\u031B\u0303')
        .replaceAll('\u1EF0', 'u\u031B\u0323').replaceAll('\u1EF1', 'u\u031B\u0323')
        // Y
        .replaceAll('\u1EF2', 'y\u0300').replaceAll('\u1EF3', 'y\u0300')
        .replaceAll('\u1EF4', 'y\u0323').replaceAll('\u1EF5', 'y\u0323')
        .replaceAll('\u1EF6', 'y\u0309').replaceAll('\u1EF7', 'y\u0309')
        .replaceAll('\u1EF8', 'y\u0303').replaceAll('\u1EF9', 'y\u0303');
  }

  // ── Audio helpers ─────────────────────────────────────────────────────────

  Future<void> _playAudio(String audioUrl, String text) async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    try {
      if (audioUrl.isNotEmpty) {
        await _audioService.playAudioUrl(audioUrl);
      } else {
        await _audioService.speak(text, language: 'en-US', speed: _ttsSpeed);
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

  void _goBackStep() {
    setState(() {
      final prevStep = _currentStep - 1;
      if (prevStep == 2) {
        // Quay lại Quiz → reset quiz state để user làm lại
        _quizAnswered = false;
        _quizCorrect  = false;
        _quizController.clear();
      } else if (prevStep == 1) {
        // Quay lại Gõ → reset typing
        _typingController.clear();
      }
      _currentStep = prevStep;
    });
  }

  void _toggleAutoRepeat() {
    setState(() => _autoRepeat = !_autoRepeat);
    if (_autoRepeat) {
      _startAutoRepeat();
    } else {
      _repeatTimer?.cancel();
    }
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
                  content: const Text('Chính xác! Tiếp tục nào!'),
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
              if (result.isCorrect) _quizPassed = true;
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
                _currentStep   = 3;
                _pointsAwarded = result.pointsAwarded;
              });
            } else {
              // Catch-all: mọi trường hợp success=false (kể cả unmetConditions rỗng)
              // đều cho qua bước Xong để không treo spinner
              setState(() {
                _currentStep   = 3;
                _pointsAwarded = result.pointsAwarded > 0 ? result.pointsAwarded : 0;
              });
            }
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final currentLearning = state.maybeWhen(
          loaded:         (data) => data,
          typingResult:   (_, data) => data,
          quizResult:     (_, data) => data,
          completeResult: (_, data) => data,
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
            appBar: AppBar(title: const Text('Học câu')),
            body: const Center(child: Text('Không tìm thấy câu.')),
          );
        }

        final sentence = item.sentence;
        _cachedSentence ??= sentence;

        final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

        return PopScope(
          canPop: _currentStep == 0,  // chỉ pop ra ngoài khi đang ở bước Nghe
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop && _currentStep > 0) {
              _goBackStep();
            }
          },
          child: Scaffold(
          appBar: AppBar(
            title: const Text('Học câu'),
            leading: _currentStep > 0
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _goBackStep,
                  )
                : null,
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
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildStepRow(),
                      const SizedBox(height: 20),
                      Expanded(
                        child: _buildStepContent(sentence, state),
                      ),
                    ],
                  ),
                ),
        ),  // end Scaffold
        );  // end PopScope
      },
    );
  }

  // ── Step indicator ────────────────────────────────────────────────────────

  Widget _buildStepRow() {
    final steps = ['Nghe', 'Gõ', 'Quiz', 'Xong'];
    final icons = [Icons.volume_up, Icons.keyboard, Icons.quiz, Icons.star];
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: _currentStep > i ~/ 2
                  ? const Color(0xFF4F6AF5)
                  : Colors.grey.shade200,
            ),
          );
        }
        final idx      = i ~/ 2;
        final isActive = _currentStep == idx;
        final isDone   = _currentStep > idx;
        // Bug 4: click vào circle đã done → quay lại bước đó
        final canGoBack = isDone && idx < _currentStep;
        return GestureDetector(
          onTap: canGoBack ? () => setState(() => _currentStep = idx) : null,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: isDone
                  ? Colors.green
                  : isActive
                      ? const Color(0xFF4F6AF5)
                      : Colors.grey.shade200,
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Icon(
                      icons[idx],
                      size: 14,
                      color: isActive ? Colors.white : Colors.grey[500],
                    ),
            ),
            const SizedBox(height: 3),
            Text(
              steps[idx],
              style: TextStyle(
                fontSize: 10,
                color: isDone
                    ? Colors.green
                    : isActive
                        ? const Color(0xFF4F6AF5)
                        : Colors.grey[400],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ảnh minh hoạ
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),
          ),
        ),

        const SizedBox(height: 12),

        // Nghĩa tiếng Việt
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF4F6AF5).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4F6AF5).withValues(alpha: 0.2)),
          ),
          child: Text(
            sentence.vietnameseText.isNotEmpty
                ? sentence.vietnameseText
                : '(Không có bản dịch)',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Nút phát + đã nghe mấy lần
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => _playAudio(audioUrl, sentence.englishText),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: _isPlaying ? Colors.blue.shade300 : const Color(0xFF4F6AF5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F6AF5).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isPlaying ? Icons.graphic_eq : Icons.volume_up,
                  color: Colors.white, size: 30,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _audioPlayCount == 0 ? 'Bấm để nghe' : 'Đã nghe $_audioPlayCount lần',
                  style: TextStyle(
                    color: _audioPlayCount == 0 ? Colors.grey[500] : const Color(0xFF4F6AF5),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (_audioPlayCount > 0)
                  Text(
                    sentence.englishText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Auto-repeat
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.loop, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  const Text('Tự động đọc lại',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  Switch(
                    value: _autoRepeat,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (_) => _toggleAutoRepeat(),
                  ),
                ],
              ),
              if (_autoRepeat) ...[
                Row(
                  children: [
                    Text(
                      'Khoảng cách: ${_repeatInterval.toStringAsFixed(1)}s',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                Slider(
                  value: _repeatInterval,
                  min: 0.5, max: 10.0, divisions: 19,
                  label: '${_repeatInterval.toStringAsFixed(1)}s',
                  onChanged: (v) {
                    setState(() => _repeatInterval = v);
                    if (_autoRepeat) _startAutoRepeat();
                  },
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 12),

        ElevatedButton.icon(
          onPressed: _audioPlayCount > 0
              ? () => setState(() {
                    _currentStep = 1;
                    _typingStartTime = DateTime.now();
                  })
              : null,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Tiếp tục → Bước Gõ'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.indigo.shade50],
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
    final imageUrl = sentence.imageUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ảnh nhỏ + header + replay trong 1 Row
        if (imageUrl != null && imageUrl.isNotEmpty)
          SizedBox(
            height: 80,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.image_outlined, color: Colors.blue.shade300),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Gõ lại câu tiếng Anh bạn vừa nghe:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                // Replay icon gom vào đây
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.stop_circle_outlined : Icons.replay,
                    color: const Color(0xFF4F6AF5),
                    size: 28,
                  ),
                  onPressed: () => _playAudio(audioUrl, sentence.englishText),
                  tooltip: 'Nghe lại',
                ),
              ],
            ),
          )
        else
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Gõ lại câu tiếng Anh bạn vừa nghe:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: Icon(
                  _isPlaying ? Icons.stop_circle_outlined : Icons.replay,
                  color: const Color(0xFF4F6AF5),
                  size: 28,
                ),
                onPressed: () => _playAudio(audioUrl, sentence.englishText),
                tooltip: 'Nghe lại',
              ),
            ],
          ),

        const SizedBox(height: 10),

        // ── Audio controls box ─────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            // Dark-mode safe: dùng Theme color thay vì hard-code blue.shade50
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.blue.shade100,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.speed, size: 16, color: Color(0xFF4F6AF5)),
                  const SizedBox(width: 6),
                  Text(
                    'Tốc độ: ${_ttsSpeed.toStringAsFixed(2)}x',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  const Text('Lặp', style: TextStyle(fontSize: 12)),
                  Switch(
                    value: _autoRepeat,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (_) => _toggleAutoRepeat(),
                  ),
                ],
              ),
              Slider(
                value: _ttsSpeed,
                min: 0.5, max: 1.5, divisions: 10,
                label: '${_ttsSpeed.toStringAsFixed(2)}x',
                onChanged: (v) {
                  setState(() => _ttsSpeed = v);
                  (_audioService as dynamic).setTtsSpeed?.call(v);
                },
              ),
              if (_autoRepeat) ...[
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF4F6AF5)),
                    const SizedBox(width: 6),
                    Text(
                      'Khoảng cách: ${_repeatInterval.toStringAsFixed(1)}s',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Slider(
                  value: _repeatInterval,
                  min: 0.5, max: 10.0, divisions: 19,
                  label: '${_repeatInterval.toStringAsFixed(1)}s',
                  onChanged: (v) {
                    setState(() => _repeatInterval = v);
                    if (_autoRepeat) _startAutoRepeat();
                  },
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Diff feedback — hiện khi sai hoặc gần đúng
        if (lastResult != null && !lastResult.isCorrect && lastResult.diffSegments.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: lastResult.isNearlyCorrect ? Colors.orange.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: lastResult.isNearlyCorrect ? Colors.orange.shade300 : Colors.red.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lastResult.isNearlyCorrect
                      ? 'Gần đúng rồi! Xem câu đúng bên dưới, phần gạch chân là chỗ cần sửa:'
                      : 'Sai rồi! Câu đúng là:',
                  style: TextStyle(
                    color: lastResult.isNearlyCorrect ? Colors.orange[800] : Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                // Hiển thị câu ĐÚNG với highlight chỗ sai
                Wrap(
                  spacing: 0, runSpacing: 2,
                  children: lastResult.diffSegments.map((seg) {
                    switch (seg.type) {
                      case 'wrong':
                        // 2 ký tự sai: gạch chân đậm đỏ trên câu đúng
                        return Text(seg.text,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.red,
                              decorationThickness: 2.5,
                            ));
                      case 'missing':
                        // Từ user bỏ sót: màu cam
                        return Text(seg.text,
                            style: TextStyle(
                              color: Colors.orange[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ));
                      default:
                        // correct: màu xanh bình thường
                        return Text(seg.text,
                            style: TextStyle(
                              color: Colors.green[700],
                              fontSize: 15,
                            ));
                    }
                  }).toList(),
                ),
                const SizedBox(height: 4),
                Text(
                  '(${lastResult.totalCorrectTypings} lần đúng)',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),

        // Input box
        TextField(
          controller: _typingController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4F6AF5), width: 2),
            ),
            hintText: 'Nhập câu tiếng Anh...',
            suffixIcon: _typingController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _typingController.clear()),
                  )
                : null,
          ),
          maxLines: 3,
          minLines: 2,
          onChanged: (_) => setState(() {}),
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          contextMenuBuilder: (context, editableTextState) {
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 8),

        // Progress đúng
        if (lastResult != null)
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (lastResult.totalCorrectTypings / 20).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    color: lastResult.totalCorrectTypings >= 20 ? Colors.green : const Color(0xFF4F6AF5),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${lastResult.totalCorrectTypings}/20',
                style: TextStyle(
                  color: lastResult.totalCorrectTypings >= 20 ? Colors.green[700] : Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

        const SizedBox(height: 12),

        ElevatedButton.icon(
          onPressed: _typingController.text.trim().isEmpty
              ? null
              : () {
                  final elapsed = _typingStartTime != null
                      ? DateTime.now().difference(_typingStartTime!).inSeconds
                      : 0;
                  context.read<DailyLearningBloc>().add(
                    DailyLearningEvent.typingAttempt(
                      widget.sentenceId,
                      _typingController.text.trim(),
                      elapsed,
                    ),
                  );
                },
          icon: const Icon(Icons.check),
          label: const Text('Kiểm tra'),
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
        ),
      ],
    );
  }

  // ── Step 2: Quiz ──────────────────────────────────────────────────────────
  // P0 FIX: show EN → user gõ VI (không phải VI → EN)

  Widget _buildQuizStep(SentenceDto sentence, DailyLearningState state) {
    final quizResult = state.maybeWhen(
      quizResult: (res, _) => res,
      orElse: () => null,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header quiz
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            children: [
              const Icon(Icons.quiz, color: Colors.orange, size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quiz nhanh',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    Text('Dịch câu tiếng Anh này sang tiếng Việt:',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // P0 FIX: hiển thị tiếng ANH để user dịch sang tiếng VIỆT
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF4F6AF5).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4F6AF5).withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _playAudio(sentence.audioUrl ?? '', sentence.englishText),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_isPlaying ? Icons.graphic_eq : Icons.volume_up_outlined,
                        color: const Color(0xFF4F6AF5), size: 20),
                    const SizedBox(width: 6),
                    Text(
                      _isPlaying ? 'Đang phát...' : 'Bấm để nghe',
                      style: TextStyle(
                        color: _isPlaying ? Colors.blue : const Color(0xFF4F6AF5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _playAudio(sentence.audioUrl ?? '', sentence.englishText),
                child: Text(
                sentence.englishText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  height: 1.4,
                ),
              ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Input: user gõ tiếng Việt
        if (!_quizAnswered) ...[
          TextField(
            controller: _quizController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF4F6AF5), width: 2),
              ),
              hintText: 'Nhập nghĩa tiếng Việt...',
              labelText: 'Bản dịch tiếng Việt',
            ),
            maxLines: 3,
            minLines: 2,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
        ],

        // Kết quả quiz
        if (_quizAnswered && quizResult != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _quizCorrect ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(10),
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
                    'Đáp án đúng: ${sentence.vietnameseText}',
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
                    final answer    = _quizController.text.trim();
                    // Bug 7 fix: so sánh sau khi bỏ dấu câu, case-insensitive
                    final isCorrect = _sanitize(answer) ==
                        _sanitize(sentence.vietnameseText);
                    final timeMs    = DateTime.now().difference(_quizStartTime).inMilliseconds;
                    context.read<DailyLearningBloc>().add(
                      DailyLearningEvent.quizSubmit(
                          widget.sentenceId, isCorrect, answer, timeMs),
                    );
                  },
            icon: const Icon(Icons.send),
            label: const Text('Nộp câu trả lời'),
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          )
        else if (!_quizCorrect)
          ElevatedButton.icon(
            onPressed: () {
              // Bỏ qua quiz sai → gọi completeSession trực tiếp (không submit lại)
              context.read<DailyLearningBloc>().add(
                DailyLearningEvent.completeSession(widget.sentenceId),
              );
            },
            icon: const Icon(Icons.skip_next),
            label: const Text('Tiếp tục (bỏ qua)'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
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
    final isPerfect = _quizPassed;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isPerfect ? Icons.star : Icons.check_circle_outline,
          size: 80,
          color: isPerfect ? Colors.amber : Colors.green,
        ),
        const SizedBox(height: 16),
        Text(
          isPerfect ? 'Hoàn thành xuất sắc!' : 'Đã hoàn thành',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          isPerfect
              ? 'Bạn đã hoàn thành việc học câu này.'
              : 'Bạn đã học qua câu này, cố gắng lần sau nhé!',
          style: const TextStyle(color: Colors.grey),
        ),
        if (_pointsAwarded != null && _pointsAwarded! > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.amber[700],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text('+$_pointsAwarded điểm 🌟',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
        const SizedBox(height: 32),
        // Enter key handler — when user presses Enter, pop back
        CallbackShortcuts(
          bindings: {
            const SingleActivator(LogicalKeyboardKey.enter): () {
              if (mounted) Navigator.of(context).pop();
            },
          },
          child: Focus(
            autofocus: true,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại danh sách'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
