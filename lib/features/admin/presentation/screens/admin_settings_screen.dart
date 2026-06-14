import 'package:flutter/material.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/di/service_locator.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});
  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _http = getIt<HttpClient>();
  bool _loading = true;
  int _minTyping = 20;
  int _minAudio  = 3;
  String? _msg;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await _http.get<Map<String, dynamic>>('/api/admin/settings');
      final d = r.data!;
      setState(() {
        _minTyping = d['minTypingCount'] ?? 20;
        _minAudio  = d['minAudioPlays']  ?? 3;
        _loading   = false;
      });
    } catch (e) {
      setState(() { _loading = false; _msg = 'Lỗi tải: $e'; });
    }
  }

  Future<void> _save() async {
    try {
      await _http.put('/api/admin/settings', data: {'minTypingCount': _minTyping, 'minAudioPlays': _minAudio});
      setState(() => _msg = 'Lưu thành công!');
    } catch (e) {
      setState(() => _msg = 'Lỗi lưu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cấu hình học tập')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Card(
                margin: const EdgeInsets.all(32),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: SizedBox(
                    width: 420,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.settings, color: Color(0xFF4F6AF5)),
                          const SizedBox(width: 8),
                          Text('Cài đặt học tập', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        ]),
                        const SizedBox(height: 32),

                        Text('Số lần gõ đúng tối thiểu để qua Quiz', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Row(children: [
                          Expanded(child: Slider(value: _minTyping.toDouble(), min: 1, max: 50, divisions: 49, label: '$_minTyping lần',
                            activeColor: const Color(0xFF4F6AF5),
                            onChanged: (v) => setState(() => _minTyping = v.round()))),
                          Container(
                            width: 56, height: 40,
                            decoration: BoxDecoration(color: const Color(0xFF4F6AF5).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.center,
                            child: Text('$_minTyping', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F6AF5))),
                          ),
                        ]),

                        const SizedBox(height: 24),
                        Text('Số lần nghe tối thiểu', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Row(children: [
                          Expanded(child: Slider(value: _minAudio.toDouble(), min: 1, max: 20, divisions: 19, label: '$_minAudio lần',
                            activeColor: const Color(0xFF4F6AF5),
                            onChanged: (v) => setState(() => _minAudio = v.round()))),
                          Container(
                            width: 56, height: 40,
                            decoration: BoxDecoration(color: const Color(0xFF4F6AF5).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.center,
                            child: Text('$_minAudio', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4F6AF5))),
                          ),
                        ]),

                        const SizedBox(height: 32),
                        if (_msg != null) Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(_msg!, style: TextStyle(color: _msg!.startsWith('Lỗi') ? Colors.red : Colors.green, fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(width: double.infinity, child: ElevatedButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.save),
                          label: const Text('Lưu cài đặt'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F6AF5), foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
