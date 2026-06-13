import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:english_learning_app/features/learning/presentation/bloc/topic_list_bloc.dart';

class TopicListScreen extends StatefulWidget {
  const TopicListScreen({Key? key}) : super(key: key);

  @override
  State<TopicListScreen> createState() => _TopicListScreenState();
}

class _TopicListScreenState extends State<TopicListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    context.read<TopicListBloc>().add(const TopicListInitialEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<TopicListBloc>().add(const TopicListLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư Viện Chủ Đề'),
        elevation: 0,
      ),
      body: BlocBuilder<TopicListBloc, TopicListState>(
        builder: (context, state) {
          if (state is TopicListLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TopicListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<TopicListBloc>()
                          .add(const TopicListRefreshEvent());
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state is TopicListLoaded) {
            if (state.topics.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Chưa có chủ đề nào',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<TopicListBloc>()
                    .add(const TopicListRefreshEvent());
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: state.topics.length + (state.hasMoreToLoad ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.topics.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final topic = state.topics[index];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () {
                        context.push('/learn/today?topicId=${topic.id}');
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              child: Center(
                                child: Text(
                                  topic.iconEmoji,
                                  style: const TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic.topicName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${topic.sentenceCount} bài học',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Không có dữ liệu'));
        },
      ),
    );
  }
}
