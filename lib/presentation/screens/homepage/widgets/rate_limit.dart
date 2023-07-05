import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/presentation/theme.dart';

import '../../../utils.dart';

class RateLimitPage extends StatelessWidget {
  const RateLimitPage({super.key, required this.onSkippedPremium, required this.onSignUp});

  final VoidCallback onSkippedPremium;
  final VoidCallback onSignUp;

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
            l10n.usagePolicyTitle,
            style: textTheme.copyWith(color: Colors.black87, fontWeight: AppFontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Text(
              l10n.usagePolicyMessage,
              style: textTheme.copyWith(color: colorScheme.outline),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32.0),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.outline,
            ),
            onPressed: onSkippedPremium,
            child: Text(l10n.usagePolicyNoCaption),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondary,
              shape: const StadiumBorder(),
            ),
            onPressed: onSignUp,
            icon: const Icon(Icons.done),
            label: Text(l10n.usagePolicyYesCaption),
          ),
        ],
      ),
    );
  }
}
