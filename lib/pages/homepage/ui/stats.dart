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
    Widget statsTile({int count, String title, String subTitle}) {
      final TMTheme theme = TMTheme.of(context);
      return new Row(
        children: <Widget>[
          new Padding(
            child: new Text(
              count.toString(),
              style: new TextStyle(color: theme.textColor, fontSize: 18.0),
            ),
            padding: EdgeInsets.only(right: 10.0),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                title,
                style: new TextStyle(color: theme.textColor, fontSize: 13.0, fontWeight: FontWeight.w300),
              ),
              new Text(
                subTitle,
                style: new TextStyle(color: theme.textColor, fontSize: 13.0, fontWeight: FontWeight.w300),
              ),
            ],
          )
        ],
      );
    }

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
            child: statsTile(count: jobs.length, title: "Created", subTitle: "Projects"),
          ),
          Container(
            color: borderSideColor,
            width: 1.0,
            height: 40.0,
            margin: EdgeInsets.only(left: 30.0, right: 30.0),
          ),
          Expanded(
            // TODO
            child: statsTile(count: 62, title: "Completed", subTitle: "Projects"),
          ),
        ],
      ),
    );
  }
}
