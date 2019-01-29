import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class ErrorResultView extends StatelessWidget {
  const ErrorResultView({
    Key key,
    this.message = "Error occured",
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);
    return Opacity(
      opacity: .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error_outline,
            color: kPrimaryColor,
            size: 50.0,
          ),
          const SizedBox(height: 16.0),
          Text(
            message,
            style: theme.small.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
