import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/presentation/theme.dart';

import '../../../utils.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key, required this.onSendMail});

  final VoidCallback onSendMail;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle textTheme = theme.textTheme.bodyLarge!;
    final ColorScheme colorScheme = theme.colorScheme;
    final L10n l10n = context.l10n;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SpinKitFadingCube(color: colorScheme.outlineVariant),
          const SizedBox(height: 48.0),
          Text(
            l10n.accessDeniedTitle,
            style: textTheme.copyWith(color: Colors.black87, fontWeight: AppFontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Text(
              l10n.accessDeniedMessage,
              style: textTheme.copyWith(color: colorScheme.outline),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32.0),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              shape: const StadiumBorder(),
            ),
            onPressed: onSendMail,
            icon: const Icon(Icons.mail),
            label: Text(l10n.accessDeniedSendMailCaption),
          ),
        ],
      ),
    );
  }
}
