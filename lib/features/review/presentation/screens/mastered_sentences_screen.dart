import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:english_learning_app/features/review/data/repositories/review_repository.dart';

/// Cubit cho Mastered Sentences
class MasteredCubit extends Cubit<MasteredState> {
  final ReviewRepository _repo;

  MasteredCubit()
      : _repo = GetIt.instance<ReviewRepository>(),
        super(MasteredInitial()) {
    load();
  }

  Future<void> load() async {
    emit(MasteredLoading());
    try {
      final result = await _repo.getMasteredSentences();
      emit(MasteredLoaded(result));
    } catch (e) {
      emit(MasteredError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}

abstract class MasteredState {}

class MasteredInitial extends MasteredState {}

class MasteredLoading extends MasteredState {}

class MasteredLoaded extends MasteredState {
  final List<Map<String, dynamic>> sentences;
  MasteredLoaded(this.sentences);
}

class MasteredError extends MasteredState {
  final String message;
  MasteredError(this.message);
}

/// Màn hình danh sách câu đã thuộc (mastered) — SRS status = Mastered
class MasteredSentencesScreen extends StatelessWidget {
  const MasteredSentencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MasteredCubit(),
      child: const _MasteredBody(),
    );
  }
}

class _MasteredBody extends StatelessWidget {
  const _MasteredBody();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Câu đã thuộc 👑',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<MasteredCubit, MasteredState>(
        builder: (context, state) {
          if (state is MasteredLoading || state is MasteredInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MasteredError) {
            return _buildError(context, state.message);
          }
          if (state is MasteredLoaded) {
            return _buildList(context, state.sentences);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildList(
      BuildContext context, List<Map<String, dynamic>> sentences) {
    if (sentences.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('👑', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text('Chưa có câu nào được thuộc',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Tiếp tục học và ôn tập để\nlên "Mastered" nhé!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], height: 1.5),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        // Count banner
        Container(
          margin: const EdgeInsets.all(16),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: Colors.amber, size: 28),
              const SizedBox(width: 12),
              Text(
                '${sentences.length} câu đã thuộc',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async =>
                context.read<MasteredCubit>().load(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: sentences.length,
              itemBuilder: (context, i) {
                final s = sentences[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: Colors.amber.withValues(alpha: 0.3)),
                  ),
                  color: Colors.amber.withValues(alpha: 0.04),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor:
                          Colors.amber.withValues(alpha: 0.15),
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      s['englishText'] as String? ??
                          s['sentence']?['englishText'] as String? ??
                          '',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      s['vietnameseseText'] as String? ??
                          s['sentence']?['vietnameseseText'] as String? ??
                          '',
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: const Icon(Icons.check_circle_rounded,
                        color: Colors.amber),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded,
              size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(msg, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.read<MasteredCubit>().load(),
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
