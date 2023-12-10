import 'package:flutter/material.dart';

class PgProfileTabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  PgProfileTabBarHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(child: child, elevation: overlapsContent ? 4 : 0);
  }

  @override
  double get maxExtent => 48.0;

  @override
  double get minExtent => 48.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
