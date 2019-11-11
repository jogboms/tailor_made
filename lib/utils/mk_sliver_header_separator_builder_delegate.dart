import 'dart:math' show max;

import 'package:flutter/widgets.dart';

class MkSliverHeaderSeparatorBuilderDelegate extends SliverChildBuilderDelegate {
  MkSliverHeaderSeparatorBuilderDelegate({
    @required IndexedWidgetBuilder builder,
    @required IndexedWidgetBuilder separatorBuilder,
    @required WidgetBuilder headerBuilder,
    int childCount,
    bool skipTopSeparator = true,
  }) : super(
          (BuildContext context, int _index) {
            if (_index == 0) {
              return headerBuilder(context);
            }
            final int index = _index - (skipTopSeparator ? 1 : 2), itemIndex = index ~/ 2;

            return (index == 0 || index.isEven) ? builder(context, itemIndex) : separatorBuilder(context, itemIndex);
          },
          childCount: childCount != null ? max(1, childCount * 2) : null,
        );
}
