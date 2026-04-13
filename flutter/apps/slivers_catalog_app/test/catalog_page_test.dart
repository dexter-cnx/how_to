import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slivers_catalog_app/src/catalog/presentation/catalog_page.dart';

void main() {
  testWidgets('catalog page renders title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CatalogPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Catalog'), findsWidgets);
  });
}
