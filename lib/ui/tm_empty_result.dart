import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_colors.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TMEmptyResult extends StatelessWidget {
  final String message;

  TMEmptyResult({
    Key key,
    this.message = "No results",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TMTheme theme = TMTheme.of(context);
    return Opacity(
      opacity: .5,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.equalizer,
            color: TMColors.light_grey,
            size: 36.0,
          ),
          const SizedBox(height: 8.0),
          new Text(
            message,
            style: theme.smallTextStyle,
          )
        ],
      ),
    );
  }
}
