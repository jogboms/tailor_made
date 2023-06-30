import 'package:flutter/material.dart';

class EmptyResultView extends StatelessWidget {
  const EmptyResultView({super.key, this.message = 'No results'});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Opacity(
      opacity: .5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.equalizer, color: colorScheme.primary, size: 36.0),
          const SizedBox(height: 8.0),
          Text(message, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
