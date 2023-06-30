import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/widgets.dart';

Future<bool?> showChoiceDialog({String? title, required String message, required BuildContext context}) =>
    showDialog<bool>(
      context: context,
      builder: (_) => _ChoiceDialog(
        title: title,
        message: message,
      ),
    );

class _ChoiceDialog extends StatelessWidget {
  const _ChoiceDialog({required this.title, required this.message});

  final String? title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: Text(message),
      titleTextStyle: theme.textTheme.pageTitle.copyWith(color: theme.colorScheme.primary),
      contentTextStyle: theme.textTheme.bodyLarge?.copyWith(height: 1.5, fontWeight: AppFontWeight.semibold),
      contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
      elevation: 2,
      actions: <Widget>[
        AppClearButton(
          color: theme.hintColor,
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context, false),
        ),
        AppClearButton(
          child: const Text('Continue'),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
