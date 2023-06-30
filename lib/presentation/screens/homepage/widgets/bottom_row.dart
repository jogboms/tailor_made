import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'helpers.dart';

class BottomRowWidget extends StatelessWidget {
  const BottomRowWidget({super.key, required this.stats});

  final StatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(border: Border(bottom: Divider.createBorderSide(context))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(border: Border(right: Divider.createBorderSide(context))),
              child: TMGridTile(
                color: colorScheme.primary,
                icon: Icons.content_cut,
                title: 'Measures',
                subTitle: 'Custom',
                onPressed: () => context.registry.get<MeasuresCoordinator>().toManageMeasures(),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                color: colorScheme.outline,
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
