import 'package:flutter/widgets.dart';

class MkOnceBuilder extends StatefulWidget {
  const MkOnceBuilder({
    Key key,
    @required this.once,
    @required this.child,
  })  : assert(once != null),
        assert(child != null),
        super(key: key);

  final VoidCallback once;
  final Widget child;

  @override
  _MkOnceBuilderState createState() => _MkOnceBuilderState();
}

class _MkOnceBuilderState extends State<MkOnceBuilder> {
  bool hasDispatched = false;

  @override
  Widget build(BuildContext context) {
    if (!hasDispatched) {
      hasDispatched = true;
      widget.once();
    }

    return widget.child;
  }
}
