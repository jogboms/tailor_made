import 'package:flutter/widgets.dart';

class MkAppBuilder extends StatefulWidget {
  const MkAppBuilder({Key key, this.builder}) : super(key: key);

  final Function(BuildContext) builder;

  @override
  MkAppBuilderState createState() => MkAppBuilderState();

  static MkAppBuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<MkAppBuilderState>());
  }
}

class MkAppBuilderState extends State<MkAppBuilder> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  void rebuild() {
    setState(() {});
  }
}
