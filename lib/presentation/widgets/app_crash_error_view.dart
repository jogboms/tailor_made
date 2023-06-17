import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils.dart';
import 'app_icon.dart';
import 'custom_app_bar.dart';

class AppCrashErrorView extends StatelessWidget {
  const AppCrashErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final TextTheme textTheme = theme.textTheme;
    final L10n l10n = context.l10n;
    return Scaffold(
      appBar: CustomAppBar.empty,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 40),
            const Align(alignment: Alignment.centerLeft, child: AppIcon()),
            const SizedBox(height: 38),
            Text(
              l10n.crashViewTitleMessage,
              style: textTheme.displaySmall!.copyWith(
                height: 1.08,
                fontWeight: AppFontWeight.light,
                color: theme.colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 35),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: l10n.crashViewQuoteMessage,
                    style: textTheme.headlineSmall!.copyWith(height: 1.5),
                  ),
                  TextSpan(text: '  —  ', style: textTheme.titleMedium),
                  TextSpan(
                    text: l10n.crashViewQuoteAuthor,
                    style: textTheme.titleMedium!.copyWith(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.crashViewBugMessage1,
              style: textTheme.titleMedium!.copyWith(height: 1.45),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.crashViewBugMessage2,
              style: textTheme.titleMedium!.copyWith(height: 1.45),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
