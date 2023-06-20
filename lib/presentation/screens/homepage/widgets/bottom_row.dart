import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'helpers.dart';

class BottomRowWidget extends StatelessWidget {
  const BottomRowWidget({
    super.key,
    required this.stats,
    required this.account,
  });

  final StatsModel stats;
  final AccountEntity account;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(bottom: AppBorderSide())),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(border: Border(right: AppBorderSide())),
              child: TMGridTile(
                color: kPrimaryColor,
                icon: Icons.content_cut,
                title: 'Measures',
                subTitle: 'Custom',
                onPressed: () => context.registry.get<MeasuresCoordinator>().toManageMeasures(account.uid),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                color: Colors.grey,
                icon: Icons.event,
                title: 'Tasks',
                subTitle: '${stats.jobs.pending} Pending',
                onPressed: () => context.registry.get<TasksCoordinator>().toTasks(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
