import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_persistent_header_delegate.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkTabPersistentHeader extends StatelessWidget {
  const MkTabPersistentHeader({
    Key key,
    @required this.tabs,
  }) : super(key: key);

  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MkPersistentHeaderDelegate(
        builder: (BuildContext context, bool isAtTop) {
          return Material(
            elevation: isAtTop ? 2.0 : 1.0,
            child: TabBar(
              indicatorColor: MkColors.primary,
              labelStyle: MkTheme.of(context).bodySemi,
              labelColor: MkColors.accent,
              unselectedLabelColor: kHintColor,
              tabs: tabs,
            ),
          );
        },
      ),
    );
  }
}
