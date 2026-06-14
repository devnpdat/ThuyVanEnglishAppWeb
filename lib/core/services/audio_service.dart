import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:web/web.dart' as web;
import 'audio_service_interface.dart';

/// AudioService — hybrid:
/// 1. Nếu có audioUrl từ BE → dùng <audio> HTML element (chất lượng Neural2)
/// 2. Fallback → Web Speech API (TTS trình duyệt)
@Singleton(as: IAudioService)
class AudioService implements IAudioService {
  double _ttsSpeed = 0.85;
  web.HTMLAudioElement? _audioEl;

  AudioService();

  // ── Play từ URL (BE static MP3) ───────────────────────────────────────────

  Future<void> playAudioUrl(String url) async {
    if (!kIsWeb || url.isEmpty) return;
    try {
      // Stop và cleanup trước
      await stopAudio();

      // Tạo audio element mới mỗi lần — tránh state stale
      final el = web.HTMLAudioElement();
      el.src = url;
      el.preload = 'auto';
      el.crossOrigin = 'anonymous';
      _audioEl = el;

      // Chờ canplay trước khi gọi play() — tránh tiếng rùng rợn lần đầu
      // do buffer chưa sẵn sàng
      final canPlayCompleter = Completer<void>();
      late web.EventListener canPlayListener;
      late web.EventListener errorListener;

      canPlayListener = (web.Event _) {
        if (!canPlayCompleter.isCompleted) canPlayCompleter.complete();
      }.toJS;

      errorListener = (web.Event e) {
        if (!canPlayCompleter.isCompleted) {
          canPlayCompleter.completeError('Audio load error');
        }
      }.toJS;

      el.addEventListener('canplay', canPlayListener);
      el.addEventListener('error', errorListener);

      try {
        await canPlayCompleter.future.timeout(const Duration(seconds: 5));
      } catch (_) {
        // Timeout hoặc lỗi load — vẫn thử play
      } finally {
        el.removeEventListener('canplay', canPlayListener);
        el.removeEventListener('error', errorListener);
      }

      // Chỉ play nếu element vẫn là element hiện tại (chưa bị stopAudio clear)
      if (_audioEl == el) {
        el.play();
        debugPrint('🎵 Playing audio URL: $url');
      }
    } catch (e) {
      debugPrint('❌ playAudioUrl error: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      if (_audioEl != null) {
        _audioEl!.pause();
        _audioEl!.currentTime = 0; // Reset position
        _audioEl!.src = '';        // Clear src
        _audioEl = null;
      }
    } catch (_) {}
  }

  bool get isPlayingAudio => _audioEl != null;

  // ── Speak via Web Speech API (fallback) ──────────────────────────────────

  Future<void> speak(String text,
      {String language = 'en-US', double? speed}) async {
    if (!kIsWeb) return;
    try {
      final rate = speed ?? _ttsSpeed;
      final synth = web.window.speechSynthesis;
      synth.cancel();

      final utterance = web.SpeechSynthesisUtterance(text);
      utterance.lang = language;
      utterance.rate = rate;
      utterance.pitch = 1.0;
      utterance.volume = 1.0;

      // Chọn giọng Google US English nếu có
      final voices = synth.getVoices();
      web.SpeechSynthesisVoice? bestVoice;
      for (var i = 0; i < voices.length; i++) {
        final v = voices[i];
        if (v.name.contains('Google') && v.lang.startsWith('en-US')) {
          bestVoice = v;
          break;
        }
        if (bestVoice == null && v.lang.startsWith('en')) {
          bestVoice = v;
        }
      }
      if (bestVoice != null) utterance.voice = bestVoice;

      synth.speak(utterance);
    } catch (e) {
      debugPrint('❌ TTS error: $e');
    }
  }

  Future<void> stop() async {
    if (!kIsWeb) return;
    try {
      web.window.speechSynthesis.cancel();
      await stopAudio();
    } catch (_) {}
  }

  void setTtsSpeed(double speed) => _ttsSpeed = speed;

  void dispose() {
    _audioEl?.pause();
    _audioEl = null;
  }
}
