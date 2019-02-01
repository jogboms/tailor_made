import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';

Future<bool> mkChoiceDialog({
  @required String title,
  @required String message,
  @required BuildContext context,
}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => _MkChoiceDialog(
            title: title,
            message: message,
          ),
    );

class _MkChoiceDialog extends StatelessWidget {
  const _MkChoiceDialog({
    Key key,
    @required this.title,
    @required this.message,
  }) : super(key: key);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final _theme = MkTheme.of(context);
    return AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: Text(message, textAlign: TextAlign.center),
      titleTextStyle: _theme.bodySemi.copyWith(color: MkColors.primary),
      contentTextStyle: _theme.bodyMedium.copyWith(height: 1.5),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8.0),
      elevation: 2,
      actions: <Widget>[
        MkClearButton(
          color: kHintColor,
          child: const Text("Close"),
          onPressed: () => Navigator.pop(context, false),
        ),
        MkClearButton(
          child: const Text("Yes"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
