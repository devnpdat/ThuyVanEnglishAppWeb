import 'package:flutter/material.dart';
import 'package:english_learning_app/core/services/audio_service_interface.dart';
import 'package:english_learning_app/core/di/injection.dart';

/// Widget để phát âm câu text với TTS hoặc audio file
class AudioPlayerWidget extends StatefulWidget {
  final String text;
  final String language;
  final String? audioUrl;
  final VoidCallback? onPlayStart;
  final VoidCallback? onPlayEnd;

  const AudioPlayerWidget({
    Key? key,
    required this.text,
    this.language = 'en-US',
    this.audioUrl,
    this.onPlayStart,
    this.onPlayEnd,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final IAudioService _audioService;
  bool _isPlaying = false;
  double _playbackSpeed = 0.9;

  @override
  void initState() {
    super.initState();
    _audioService = getIt<IAudioService>();
  }

  @override
  void dispose() {
    _audioService.stop();
    super.dispose();
  }

  void _handlePlay() async {
    if (_isPlaying) {
      await _audioService.stop();
      setState(() => _isPlaying = false);
      widget.onPlayEnd?.call();
      return;
    }

    setState(() => _isPlaying = true);
    widget.onPlayStart?.call();

    try {
      if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
        // Play audio file if available
        await _audioService.playAudioUrl(widget.audioUrl!);
      } else {
        // Use TTS for pronunciation
        await _audioService.speak(
          widget.text,
          language: widget.language,
          speed: _playbackSpeed,
        );
      }

      // Auto-stop after speaking
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _isPlaying = false);
        widget.onPlayEnd?.call();
      }
    } catch (e) {
      print('Play Error: $e');
      setState(() => _isPlaying = false);
    }
  }

  void _handleSpeedChange(double speed) {
    setState(() => _playbackSpeed = speed);
    _audioService.setTtsSpeed(speed);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main play button
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _isPlaying
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(32),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _handlePlay,
              borderRadius: BorderRadius.circular(32),
              child: Center(
                child: Icon(
                  _isPlaying ? Icons.pause : Icons.volume_up,
                  color: _isPlaying ? Colors.white : Colors.grey[700],
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Speed control slider (if using TTS)
        if (widget.audioUrl == null || widget.audioUrl!.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Speed',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      '${(_playbackSpeed * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Slider(
                  value: _playbackSpeed,
                  min: 0.3,
                  max: 1.0,
                  divisions: 7,
                  onChanged: _handleSpeedChange,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Compact version for inline use (list items, cards)
class CompactAudioButton extends StatefulWidget {
  final String text;
  final String language;
  final String? audioUrl;
  final double size;

  const CompactAudioButton({
    Key? key,
    required this.text,
    this.language = 'en-US',
    this.audioUrl,
    this.size = 36,
  }) : super(key: key);

  @override
  State<CompactAudioButton> createState() => _CompactAudioButtonState();
}

class _CompactAudioButtonState extends State<CompactAudioButton> {
  late final IAudioService _audioService;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioService = getIt<IAudioService>();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioService.stop();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isPlaying = true);

    try {
      if (widget.audioUrl != null && widget.audioUrl!.isNotEmpty) {
        await _audioService.playAudioUrl(widget.audioUrl!);
      } else {
        await _audioService.speak(widget.text, language: widget.language);
      }

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    } catch (e) {
      setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _togglePlay,
        borderRadius: BorderRadius.circular(widget.size / 2),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: _isPlaying
                ? Theme.of(context).primaryColor
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(widget.size / 2),
          ),
          child: Icon(
            _isPlaying ? Icons.pause : Icons.volume_up,
            color: _isPlaying ? Colors.white : Colors.grey[700],
            size: widget.size * 0.5,
          ),
        ),
      ),
    );
  }
}
