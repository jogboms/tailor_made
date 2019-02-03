import 'package:flutter/widgets.dart';

class MkCacheBuilder<T> extends StatefulWidget {
  const MkCacheBuilder({
    Key key,
    @required this.once,
    @required this.builder,
  })  : assert(once != null),
        assert(builder != null),
        super(key: key);

  final T Function() once;
  final Widget Function(BuildContext context, T cache) builder;

  @override
  _MkCacheBuilderState<T> createState() => _MkCacheBuilderState<T>();
}

class _MkCacheBuilderState<T> extends State<MkCacheBuilder<T>> {
  bool hasDispatched = false;
  T cache;

  @override
  Widget build(BuildContext context) {
    if (!hasDispatched) {
      hasDispatched = true;
      cache = widget.once();
    }

    return widget.builder(context, cache);
  }
}
