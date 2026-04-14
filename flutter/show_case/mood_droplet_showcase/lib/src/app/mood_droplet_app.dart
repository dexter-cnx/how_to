import 'package:flutter/material.dart';

import '../presentation/screens/showcase_screen.dart';
import '../theme/app_theme.dart';

class MoodDropletApp extends StatelessWidget {
  const MoodDropletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mood Droplet Showcase',
      theme: AppTheme.light(),
      home: const ShowcaseScreen(),
    );
  }
}
