import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/utils/mk_money.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    Key key,
    @required this.height,
    @required this.stats,
  }) : super(key: key);

  final StatsModel stats;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: const BoxDecoration(
        border: const Border(
          bottom: const MkBorderSide(),
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
          _Divider(height: height),
          Expanded(
            child: _StatTile(
              title: "Received",
              count: MkMoney(stats.payments.completed).format,
            ),
          ),
          _Divider(height: height),
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
  const _Divider({
    Key key,
    @required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBorderSideColor,
      width: 1.0,
      height: height,
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
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
        Text(count, style: MkTheme.of(context).headline),
        const SizedBox(height: 2.0),
        Text(title, style: MkTheme.of(context).small),
      ],
    );
  }
}
