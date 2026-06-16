import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:english_learning_app/features/auth/presentation/bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dailyTargetController;
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dailyTargetController = TextEditingController();
    context.read<ProfileBloc>().add(const ProfileLoadEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dailyTargetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () {
              // Trigger logout qua AuthBloc — router sẽ tự redirect về /login
              context.read<AuthBloc>().add(const AuthLogoutEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                    onPressed: () => context.read<ProfileBloc>().add(const ProfileLoadEvent()),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    child: const Text('Về trang chủ'),
                    onPressed: () => context.go('/dashboard'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            // Initialize controllers
            _nameController.text = state.displayName;
            _dailyTargetController.text = state.dailyTargetMinutes.toString();
            _selectedGoal = state.learningGoal.isEmpty ? 'general' : state.learningGoal;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar & basic info
                  _buildProfileHeader(context, state),
                  const SizedBox(height: 32),

                  // Level card
                  _buildLevelCard(context, state),
                  const SizedBox(height: 24),

                  // Stats
                  _buildStatsGrid(state),
                  const SizedBox(height: 32),

                  // Settings section
                  Text(
                    'Learning Preferences',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildGoalDropdown(),
                  const SizedBox(height: 16),
                  _buildDailyTargetField(),
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ProfileBloc>().add(
                          ProfileUpdateEvent(
                            selfLevel: 'Beginner', // default since not in UI
                            learningGoal: _selectedGoal ?? 'general',
                            dailyTargetMinutes:
                                int.tryParse(_dailyTargetController.text) ??
                                    10,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Profile updated!')),
                        );
                      },
                      child: const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileLoaded state) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Text(
              state.displayName.isNotEmpty ? state.displayName[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          state.displayName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          state.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(BuildContext context, ProfileLoaded state) {
    final nextXp = (state.xpLevel * 100);
    final ratio = state.totalPointsEarned / (nextXp > 0 ? nextXp : 1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F6AF5), Color(0xFF7C4DFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F6AF5).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${state.xpLevel}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.selfLevel.isNotEmpty ? state.selfLevel : 'Beginner',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // XP progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${state.totalPointsEarned} XP',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '${nextXp} XP → Level ${state.xpLevel + 1}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Mastered & Learned
          Row(
            children: [
              _buildLevelStat(
                Icons.check_circle,
                '${state.totalSentencesMastered}',
                'Đã thuộc',
                Colors.greenAccent,
              ),
              const SizedBox(width: 24),
              _buildLevelStat(
                Icons.menu_book,
                '${state.totalSentencesLearned}',
                'Đã học',
                Colors.lightBlueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelStat(IconData icon, String value, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(ProfileLoaded state) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatTile('Points', state.totalPointsEarned.toString(),
            Icons.star, Colors.amber),
        _buildStatTile('Streak', '${state.streakDays}d', Icons.local_fire_department,
            Colors.red),
        _buildStatTile('Longest', '${state.longestStreak}d',
            Icons.emoji_events, Colors.green),
      ],
    );
  }

  Widget _buildStatTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Display Name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildGoalDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGoal,
      decoration: InputDecoration(
        labelText: 'Learning Goal',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'general', child: Text('General English')),
        DropdownMenuItem(value: 'business', child: Text('Business English')),
        DropdownMenuItem(value: 'travel', child: Text('Travel English')),
        DropdownMenuItem(
            value: 'conversation', child: Text('Conversation')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedGoal = value;
        });
      },
    );
  }

  Widget _buildDailyTargetField() {
    return TextFormField(
      controller: _dailyTargetController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Daily Target (sentences)',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
