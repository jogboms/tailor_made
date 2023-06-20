import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/theme.dart';
import 'package:tailor_made/presentation/utils.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({super.key, required this.stats});

  final StatsModel stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: const BoxDecoration(border: Border(bottom: AppBorderSide())),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _StatTile(title: 'Pending', count: stats.jobs.pending.toString()),
          ),
          const _Divider(),
          Expanded(
            child: _StatTile(title: 'Received', count: AppMoney(stats.payments.completed).formatted),
          ),
          const _Divider(),
          Expanded(
            child: _StatTile(title: 'Completed', count: stats.jobs.completed.toString()),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(color: kBorderSideColor, width: 1.0, height: _kStatGridsHeight);
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.count, required this.title});

  final String count;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(count, style: ThemeProvider.of(context)!.headline),
        const SizedBox(height: 2.0),
        Text(title, style: ThemeProvider.of(context)!.small),
      ],
    );
  }
}

const double _kStatGridsHeight = 40.0;
