import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/core/services/http_client.dart';
import 'package:english_learning_app/core/di/service_locator.dart';

/// Shell layout cho toàn bộ /admin/* — sidebar navigation
class AdminShellScreen extends StatelessWidget {
  final Widget child;
  const AdminShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width > 800,
            selectedIndex: _indexFor(location),
            onDestinationSelected: (i) {
              final routes = [
                '/admin/topics',
                '/admin/sentences',
                '/admin/settings',
                '/admin/users',
              ];
              context.go(routes[i]);
            },
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Column(children: [
                const Icon(Icons.admin_panel_settings, color: Color(0xFF4F6AF5), size: 32),
                const SizedBox(height: 4),
                Text('Admin', style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: const Color(0xFF4F6AF5))),
              ]),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  tooltip: 'Về trang chủ',
                  onPressed: () => context.go('/'),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Đăng xuất',
                  onPressed: () async {
                  await getIt<HttpClient>().clearAuthToken();
                    if (context.mounted) context.go('/login');
                  },
                ),
              ]),
            ),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.topic), label: Text('Topics')),
              NavigationRailDestination(icon: Icon(Icons.list_alt), label: Text('Sentences')),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text('Settings')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Users')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  int _indexFor(String loc) {
    if (loc.startsWith('/admin/topics'))    return 0;
    if (loc.startsWith('/admin/sentences')) return 1;
    if (loc.startsWith('/admin/settings'))  return 2;
    if (loc.startsWith('/admin/users'))     return 3;
    return 0;
  }
}
