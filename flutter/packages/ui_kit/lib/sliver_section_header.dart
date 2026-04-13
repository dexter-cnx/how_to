import 'package:flutter/material.dart';

class SliverSectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  SliverSectionHeaderDelegate({
    required this.title,
    this.height = 48,
  });

  final String title;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverSectionHeaderDelegate oldDelegate) {
    return title != oldDelegate.title || height != oldDelegate.height;
  }
}
