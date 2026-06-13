import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/sentence_list_bloc.dart';
import 'package:english_learning_app/features/learning/data/dtos/sentence_dto.dart';

class SentenceListScreen extends StatefulWidget {
  final String? topicId;
  final String? difficultyLevel;

  const SentenceListScreen({
    Key? key,
    this.topicId,
    this.difficultyLevel,
  }) : super(key: key);

  @override
  State<SentenceListScreen> createState() => _SentenceListScreenState();
}

class _SentenceListScreenState extends State<SentenceListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Trigger initial load
    context.read<SentenceListBloc>().add(
          SentenceListInitialEvent(
            topicId: widget.topicId,
            difficultyLevel: widget.difficultyLevel,
          ),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<SentenceListBloc>().add(const SentenceListLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Sentences'),
        elevation: 0,
      ),
      body: BlocBuilder<SentenceListBloc, SentenceListState>(
        builder: (context, state) {
          if (state is SentenceListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SentenceListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<SentenceListBloc>()
                          .add(const SentenceListRefreshEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is SentenceListLoaded) {
            if (state.sentences.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 48,
                          color: Colors.blue[400],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Chưa có bài học nào',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Các câu luyện tập sẽ xuất hiện ở đây khi hệ thống được kết nối API.\nHãy quay lại sau nhé! 📚',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      FilledButton.icon(
                        onPressed: () {
                          context
                              .read<SentenceListBloc>()
                              .add(const SentenceListRefreshEvent());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tải lại'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Quay về trang chủ'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<SentenceListBloc>()
                    .add(const SentenceListRefreshEvent());
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: state.sentences.length +
                    (state.hasMoreToLoad ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.sentences.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final sentence = state.sentences[index];
                  return _buildSentenceCard(context, sentence, index);
                },
              ),
            );
          }

          return const Center(child: Text('No data'));
        },
      ),
    );
  }

  Widget _buildSentenceCard(
    BuildContext context,
    dynamic sentence,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          sentence.englishText ?? 'Sample text',
          style: const TextTheme().titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              sentence.vietnameseText ?? 'Văn bản mẫu',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag(sentence.difficultyLevel ?? 'beginner'),
                const SizedBox(width: 8),
                _buildTag(sentence.sentenceType ?? 'conversation'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            // TODO: Navigate to quiz screen
            context.push('/quiz/${sentence.id}');
          },
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF4F6AF5),
        ),
      ),
    );
  }
}
