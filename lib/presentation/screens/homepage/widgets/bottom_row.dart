import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/routing.dart';

import '../../../utils.dart';
import 'helpers.dart';

class BottomRowWidget extends StatelessWidget {
  const BottomRowWidget({super.key, required this.stats});

  final StatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final L10n l10n = context.l10n;

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
                title: l10n.measurementsPageTitle,
                subTitle: l10n.customCaption,
                onPressed: () => context.router.toManageMeasures(),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                color: colorScheme.outline,
                icon: Icons.event,
                title: l10n.tasksPageTitle,
                subTitle: l10n.tasksCaption(stats.jobs.pending.toInt()),
                onPressed: () => context.router.toTasks(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
