import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TMErrorResult extends StatelessWidget {
  final String message;

  const TMErrorResult({
    Key key,
    this.message = "Error occured",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return Opacity(
      opacity: .5,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(
            Icons.error_outline,
            color: theme.primaryColor,
            size: 50.0,
          ),
          const SizedBox(height: 16.0),
          new Text(
            message,
            style: theme.smallTextStyle.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
