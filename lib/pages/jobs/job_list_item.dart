import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tailor_made/pages/jobs/job.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/utils/tm_months.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

var nairaFormat = new NumberFormat.currency(symbol: "");

class JobListItem extends StatelessWidget {
  final JobModel job;

  JobListItem({
    Key key,
    this.job,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _date = job.createdAt;
    final _price = nairaFormat.format(job.price ?? 0);

    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: TMBorderSide()),
      ),
      child: new InkWell(
        onTap: () => TMNavigate(context, JobPage(job: job)),
        child: new Padding(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: new Text.rich(
                  new TextSpan(
                    children: [
                      new TextSpan(text: "${_date.day}\n", style: ralewayLight(20.0, Colors.black54)),
                      new TextSpan(
                        text: MONTHS_SHORT[_date.month - 1].toUpperCase(),
                        style: ralewayLight(10.0, Colors.black).copyWith(
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
                    Text(job.name, style: TextStyle(fontSize: 14.0, color: Colors.black)),
                    Text("NGN$_price", style: TextStyle(fontSize: 12.0, color: textBaseColor)),
                  ],
                ),
              ),
              new Icon(
                Icons.check,
                color: job.isComplete ? Colors.green : textBaseColor.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
