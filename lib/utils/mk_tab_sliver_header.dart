import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_tab_persistent_header.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';

class MkTabSliverHeader {
  Function(BuildContext, bool) builder({
    @required String title,
    @required List<Tab> tabs,
    List<Widget> actions,
  }) {
    return (BuildContext context, bool innerBoxIsScrolled) {
      final _style = MkTheme.of(context).appBarTitle;
      // final _height = MediaQuery.of(context).padding.top;

      return <Widget>[
        // SliverPersistentHeader(
        //   pinned: true,
        //   delegate: MkPersistentHeaderDelegate(
        //     height: _height,
        //     builder: (BuildContext context, bool isAtTop) {
        //       return Container(color: Colors.white);
        //     },
        //   ),
        // ),
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          child: SliverAppBar(
            // primary: false,
            automaticallyImplyLeading: false,
            centerTitle: false,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            leading: MkBackButton(color: _style.color),
            title: Text(title, style: _style),
            actions: actions,

            pinned: true,
            elevation: 0.0,
          ),
        ),
        MkTabPersistentHeader(tabs: tabs),
      ];
    };
  }
}
