import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class SlideDownItem extends StatefulWidget {
  final bool isExpanded;
  final String title;
  final Widget body;

  SlideDownItem({this.title, this.body, this.isExpanded: false});

  @override
  SlideDownItemState createState() => new SlideDownItemState(isExpanded: isExpanded);
}

class SlideDownItemState extends State<SlideDownItem> {
  int id;
  bool isExpanded;

  SlideDownItemState({this.isExpanded}) {
    Random rand = new Random();
    id = rand.nextInt(100);
  }

  @override
  build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    Widget body = new AnimatedCrossFade(
      firstChild: new Container(height: 0.0),
      secondChild: widget.body,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 350),
    );

    Widget header = new Material(
      color: Colors.white,
      elevation: isExpanded ? 1.0 : 0.0,
      child: new InkWell(
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Container(
                padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                child: Text(
                  widget.title,
                  style: theme.titleStyle.copyWith(fontSize: 14.0),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            ),
          ],
        ),
        onTap: () => setState(() => isExpanded = !isExpanded),
      ),
    );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        header,
        body,
      ],
    );
  }
}
