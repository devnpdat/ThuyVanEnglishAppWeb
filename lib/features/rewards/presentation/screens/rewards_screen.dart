import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_learning_app/features/rewards/presentation/bloc/rewards_bloc.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Bug 6 fix: giữ cả 2 state riêng — tránh mất data khi switch tab
  RewardsLoaded?     _rewardsData;
  LeaderboardLoaded? _leaderboardData;
  String?            _errorMessage;
  bool               _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<RewardsBloc>().add(const RewardsLoadEvent());
    context.read<RewardsBloc>().add(const LeaderboardLoadEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RewardsBloc, RewardsState>(
      listener: (context, state) {
        setState(() {
          if (state is RewardsLoading) {
            _isLoading = true;
          } else {
            _isLoading = false;
          }
          if (state is RewardsLoaded)     _rewardsData     = state;
          if (state is LeaderboardLoaded) _leaderboardData = state;
          if (state is RewardsError)      _errorMessage    = state.message;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Phần thưởng'),
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Điểm thưởng'),
              Tab(text: 'Xếp hạng'),
            ],
          ),
        ),
        body: _isLoading && _rewardsData == null && _leaderboardData == null
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null && _rewardsData == null && _leaderboardData == null
                ? _buildFullError()
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _rewardsData != null
                          ? _buildRewardsTab(context, _rewardsData!)
                          : _buildTabPlaceholder('Đang tải điểm thưởng...'),
                      _leaderboardData != null
                          ? _buildLeaderboardTab(context, _leaderboardData!)
                          : _buildTabPlaceholder('Đang tải xếp hạng...'),
                    ],
                  ),
      ),
    );
  }

  Widget _buildFullError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'Không tải được dữ liệu phần thưởng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!.length > 100
                  ? '${_errorMessage!.substring(0, 100)}...'
                  : _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() { _errorMessage = null; _isLoading = true; });
                context.read<RewardsBloc>().add(const RewardsLoadEvent());
                context.read<RewardsBloc>().add(const LeaderboardLoadEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPlaceholder(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildRewardsTab(BuildContext context, RewardsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card tổng điểm
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.star, color: Colors.white, size: 40),
                const SizedBox(height: 12),
                Text(
                  '${state.totalPoints}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tổng điểm',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Thống kê
          Text(
            'Thành tích của bạn',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildStatCard('Quiz đúng',         '${state.quizCorrectCount}',   Icons.check_circle,          Colors.green),
              _buildStatCard('Chuỗi ngày',        '${state.streakDaysCount}d',   Icons.local_fire_department, Colors.orange),
              _buildStatCard('Kế hoạch hoàn thành','${state.plansCompletedCount}',Icons.flag,                  Colors.blue),
              _buildStatCard('Cấp độ',            state.currentLevel,            Icons.military_tech,         Colors.purple),
            ],
          ),
          const SizedBox(height: 24),

          // Lịch sử hoạt động
          Text(
            'Hoạt động gần đây',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (state.rewardHistory.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'Chưa có hoạt động nào',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.rewardHistory.length,
              itemBuilder: (context, index) {
                final activity = state.rewardHistory[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: Text(_localizeActivity(activity.activityType)),
                    subtitle: Text(activity.description),
                    trailing: Text(
                      '+${activity.points} điểm',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // Bug 6 fix: dịch activity type sang tiếng Việt
  String _localizeActivity(String type) {
    switch (type.toLowerCase()) {
      case 'quiz_correct':      return 'Trả lời quiz đúng';
      case 'sentence_complete': return 'Hoàn thành câu';
      case 'plan_complete':     return 'Hoàn thành kế hoạch';
      case 'streak_bonus':      return 'Thưởng chuỗi ngày';
      case 'typing_correct':    return 'Gõ đúng câu';
      default:                  return type.isNotEmpty ? type : 'Hoạt động';
    }
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(BuildContext context, LeaderboardLoaded state) {
    if (state.leaderboard.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.leaderboard_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Chưa có dữ liệu xếp hạng',
              style: TextStyle(color: Colors.grey[600], fontSize: 15),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Hạng của user hiện tại
          if (state.currentUserRank > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[300]!),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '${state.currentUserRank}',
                        style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hạng của bạn',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        Text('#${state.currentUserRank}',
                            style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Tiêu đề top 10
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Top ${state.leaderboard.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.leaderboard.length,
            itemBuilder: (context, index) {
              final entry      = state.leaderboard[index];
              final isTopThree = index < 3;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isTopThree ? Colors.amber[50] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isTopThree ? Colors.amber[300]! : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: _getRankColor(index),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.userName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '${entry.totalPoints} điểm',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:  return Colors.amber[700]!;
      case 1:  return Colors.grey[400]!;
      case 2:  return Colors.orange[600]!;
      default: return Colors.blue;
    }
  }
}
