import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/routing.dart';

import '../../../utils.dart';
import 'helpers.dart';

class TopRowWidget extends StatelessWidget {
  const TopRowWidget({super.key, required this.stats});

  final StatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(context))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(border: Border(right: Divider.createBorderSide(context))),
              child: TMGridTile(
                icon: Icons.supervisor_account,
                color: Colors.orangeAccent,
                title: l10n.contactsPageTitle,
                subTitle: l10n.contactsCaption(stats.contacts.total.toInt()),
                onPressed: () => context.router.toContacts(),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                icon: Icons.work,
                color: Colors.greenAccent.shade400,
                title: l10n.jobsPageTitle,
                subTitle: l10n.jobsCaption(stats.jobs.total.toInt()),
                onPressed: () => context.router.toJobs(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
