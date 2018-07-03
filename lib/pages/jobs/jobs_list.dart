import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tailor_made/pages/jobs/job.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/utils/tm_months.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

var nairaFormat = new NumberFormat.currency(symbol: "");

class JobList extends StatelessWidget {
  final List<JobModel> jobs;

  JobList({
    Key key,
    this.jobs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No jobs available"),
      );
    }

    return SliverList(
      delegate: new SliverChildListDelegate(
        jobs.map((job) => JobListItem(job: job)).toList(),
      ),
    );
  }
}

class JobListItem extends StatelessWidget {
  final JobModel job;

  JobListItem({this.job});

  @override
  Widget build(BuildContext context) {
    onTapCheck() {
      print("onTapCheck");
    }

    onTapList() {
      print("onTapList");
      TMNavigate(context, JobPage(job: job));
    }

    final _date = job.createdAt;
    final _price = nairaFormat.format(job.price ?? 0);

    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: TMBorderSide()),
      ),
      child: new InkWell(
        onTap: onTapList,
        child: new Padding(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                  color: accentColorAlt,
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: new Text.rich(
                  new TextSpan(
                    children: [
                      new TextSpan(text: "${_date.day}\n", style: ralewayLight(30.0, Colors.white)),
                      new TextSpan(
                        text: MONTHS_SHORT[_date.month - 1].toUpperCase(),
                        style: ralewayLight(10.0, Colors.white).copyWith(
                          letterSpacing: 2.0,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              new SizedBox(width: 16.0),
              new Expanded(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(job.name, style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    Text("NGN$_price", style: TextStyle(color: textBaseColor)),
                  ],
                ),
              ),
              new IconButton(
                padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                icon: new Icon(Icons.check_circle_outline, color: Colors.green),
                onPressed: onTapCheck,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
