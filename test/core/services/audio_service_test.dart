// AudioService Unit Tests
// Test logic play/stop không cần GUI — mock dart:html AudioElement

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:english_learning_app/core/services/audio_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AudioService', () {
    late AudioService service;

    setUp(() {
      service = AudioService();
    });

    tearDown(() {
      service.dispose();
    });

    // ── playAudioUrl ────────────────────────────────────────────────────────

    test('playAudioUrl với url rỗng → return sớm, không crash', () async {
      // Không throw, không crash
      await expectLater(
        service.playAudioUrl(''),
        completes,
      );
    });

    test('playAudioUrl trên non-web (kIsWeb=false) → return sớm', () async {
      // Trong môi trường test (Dart VM), kIsWeb = false
      // Hàm phải return ngay mà không crash
      expect(kIsWeb, isFalse); // xác nhận đang chạy trong VM
      await expectLater(
        service.playAudioUrl('https://vanvy.up.railway.app/audio/test.mp3'),
        completes,
      );
    });

    // ── stopAudio ───────────────────────────────────────────────────────────

    test('stopAudio khi chưa play → không crash', () async {
      await expectLater(service.stopAudio(), completes);
    });

    test('stopAudio sau stopAudio → idempotent, không crash', () async {
      await service.stopAudio();
      await expectLater(service.stopAudio(), completes);
    });

    // ── isPlayingAudio ──────────────────────────────────────────────────────

    test('isPlayingAudio ban đầu là false', () {
      expect(service.isPlayingAudio, isFalse);
    });

    test('isPlayingAudio sau stopAudio vẫn là false', () async {
      await service.stopAudio();
      expect(service.isPlayingAudio, isFalse);
    });

    // ── setTtsSpeed ─────────────────────────────────────────────────────────

    test('setTtsSpeed không crash', () {
      expect(() => service.setTtsSpeed(0.5), returnsNormally);
      expect(() => service.setTtsSpeed(1.0), returnsNormally);
    });

    // ── dispose ─────────────────────────────────────────────────────────────

    test('dispose không crash', () {
      expect(() => service.dispose(), returnsNormally);
    });

    test('dispose 2 lần → không crash', () {
      service.dispose();
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
