class PagedResponse<T> {
  const PagedResponse({
    required this.items,
    required this.hasMore,
  });

  final List<T> items;
  final bool hasMore;
}
