import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class SlideDownItem extends StatefulWidget {
  const SlideDownItem({
    Key key,
    this.title,
    this.body,
    this.isExpanded = false,
    this.onLongPress,
  }) : super(key: key);

  final bool isExpanded;
  final String title;
  final Widget body;
  final VoidCallback onLongPress;

  @override
  _SlideDownItemState createState() => _SlideDownItemState();
}

class _SlideDownItemState extends State<SlideDownItem> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SliderHeader(
          title: widget.title,
          isExpanded: isExpanded,
          onLongPress: widget.onLongPress,
          onExpand: () => setState(() => isExpanded = !isExpanded),
        ),
        _SlideBody(
          isExpanded: isExpanded,
          child: widget.body,
        ),
      ],
    );
  }
}

class _SliderHeader extends StatelessWidget {
  const _SliderHeader({
    Key key,
    @required this.isExpanded,
    @required this.title,
    @required this.onExpand,
    @required this.onLongPress,
  }) : super(key: key);

  final String title;
  final bool isExpanded;
  final VoidCallback onExpand;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    return Material(
      elevation: isExpanded ? 1.0 : 0.0,
      child: GestureDetector(
        child: InkWell(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    top: 16.0,
                    bottom: 16.0,
                  ),
                  child: Text(
                    title,
                    style: theme.title.copyWith(fontSize: 14.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                ),
              ),
            ],
          ),
          onTap: onExpand,
        ),
        onLongPress: onLongPress ?? () {},
      ),
    );
  }
}

class _SlideBody extends StatelessWidget {
  const _SlideBody({
    Key key,
    @required this.child,
    @required this.isExpanded,
  }) : super(key: key);

  final Widget child;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox(width: double.infinity),
      secondChild: child,
      sizeCurve: Curves.decelerate,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 250),
    );
  }
}
