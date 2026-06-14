import 'package:flutter/material.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/di/service_locator.dart';

class AdminTopicsScreen extends StatefulWidget {
  const AdminTopicsScreen({super.key});
  @override
  State<AdminTopicsScreen> createState() => _AdminTopicsScreenState();
}

class _AdminTopicsScreenState extends State<AdminTopicsScreen> {
  final _http = getIt<HttpClient>();
  List<dynamic> _topics = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await _http.get<List<dynamic>>('/api/admin/topics');
      setState(() { _topics = r.data ?? []; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) _showError('$e');
    }
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: Colors.red));

  Future<void> _showDialog({Map<String, dynamic>? topic}) async {
    final nameCtrl = TextEditingController(text: topic?['name'] ?? '');
    final descCtrl = TextEditingController(text: topic?['description'] ?? '');
    final isEdit = topic != null;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Sửa Topic' : 'Thêm Topic'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Tên topic *', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Mô tả', border: OutlineInputBorder()), maxLines: 2),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                if (isEdit) {
                  await _http.put('/api/admin/topics/${topic!['id']}', data: {'name': nameCtrl.text, 'description': descCtrl.text, 'isActive': true});
                } else {
                  await _http.post('/api/admin/topics', data: {'name': nameCtrl.text, 'description': descCtrl.text});
                }
                _load();
              } catch (e) { if (mounted) _showError('$e'); }
            },
            child: Text(isEdit ? 'Lưu' : 'Thêm'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(Map<String, dynamic> t) async {
    final ok = await showDialog<bool>(context: context, builder: (_) => AlertDialog(
      title: const Text('Xác nhận xóa'),
      content: Text('Xóa topic "${t['name']}"?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
        ElevatedButton(onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Xóa')),
      ],
    ));
    if (ok == true) {
      try { await _http.delete('/api/admin/topics/${t['id']}'); _load(); }
      catch (e) { if (mounted) _showError('$e'); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Topics (${_topics.length})'), actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showDialog(), icon: const Icon(Icons.add), label: const Text('Thêm Topic')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _topics.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final t = _topics[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF4F6AF5),
                    child: Text('${t['sentenceCount'] ?? 0}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  title: Text(t['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(t['description'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showDialog(topic: Map<String, dynamic>.from(t))),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete(Map<String, dynamic>.from(t))),
                  ]),
                );
              },
            ),
    );
  }
}
