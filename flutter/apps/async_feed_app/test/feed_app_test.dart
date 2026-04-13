import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:async_feed_app/src/app.dart';

void main() {
  testWidgets('async feed app shows app bar title', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AsyncFeedApp()));
    await tester.pump();
    expect(find.text('Async Feed'), findsOneWidget);
  });
}
