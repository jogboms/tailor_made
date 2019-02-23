import 'package:flutter/widgets.dart';

class FixedHeightScrollView extends StatelessWidget {
  const FixedHeightScrollView({
    Key key,
    @required this.child,
    this.padding,
  })  : assert(child != null),
        super(key: key);

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraint) {
        return SingleChildScrollView(
          padding: padding ?? EdgeInsets.zero,
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size.fromHeight(
                constraint.biggest.longestSide + _media.viewInsets.bottom,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
