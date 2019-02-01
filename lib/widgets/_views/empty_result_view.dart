import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class EmptyResultView extends StatelessWidget {
  const EmptyResultView({
    Key key,
    this.message = "No results",
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
          const Icon(
            Icons.equalizer,
            color: kPrimaryColor,
            size: 36.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            message,
            style: theme.small.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}
