import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({super.key, required this.stats});

  final StatsEntity stats;

  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border(bottom: Divider.createBorderSide(context)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _StatTile(title: l10n.pendingCaption, count: stats.jobs.pending.toInt().toString()),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _StatTile(title: l10n.receivedCaption, count: AppMoney(stats.payments.completed).formatted),
          ),
          const _VerticalDivider(),
          Expanded(
            child: _StatTile(title: l10n.completedCaption, count: stats.jobs.completed.toInt().toString()),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    final DividerThemeData dividerTheme = DividerTheme.of(context);
    return Container(
      color: dividerTheme.color,
      width: dividerTheme.thickness,
      height: 40.0,
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.count, required this.title});

  final String count;
  final String title;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Text(count, style: textTheme.titleLarge?.copyWith(fontWeight: AppFontWeight.medium)),
        const SizedBox(height: 2.0),
        Text(title, style: textTheme.bodySmall),
      ],
    );
  }
}
