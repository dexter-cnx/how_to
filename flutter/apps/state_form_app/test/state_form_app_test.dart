import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_form_app/src/app.dart';

void main() {
  testWidgets('state form app boots', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: StateFormApp()));
    await tester.pumpAndSettle();
    expect(find.text('State Form'), findsOneWidget);
  });
}
