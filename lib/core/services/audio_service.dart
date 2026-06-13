import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:injectable/injectable.dart';

/// Service để quản lý Audio playback
@singleton
class AudioService {
  // Lazy init để tránh crash khi WidgetsFlutterBinding chưa ready
  AudioPlayer? _audioPlayerInstance;
  FlutterTts? _flutterTtsInstance;
  double _ttsSpeed = 0.5;

  AudioService();

  AudioPlayer get _audioPlayer {
    _audioPlayerInstance ??= AudioPlayer();
    return _audioPlayerInstance!;
  }

  FlutterTts get _flutterTts {
    if (_flutterTtsInstance == null) {
      _flutterTtsInstance = FlutterTts();
      _flutterTtsInstance!.setLanguage("en-US");
    }
    return _flutterTtsInstance!;
  }

  Future<void> speak(String text, {String language = 'en-US', double speed = 0.5}) async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.setSpeechRate(speed);
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  Future<void> playAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
    } catch (e) {
      print('Audio Error: $e');
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  /// Alias for playAudio — called by AudioPlayerWidget
  Future<void> playAudioUrl(String url) async {
    await playAudio(url);
  }

  /// Set TTS playback speed
  void setTtsSpeed(double speed) {
    _ttsSpeed = speed;
    _flutterTts.setSpeechRate(_ttsSpeed);
  }

  void dispose() {
    _audioPlayer.dispose();
    _flutterTts.stop();
  }
}
