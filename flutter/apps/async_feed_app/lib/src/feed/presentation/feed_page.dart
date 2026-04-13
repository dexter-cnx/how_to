import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feature_shared/paged_list_state.dart';
import 'package:ui_kit/error_view.dart';
import 'package:ui_kit/empty_view.dart';
import '../data/feed_repository.dart';
import '../domain/feed_item.dart';

final repositoryProvider = Provider((ref) => FeedRepository());
final feedControllerProvider =
    StateNotifierProvider<FeedController, PagedListState<FeedItem>>((ref) {
  final controller = FeedController(ref.read(repositoryProvider));
  controller.loadInitial();
  return controller;
});

class FeedController extends StateNotifier<PagedListState<FeedItem>> {
  FeedController(this.repo) : super(const PagedListState());

  final FeedRepository repo;
  int _page = 1;

  Future<void> loadInitial() async {
    state = state.copyWith(isInitialLoading: true, error: null);
    try {
      final response = await repo.fetchPage(1);
      _page = 1;
      state = state.copyWith(
        items: response.items,
        hasMore: response.hasMore,
        isInitialLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isInitialLoading: false, error: e);
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, error: null);
    repo.clearCache();
    try {
      final response = await repo.fetchPage(1);
      _page = 1;
      state = state.copyWith(
        items: response.items,
        hasMore: response.hasMore,
        isRefreshing: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e);
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isAppending || state.isInitialLoading) return;

    state = state.copyWith(isAppending: true, error: null);
    try {
      final response = await repo.fetchPage(_page + 1);
      _page++;
      state = state.copyWith(
        items: [...state.items, ...response.items],
        hasMore: response.hasMore,
        isAppending: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isAppending: false, error: e);
    }
  }
}

class FeedPage extends ConsumerWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(feedControllerProvider);

    if (state.isInitialLoading && state.items.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null && state.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Async Feed')),
        body: ErrorView(
          message: 'โหลดข้อมูลไม่สำเร็จ',
          onRetry: () => ref.read(feedControllerProvider.notifier).loadInitial(),
        ),
      );
    }

    if (state.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Async Feed')),
        body: const EmptyView(
          title: 'ยังไม่มีข้อมูล',
          subtitle: 'ระบบยังไม่พบ feed items',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Async Feed')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(feedControllerProvider.notifier).refresh(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels >
                notification.metrics.maxScrollExtent - 300) {
              ref.read(feedControllerProvider.notifier).loadMore();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: state.items.length + (state.isAppending ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final item = state.items[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.id),
              );
            },
          ),
        ),
      ),
    );
  }
}
