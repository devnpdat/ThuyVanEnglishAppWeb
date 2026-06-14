import 'package:flutter/material.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/di/service_locator.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});
  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _http = getIt<HttpClient>();
  List<dynamic> _users = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await _http.get<List<dynamic>>('/api/admin/users');
      setState(() { _users = r.data ?? []; _loading = false; });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _showProgress(Map<String, dynamic> user) async {
    try {
      final r = await _http.get<Map<String, dynamic>>('/api/admin/users/${user['id']}/progress');
      final d = r.data!;
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(d['userName'] ?? ''),
          content: SizedBox(
            width: 400,
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              _row('Level', '${d['level']}'),
              _row('Total XP', '${d['totalXp']}'),
              _row('Số câu đã học', '${d['totalSentencesLearned']}'),
              _row('Tổng thời gian gõ', '${d['totalTypingHours'] ?? 0}h ${d['totalTypingMinutes'] ?? 0}m'),
              _row('Streak', '${d['currentStreak']} ngày'),
              const Divider(height: 24),
              const Text('10 câu gần nhất:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              ...((d['recentSentences'] as List?) ?? []).map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Expanded(child: Text(s['englishText']?.toString().isNotEmpty == true ? s['englishText'] : '(câu)',
                        overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13))),
                    const SizedBox(width: 8),
                    Text('${s['totalCorrectTypings']}/20', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(width: 4),
                    Icon(s['isCompleted'] == true ? Icons.check_circle : Icons.radio_button_unchecked,
                        size: 16, color: s['isCompleted'] == true ? Colors.green : Colors.grey),
                  ]),
                )),
            ]),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))],
        ),
      );
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.red));
    }
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
      Text(value),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users (${_users.length})'), actions: [
        IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
      ]),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final u = _users[i];
                final name = (u['userName'] as String? ?? '?');
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF4F6AF5),
                    child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(u['email'] ?? ''),
                  trailing: TextButton.icon(
                    icon: const Icon(Icons.bar_chart),
                    label: const Text('Xem Progress'),
                    onPressed: () => _showProgress(Map<String, dynamic>.from(u)),
                  ),
                );
              },
            ),
    );
  }
}
