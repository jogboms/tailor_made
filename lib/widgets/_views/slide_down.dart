import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class SlideDownItem extends StatefulWidget {
  const SlideDownItem({
    Key key,
    this.title,
    this.body,
    this.isExpanded: false,
    this.onLongPress,
  }) : super(key: key);

  final bool isExpanded;
  final String title;
  final Widget body;
  final VoidCallback onLongPress;

  @override
  SlideDownItemState createState() => SlideDownItemState();
}

class SlideDownItemState extends State<SlideDownItem> {
  int id;
  bool isExpanded;

  @override
  void initState() {
    super.initState();
    final Random rand = Random();
    id = rand.nextInt(100);
    isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    final Widget body = AnimatedCrossFade(
      firstChild: Container(height: 0.0),
      secondChild: widget.body,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: Duration(milliseconds: 350),
    );

    final Widget header = Material(
      color: Colors.white,
      elevation: isExpanded ? 1.0 : 0.0,
      child: GestureDetector(
        child: InkWell(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                  child: Text(
                    widget.title,
                    style: theme.title.copyWith(fontSize: 14.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                    isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ),
            ],
          ),
          onTap: () => setState(() => isExpanded = !isExpanded),
        ),
        onLongPress: widget.onLongPress ?? () {},
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        header,
        body,
      ],
    );
  }
}
