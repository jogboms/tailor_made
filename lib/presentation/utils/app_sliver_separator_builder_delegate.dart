import 'dart:math' show max;

import 'package:flutter/widgets.dart';

class AppSliverSeparatorBuilderDelegate extends SliverChildBuilderDelegate {
  AppSliverSeparatorBuilderDelegate({
    required IndexedWidgetBuilder builder,
    required IndexedWidgetBuilder separatorBuilder,
    int? childCount,
  }) : super(
          (BuildContext context, int index) {
            final int itemIndex = index ~/ 2;
            return (index == 0 || index.isEven) ? builder(context, itemIndex) : separatorBuilder(context, itemIndex);
          },
          childCount: childCount != null ? max(0, childCount * 2 - 1) : null,
        );
}
