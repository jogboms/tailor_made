import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/utils/mk_money.dart';

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
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: MkBorderSide(),
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
              count: MkMoney(stats.payments.completed).format,
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
    return Column(
      children: <Widget>[
        Text(
          count,
          style: TextStyle(
              color: kTextBaseColor,
              fontSize: 20.0,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2.0),
        Text(
          title,
          style: TextStyle(color: kTextBaseColor, fontSize: 12.0),
        ),
      ],
    );
  }
}
