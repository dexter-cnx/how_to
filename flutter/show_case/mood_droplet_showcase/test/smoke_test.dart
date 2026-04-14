import 'package:flutter_test/flutter_test.dart';
import 'package:mood_droplet_showcase/src/app/mood_droplet_app.dart';

void main() {
  testWidgets('renders showcase shell', (tester) async {
    await tester.pumpWidget(const MoodDropletApp());
    expect(find.text('Showcase Controls'), findsOneWidget);
  });
}
