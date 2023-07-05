import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/presentation/theme.dart';

import '../../../utils.dart';

class OutDatedPage extends StatelessWidget {
  const OutDatedPage({super.key, required this.onUpdate});

  final VoidCallback onUpdate;

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
            l10n.outOfDateTitle,
            style: textTheme.copyWith(color: Colors.black87, fontWeight: AppFontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Text(
              l10n.outOfDateMessage,
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
            onPressed: onUpdate,
            icon: const Icon(Icons.get_app),
            label: Text(l10n.outOfDateUpdateCaption),
          ),
        ],
      ),
    );
  }
}
