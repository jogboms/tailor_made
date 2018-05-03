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

    Widget _header = new AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
      margin: isExpanded ? EdgeInsets.symmetric(vertical: 16.0) : EdgeInsets.zero,
      child: Text(
        widget.title,
        style: theme.titleStyle.copyWith(fontSize: 14.0),
      ),
    );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: borderSideColor,
                width: 1.0,
                style: isExpanded ? BorderStyle.solid : BorderStyle.none,
              ),
            ),
          ),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: _header,
              ),
              IconButton(
                icon: Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ],
          ),
        ),
        isExpanded
            ? new AnimatedCrossFade(
                firstChild: new Container(height: 0.0),
                secondChild: widget.body,
                firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
                secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
                sizeCurve: Curves.fastOutSlowIn,
                crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: Duration(microseconds: 5000),
              )
            : Container(),
      ],
    );
  }
}
