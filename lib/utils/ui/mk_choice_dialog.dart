import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/widgets/_partials/mk_clear_button.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

Future<bool?> mkChoiceDialog({String? title, required String message, required BuildContext context}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => _MkChoiceDialog(
        title: title,
        message: message,
      ),
    );

class _MkChoiceDialog extends StatelessWidget {
  const _MkChoiceDialog({required this.title, required this.message});

  final String? title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context)!;
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: Text(message),
      titleTextStyle: theme.title.copyWith(color: MkColors.primary),
      contentTextStyle: theme.subhead1Semi.copyWith(height: 1.5),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      elevation: 2,
      actions: <Widget>[
        MkClearButton(
          color: kHintColor,
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context, false),
        ),
        MkClearButton(
          child: const Text('Continue'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
