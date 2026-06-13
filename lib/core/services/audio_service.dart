import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:web/web.dart' as web;

/// AudioService — hybrid:
/// 1. Nếu có audioUrl từ Drive → dùng <audio> HTML element (chất lượng Neural2)
/// 2. Fallback → Web Speech API (TTS trình duyệt)
@singleton
class AudioService {
  double _ttsSpeed = 0.85;
  web.HTMLAudioElement? _audioEl;

  AudioService();

  // ── Play từ URL (Drive MP3) ───────────────────────────────────────────────

  Future<void> playAudioUrl(String url) async {
    if (!kIsWeb || url.isEmpty) return;
    try {
      // Stop và cleanup trước
      await stopAudio();

      // Tạo audio element mới mỗi lần
      final el = web.HTMLAudioElement();
      el.src = url;
      el.preload = 'auto';
      el.crossOrigin = 'anonymous';
      
      _audioEl = el;

      // Play
      el.play();
      debugPrint('🎵 Playing audio URL: $url');
    } catch (e) {
      debugPrint('❌ playAudioUrl error: $e');
    }
  }

  Future<void> stopAudio() async {
    try {
      if (_audioEl != null) {
        _audioEl!.pause();
        _audioEl!.currentTime = 0;  // Reset position
        _audioEl!.src = '';  // Clear src
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
