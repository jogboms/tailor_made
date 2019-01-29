import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkJobDetailRowColumn extends StatelessWidget {
  const MkJobDetailRowColumn({
    Key key,
    @required this.bodyStyle,
    @required this.title,
    @required this.body,
    this.isExpanded = true,
  }) : super(key: key);

  final TextStyle bodyStyle;
  final String title;
  final String body;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final _theme = MkTheme.of(context),
        _titleStyle = _theme.body3.copyWith(color: MkColors.dark.shade400);

    Widget child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(title, style: _titleStyle),
        Text(body, style: bodyStyle),
      ],
    );

    if (isExpanded) {
      child = Expanded(child: child);
    }

    return child;
  }
}
