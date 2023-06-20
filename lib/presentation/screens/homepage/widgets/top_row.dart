import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'helpers.dart';

class TopRowWidget extends StatelessWidget {
  const TopRowWidget({super.key, required this.stats});

  final StatsModel stats;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(bottom: AppBorderSide())),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(border: Border(right: AppBorderSide())),
              child: TMGridTile(
                icon: Icons.supervisor_account,
                color: Colors.orangeAccent,
                title: 'Contacts',
                subTitle: '${stats.contacts.total} Contacts',
                onPressed: () => context.registry.get<ContactsCoordinator>().toContacts(),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                icon: Icons.work,
                color: Colors.greenAccent.shade400,
                title: 'Jobs',
                subTitle: '${stats.jobs.total} Total',
                onPressed: () => context.registry.get<JobsCoordinator>().toJobs(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
