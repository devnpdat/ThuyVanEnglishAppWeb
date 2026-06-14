/// Abstract interface cho AudioService — cho phép mock trong unit test
/// mà không cần compile dart:js_interop / package:web
abstract class IAudioService {
  Future<void> playAudioUrl(String url);
  Future<void> stopAudio();
  bool get isPlayingAudio;
  Future<void> speak(String text, {String language, double? speed});
  Future<void> stop();
  void setTtsSpeed(double speed);
  void dispose();
}
