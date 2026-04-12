class PagedListState<T> {
  const PagedListState({
    this.items = const [],
    this.isInitialLoading = false,
    this.isRefreshing = false,
    this.isAppending = false,
    this.hasMore = true,
    this.error,
  });

  final List<T> items;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isAppending;
  final bool hasMore;
  final Object? error;

  PagedListState<T> copyWith({
    List<T>? items,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isAppending,
    bool? hasMore,
    Object? error = _sentinel,
  }) {
    return PagedListState<T>(
      items: items ?? this.items,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isAppending: isAppending ?? this.isAppending,
      hasMore: hasMore ?? this.hasMore,
      error: identical(error, _sentinel) ? this.error : error,
    );
  }
}

const _sentinel = Object();
