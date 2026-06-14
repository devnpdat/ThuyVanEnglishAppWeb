import 'package:flutter/material.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/di/service_locator.dart';

class AdminSentencesScreen extends StatefulWidget {
  const AdminSentencesScreen({super.key});
  @override
  State<AdminSentencesScreen> createState() => _AdminSentencesScreenState();
}

class _AdminSentencesScreenState extends State<AdminSentencesScreen> {
  final _http = getIt<HttpClient>();
  List<dynamic> _sentences = [];
  List<dynamic> _topics = [];
  bool _loading = true;
  String? _selectedTopicId;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final topicsResp = await _http.get('/api/admin/topics');
      final sentencesResp = await _http.get('/api/admin/sentences', queryParameters: {
        'page': 1,
        'pageSize': 50,
        if (_selectedTopicId != null) 'topicId': _selectedTopicId,
        if (_searchCtrl.text.isNotEmpty) 'search': _searchCtrl.text,
      });
      setState(() {
        _topics = (topicsResp.data['items'] ?? topicsResp.data) as List? ?? [];
        _sentences = (sentencesResp.data['items'] ?? []) as List;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  Future<void> _showForm({Map<String, dynamic>? sentence}) async {
    final isUpdate = sentence != null;
    final engCtrl = TextEditingController(text: sentence?['englishText'] ?? '');
    final vieCtrl = TextEditingController(text: sentence?['vietnameseText'] ?? '');
    String? topicId = sentence != null && (sentence['topics'] as List?)?.isNotEmpty == true
        ? sentence['topics'][0]['id']
        : null;
    String level = sentence?['difficultyLevel'] ?? 'beginner';

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: Text(isUpdate ? 'Sửa câu' : 'Thêm câu mới'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: engCtrl,
                    decoration: const InputDecoration(labelText: 'English'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: vieCtrl,
                    decoration: const InputDecoration(labelText: 'Vietnamese'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: topicId,
                    decoration: const InputDecoration(labelText: 'Topic'),
                    items: _topics.map<DropdownMenuItem<String>>((t) {
                      return DropdownMenuItem(value: t['id'], child: Text(t['name']));
                    }).toList(),
                    onChanged: (v) => setDlgState(() => topicId = v),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: level,
                    decoration: const InputDecoration(labelText: 'Level'),
                    items: const [
                      DropdownMenuItem(value: 'beginner',     child: Text('Beginner (Cơ bản)')),
                      DropdownMenuItem(value: 'intermediate', child: Text('Intermediate (Trung cấp)')),
                      DropdownMenuItem(value: 'advanced',     child: Text('Advanced (Nâng cao)')),
                    ],
                    onChanged: (v) => setDlgState(() => level = v!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            if (isUpdate)
              TextButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: ctx,
                    builder: (_) => AlertDialog(
                      title: const Text('Xác nhận xóa'),
                      content: const Text('Xóa câu này?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xóa')),
                      ],
                    ),
                  );
                  if (confirm == true && mounted) {
                    try {
                      await _http.delete('/api/admin/sentences/${sentence['id']}');
                      Navigator.pop(ctx, true);
                    } catch (e) {
                      if (mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Lỗi xóa: $e')));
                    }
                  }
                },
                child: const Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
            ElevatedButton(
              onPressed: () async {
                if (engCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Nhập English text')));
                  return;
                }
                try {
                  final body = {
                    'englishText': engCtrl.text.trim(),
                    'vietnameseText': vieCtrl.text.trim(),
                    'topicIds': topicId != null ? [topicId] : [],
                    'difficultyLevel': level, // string: beginner|intermediate|advanced
                    'isActive': true,
                  };
                  if (isUpdate) {
                    await _http.put('/api/admin/sentences/${sentence['id']}', data: body);
                  } else {
                    await _http.post('/api/admin/sentences', data: body);
                  }
                  Navigator.pop(ctx, true);
                } catch (e) {
                  if (mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                }
              },
              child: Text(isUpdate ? 'Cập nhật' : 'Tạo'),
            ),
          ],
        ),
      ),
    );

    if (result == true) _load();
  }

  Future<void> _regenerateMedia(String id) async {
    try {
      await _http.post('/api/admin/sentences/$id/regenerate-media');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đang tạo lại media...')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Sentences'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _showForm()),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: InputDecoration(
                            labelText: 'Tìm kiếm',
                            suffixIcon: IconButton(icon: const Icon(Icons.search), onPressed: _load),
                          ),
                          onSubmitted: (_) => _load(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 200,
                        child: DropdownButtonFormField<String>(
                          value: _selectedTopicId,
                          decoration: const InputDecoration(labelText: 'Topic'),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('Tất cả')),
                            ..._topics.map<DropdownMenuItem<String>>((t) {
                              return DropdownMenuItem(value: t['id'], child: Text(t['name']));
                            }),
                          ],
                          onChanged: (v) {
                            setState(() => _selectedTopicId = v);
                            _load();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _sentences.length,
                    itemBuilder: (_, i) {
                      final s = _sentences[i];
                      final topics = (s['topics'] as List?)?.map((t) => t['name']).join(', ') ?? '';
                      return ListTile(
                        title: Text(s['englishText'] ?? ''),
                        subtitle: Text('${s['vietnameseText'] ?? ''}\nTopic: $topics | Level: ${s['difficultyLevel'] ?? 1}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.refresh), onPressed: () => _regenerateMedia(s['id'])),
                            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showForm(sentence: s)),
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
