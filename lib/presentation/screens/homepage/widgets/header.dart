import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.account});

  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final L10n l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 40.0),
      width: double.infinity,
      decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(context))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            l10n.helloMessage,
            style: textTheme.headlineLarge?.copyWith(fontWeight: AppFontWeight.light, letterSpacing: 2.5),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Text(
              account.storeName,
              style: const TextStyle(fontSize: 52.0, fontWeight: AppFontWeight.regular, height: 1.15),
              maxLines: 2,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
          ),
          Text(
            AppDate(clock.now(), day: 'EEEE', month: 'MMMM').formatted!,
            style: textTheme.labelLarge?.copyWith(height: 1.75),
          ),
        ],
      ),
    );
  }
}
