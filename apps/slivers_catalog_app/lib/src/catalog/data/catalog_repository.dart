import '../domain/catalog_models.dart';

class CatalogRepository {
  Future<List<CatalogSection>> loadSections() async {
    return const [
      CatalogSection(
        id: 'featured',
        title: 'Featured',
        items: [
          CatalogItem(id: 'f1', name: 'Featured One', price: 10),
          CatalogItem(id: 'f2', name: 'Featured Two', price: 12),
          CatalogItem(id: 'f3', name: 'Featured Three', price: 14),
          CatalogItem(id: 'f4', name: 'Featured Four', price: 16),
        ],
      ),
      CatalogSection(
        id: 'popular',
        title: 'Popular',
        items: [
          CatalogItem(id: 'p1', name: 'Popular One', price: 18),
          CatalogItem(id: 'p2', name: 'Popular Two', price: 20),
          CatalogItem(id: 'p3', name: 'Popular Three', price: 22),
          CatalogItem(id: 'p4', name: 'Popular Four', price: 24),
        ],
      ),
      CatalogSection(
        id: 'new',
        title: 'New',
        items: [
          CatalogItem(id: 'n1', name: 'New One', price: 26),
          CatalogItem(id: 'n2', name: 'New Two', price: 28),
          CatalogItem(id: 'n3', name: 'New Three', price: 30),
          CatalogItem(id: 'n4', name: 'New Four', price: 32),
        ],
      ),
    ];
  }
}
