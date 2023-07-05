import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';

class NoticeDialog extends StatelessWidget {
  const NoticeDialog({super.key, required this.account});

  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textTheme = theme.textTheme.bodyLarge!;
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          borderRadius: BorderRadius.circular(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 32.0),
              CircleAvatar(
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                radius: 24.0,
                child: const Icon(Icons.notifications_none, size: 36.0),
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  account.notice,
                  style: textTheme.copyWith(color: colorScheme.outline),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48.0),
            ],
          ),
        ),
      ),
    );
  }
}
