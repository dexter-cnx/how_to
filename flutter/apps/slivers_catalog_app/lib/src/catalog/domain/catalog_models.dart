class CatalogSection {
  const CatalogSection({
    required this.id,
    required this.title,
    required this.items,
  });

  final String id;
  final String title;
  final List<CatalogItem> items;
}

class CatalogItem {
  const CatalogItem({
    required this.id,
    required this.name,
    required this.price,
  });

  final String id;
  final String name;
  final double price;
}
