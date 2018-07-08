import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class StatsWidget extends StatelessWidget {
  final List<JobModel> jobs;

  StatsWidget({
    Key key,
    @required this.jobs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int completedLength = jobs.where((job) => job.isComplete).length;
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
              count: (jobs.length - completedLength).toString(),
              title: "Pending",
            ),
          ),
          Container(
            color: borderSideColor,
            width: 1.0,
            height: 40.0,
            margin: EdgeInsets.only(left: 30.0, right: 30.0),
          ),
          Expanded(
            // TODO
            child: statsTile(
              context,
              count: "23.6k",
              title: "Received",
            ),
          ),
          Container(
            color: borderSideColor,
            width: 1.0,
            height: 40.0,
            margin: EdgeInsets.only(left: 30.0, right: 30.0),
          ),
          Expanded(
            // TODO
            child: statsTile(
              context,
              count: completedLength.toString(),
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
          style: new TextStyle(color: theme.textColor, fontSize: 20.0, fontWeight: FontWeight.w600),
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
