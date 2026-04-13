import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui_kit/sliver_section_header.dart';
import '../../catalog/data/catalog_repository.dart';
import '../../catalog/domain/catalog_models.dart';

final repositoryProvider = Provider((ref) => CatalogRepository());
final sectionsProvider = FutureProvider<List<CatalogSection>>((ref) async {
  return ref.read(repositoryProvider).loadSections();
});
final activeSectionProvider = StateProvider<String?>((ref) => 'featured');
final scrollControllerProvider = Provider<ScrollController>((ref) {
  final controller = ScrollController();
  ref.onDispose(controller.dispose);
  return controller;
});
final sectionKeysProvider = Provider<Map<String, GlobalKey>>((ref) {
  return {
    'featured': GlobalKey(),
    'popular': GlobalKey(),
    'new': GlobalKey(),
  };
});

class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key});

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  final Map<String, double> _sectionOffsets = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recalculateOffsets();
      ref.read(scrollControllerProvider).addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    ref.read(scrollControllerProvider).removeListener(_onScroll);
    super.dispose();
  }

  void _recalculateOffsets() {
    final controller = ref.read(scrollControllerProvider);
    final keys = ref.read(sectionKeysProvider);

    for (final entry in keys.entries) {
      final context = entry.value.currentContext;
      final renderObject = context?.findRenderObject();
      if (renderObject is RenderBox) {
        _sectionOffsets[entry.key] =
            renderObject.localToGlobal(Offset.zero).dy + controller.offset;
      }
    }
  }

  void _onScroll() {
    if (_sectionOffsets.isEmpty) return;
    final offset = ref.read(scrollControllerProvider).offset + kToolbarHeight + 24;

    String? current;
    for (final entry in _sectionOffsets.entries) {
      if (offset >= entry.value) current = entry.key;
    }

    if (current != null && current != ref.read(activeSectionProvider)) {
      ref.read(activeSectionProvider.notifier).state = current;
    }
  }

  Future<void> _scrollTo(String id) async {
    final controller = ref.read(scrollControllerProvider);
    final key = ref.read(sectionKeysProvider)[id];
    final context = key?.currentContext;
    if (context == null) return;

    final box = context.findRenderObject();
    if (box is! RenderBox) return;

    final target = (box.localToGlobal(Offset.zero).dy + controller.offset - kToolbarHeight - 56)
        .clamp(
      controller.position.minScrollExtent,
      controller.position.maxScrollExtent,
    );

    await controller.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncSections = ref.watch(sectionsProvider);
    final active = ref.watch(activeSectionProvider);
    final controller = ref.watch(scrollControllerProvider);

    return Scaffold(
      body: asyncSections.when(
        data: (sections) => CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('Catalog'),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _FilterBarDelegate(
                child: _SectionBar(
                  sections: sections,
                  active: active,
                  onTap: _scrollTo,
                ),
              ),
            ),
            ...sections.expand((section) => [
                  SliverToBoxAdapter(
                    key: ref.read(sectionKeysProvider)[section.id],
                    child: const SizedBox.shrink(),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: SliverSectionHeaderDelegate(title: section.title),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(12),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = section.items[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(child: Placeholder()),
                                  const SizedBox(height: 8),
                                  Text(item.name),
                                  const SizedBox(height: 4),
                                  Text('\$${item.price.toStringAsFixed(0)}'),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: section.items.length,
                      ),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                    ),
                  ),
                ]),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _SectionBar extends StatelessWidget {
  const _SectionBar({
    required this.sections,
    required this.active,
    required this.onTap,
  });

  final List<CatalogSection> sections;
  final String? active;
  final Future<void> Function(String id) onTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final section = sections[index];
          final selected = active == section.id;
          return ChoiceChip(
            label: Text(section.title),
            selected: selected,
            onSelected: (_) => onTap(section.id),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: sections.length,
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  _FilterBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _FilterBarDelegate oldDelegate) => false;
}
