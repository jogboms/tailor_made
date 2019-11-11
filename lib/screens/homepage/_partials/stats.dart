import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

const double _kStatGridsHeight = 40.0;

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    Key key,
    @required this.stats,
  }) : super(key: key);

  final StatsModel stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: MkBorderSide(),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _StatTile(
              title: "Pending",
              count: stats.jobs.pending.toString(),
            ),
          ),
          const _Divider(),
          Expanded(
            child: _StatTile(
              title: "Received",
              count: MkMoney(stats.payments.completed).formatted,
            ),
          ),
          const _Divider(),
          Expanded(
            child: _StatTile(
              title: "Completed",
              count: stats.jobs.completed.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBorderSideColor,
      width: 1.0,
      height: _kStatGridsHeight,
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    Key key,
    @required this.count,
    @required this.title,
  }) : super(key: key);

  final String count;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(count, style: ThemeProvider.of(context).headline),
        const SizedBox(height: 2.0),
        Text(title, style: ThemeProvider.of(context).small),
      ],
    );
  }
}
