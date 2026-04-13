import 'package:flutter/material.dart';
import 'feed/presentation/feed_page.dart';

class AsyncFeedApp extends StatelessWidget {
  const AsyncFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async Feed App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const FeedPage(),
    );
  }
}
