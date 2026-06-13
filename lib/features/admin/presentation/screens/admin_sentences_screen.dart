import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/di/service_locator.dart';
import 'package:english_learning_app/core/config/app_config.dart';

/// Màn hình admin quản lý sentences — bổ sung imageUrl + audioUrl
class AdminSentencesScreen extends StatefulWidget {
  const AdminSentencesScreen({Key? key}) : super(key: key);

  @override
  State<AdminSentencesScreen> createState() => _AdminSentencesScreenState();
}

class _AdminSentencesScreenState extends State<AdminSentencesScreen> {
  final _httpClient = getIt<HttpClient>();
  List<dynamic> _sentences = [];
  bool _loading = true;
  String? _error;
  int _page = 0;
  final int _pageSize = 20;
  bool _hasMore = true;
  final _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadSentences();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSentences({bool reset = false}) async {
    if (reset) {
      setState(() { _page = 0; _sentences = []; _hasMore = true; });
    }
    setState(() => _loading = true);
    try {
      final response = await _httpClient.get<Map<String, dynamic>>(
        '${AppConfig.sentencesEndpoint}',
        queryParameters: {
          'MaxResultCount': _pageSize,
          'SkipCount': _page * _pageSize,
          if (_searchText.isNotEmpty) 'SearchText': _searchText,
        },
      );
      final data  = response.data!;
      final items = (data['items'] as List?) ?? [];
      setState(() {
        if (reset) {
          _sentences = items;
        } else {
          _sentences.addAll(items);
        }
        _hasMore = items.length == _pageSize;
        _page++;
        _loading = false;
        _error   = null;
      });
    } catch (e) {
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  Future<void> _editMediaUrls(Map<String, dynamic> sentence) async {
    final imageCtrl = TextEditingController(text: sentence['imageUrl'] ?? '');
    final audioCtrl = TextEditingController(text: sentence['audioUrl'] ?? '');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          sentence['englishText'] ?? '',
          style: const TextStyle(fontSize: 15),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sentence['vietnameseseText'] ?? '',
                style: const TextStyle(color: Colors.blueGrey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              const Text('🖼 Image URL (Google Drive/link ảnh):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              TextField(
                controller: imageCtrl,
                decoration: const InputDecoration(
                  hintText: 'https://drive.google.com/uc?id=...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                minLines: 2, maxLines: 3,
              ),
              const SizedBox(height: 12),
              const Text('🔊 Audio URL (Google Drive/link mp3):',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              TextField(
                controller: audioCtrl,
                decoration: const InputDecoration(
                  hintText: 'https://drive.google.com/uc?id=...',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                minLines: 2, maxLines: 3,
              ),
              const SizedBox(height: 8),
              const Text(
                'Tip Google Drive: share file → copy link → đổi /file/d/ID/view thành /uc?id=ID',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Huỷ')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Lưu')),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final id = sentence['id'];
      final body = <String, String?>{};
      if (imageCtrl.text.trim().isNotEmpty) body['imageUrl'] = imageCtrl.text.trim();
      if (audioCtrl.text.trim().isNotEmpty) body['audioUrl'] = audioCtrl.text.trim();

      await _httpClient.put<dynamic>(
        '${AppConfig.sentencesEndpoint}/$id/media-urls',
        data: body,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Đã lưu!'), backgroundColor: Colors.green),
        );
        // Refresh item trong list
        await _loadSentences(reset: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Lỗi: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin — Quản lý Sentences'),
        leading: BackButton(onPressed: () => context.pop()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm câu...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchText = '');
                          _loadSentences(reset: true);
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                isDense: true,
              ),
              onSubmitted: (v) {
                setState(() => _searchText = v.trim());
                _loadSentences(reset: true);
              },
            ),
          ),
        ),
      ),
      body: _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: $_error', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () => _loadSentences(reset: true), child: const Text('Thử lại')),
                ],
              ),
            )
          : _sentences.isEmpty && _loading
              ? const Center(child: CircularProgressIndicator())
              : _sentences.isEmpty
                  ? const Center(child: Text('Không có câu nào.'))
                  : RefreshIndicator(
                      onRefresh: () => _loadSentences(reset: true),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _sentences.length + (_hasMore ? 1 : 0),
                        itemBuilder: (context, i) {
                          if (i == _sentences.length) {
                            if (_loading) return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator(strokeWidth: 2)));
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                onPressed: _loadSentences,
                                child: const Text('Tải thêm'),
                              ),
                            );
                          }
                          final s = _sentences[i] as Map<String, dynamic>;
                          final imgUrl   = s['imageUrl'] as String? ?? '';
                          final audioUrl = s['audioUrl'] as String? ?? '';
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              leading: imgUrl.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        imgUrl,
                                        width: 56, height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _iconBox(Icons.broken_image, Colors.grey),
                                      ),
                                    )
                                  : _iconBox(Icons.image_outlined, Colors.blue.shade100),
                              title: Text(
                                s['englishText'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s['vietnameseseText'] ?? '',
                                    style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(children: [
                                    Icon(
                                      imgUrl.isNotEmpty ? Icons.image : Icons.image_not_supported,
                                      size: 14,
                                      color: imgUrl.isNotEmpty ? Colors.green : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(imgUrl.isNotEmpty ? 'Có ảnh' : 'Chưa có ảnh',
                                        style: TextStyle(fontSize: 11, color: imgUrl.isNotEmpty ? Colors.green : Colors.grey)),
                                    const SizedBox(width: 12),
                                    Icon(
                                      audioUrl.isNotEmpty ? Icons.volume_up : Icons.volume_off,
                                      size: 14,
                                      color: audioUrl.isNotEmpty ? Colors.green : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(audioUrl.isNotEmpty ? 'Có audio' : 'Chưa có audio',
                                        style: TextStyle(fontSize: 11, color: audioUrl.isNotEmpty ? Colors.green : Colors.grey)),
                                  ]),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                color: Colors.blue,
                                tooltip: 'Sửa imageUrl / audioUrl',
                                onPressed: () => _editMediaUrls(s),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }

  Widget _iconBox(IconData icon, Color bg) {
    return Container(
      width: 56, height: 56,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Icon(icon, color: Colors.blueGrey, size: 28),
    );
  }
}
