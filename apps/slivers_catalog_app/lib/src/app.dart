import 'package:flutter/material.dart';
import 'catalog/presentation/catalog_page.dart';

class SliversCatalogApp extends StatelessWidget {
  const SliversCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slivers Catalog App',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const CatalogPage(),
    );
  }
}
