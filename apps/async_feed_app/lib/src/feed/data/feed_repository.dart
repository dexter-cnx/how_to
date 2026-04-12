import 'package:data_layer/fake_delay.dart';
import 'package:data_layer/paged_response.dart';
import '../domain/feed_item.dart';

class FeedRepository {
  List<FeedItem>? _cache;

  Future<PagedResponse<FeedItem>> fetchPage(int page) async {
    await fakeDelay(450);

    if (page == 1 && _cache != null) {
      return PagedResponse(items: _cache!, hasMore: true);
    }

    final items = List.generate(
      10,
      (index) => FeedItem(
        id: 'p${page}_$index',
        title: 'Feed item page $page - $index',
      ),
    );

    if (page == 1) _cache = items;

    return PagedResponse(
      items: items,
      hasMore: page < 4,
    );
  }

  void clearCache() {
    _cache = null;
  }
}
