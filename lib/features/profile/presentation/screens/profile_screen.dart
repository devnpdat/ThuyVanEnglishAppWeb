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
              child: Text(state.message),
            );
          }

          if (state is ProfileLoaded) {
            // Initialize controllers
            _nameController.text = state.displayName;
            _dailyTargetController.text = state.dailyTargetMinutes.toString();
            _selectedGoal = state.learningGoal;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar & basic info
                  _buildProfileHeader(context, state),
                  const SizedBox(height: 32),

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
