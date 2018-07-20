import 'package:flutter/material.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/utils/tm_format_naira.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class StatsWidget extends StatelessWidget {
  final StatsModel stats;
  final double height;

  const StatsWidget({
    Key key,
    @required this.height,
    @required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: TMBorderSide(),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: statsTile(
              context,
              count: stats.jobs.pending.toString(),
              title: "Pending",
            ),
          ),
          Container(
            color: kBorderSideColor,
            width: 1.0,
            height: height,
            margin: EdgeInsets.only(left: 0.0, right: 0.0),
          ),
          Expanded(
            child: statsTile(
              context,
              count: formatNaira(stats.payments.completed),
              title: "Received",
            ),
          ),
          Container(
            color: kBorderSideColor,
            width: 1.0,
            height: height,
            margin: EdgeInsets.only(left: 0.0, right: 0.0),
          ),
          Expanded(
            child: statsTile(
              context,
              count: stats.jobs.completed.toString(),
              title: "Completed",
            ),
          ),
        ],
      ),
    );
  }

  Widget statsTile(BuildContext context, {String count, String title}) {
    final TMTheme theme = TMTheme.of(context);
    return new Column(
      children: <Widget>[
        new Text(
          count,
          style: new TextStyle(
              color: theme.textColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2.0),
        new Text(
          title,
          style: new TextStyle(color: theme.textColor, fontSize: 12.0),
        ),
      ],
    );
  }
}
