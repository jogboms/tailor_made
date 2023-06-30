import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/theme.dart';

class SlideDownItem extends StatefulWidget {
  const SlideDownItem({
    super.key,
    required this.title,
    required this.body,
    this.isExpanded = false,
    this.onLongPress,
  });

  final bool isExpanded;
  final String title;
  final Widget body;
  final VoidCallback? onLongPress;

  @override
  State<SlideDownItem> createState() => _SlideDownItemState();
}

class _SlideDownItemState extends State<SlideDownItem> {
  late bool _isExpanded = widget.isExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _SliderHeader(
          title: widget.title,
          isExpanded: _isExpanded,
          onLongPress: widget.onLongPress,
          onExpand: () => setState(() => _isExpanded = !_isExpanded),
        ),
        _SlideBody(isExpanded: _isExpanded, child: widget.body),
      ],
    );
  }
}

class _SliderHeader extends StatelessWidget {
  const _SliderHeader({
    this.isExpanded = false,
    required this.title,
    required this.onExpand,
    required this.onLongPress,
  });

  final String title;
  final bool isExpanded;
  final VoidCallback onExpand;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      elevation: isExpanded ? 1.0 : 0.0,
      child: GestureDetector(
        onLongPress: onLongPress ?? () {},
        child: InkWell(
          onTap: onExpand,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                  child: Text(title, style: theme.title.copyWith(fontSize: 14.0)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideBody extends StatelessWidget {
  const _SlideBody({required this.child, required this.isExpanded});

  final Widget child;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: const SizedBox(width: double.infinity),
      secondChild: child,
      sizeCurve: Curves.decelerate,
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 250),
    );
  }
}
