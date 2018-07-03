import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'job.dart';
import 'models/job_list.model.dart';

class JobList extends StatelessWidget {
  final List<JobListModel> lists;

  JobList({this.lists});

  @override
  Widget build(BuildContext context) {
    SliverChildListDelegate delegate = new SliverChildListDelegate(
      lists.map((list) => JobListItem(list: list)).toList(),
    );

    return SliverList(
      delegate: delegate,
    );
  }
}

class JobListItem extends StatelessWidget {
  final JobListModel list;

  JobListItem({this.list});

  @override
  Widget build(BuildContext context) {
    onTapCheck() {
      print("onTapCheck");
    }

    onTapList() {
      print("onTapList");
      TMNavigate(context, JobPage());
    }

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
                      new TextSpan(text: "15\n", style: ralewayLight(30.0, Colors.white)),
                      new TextSpan(
                        text: "MAY",
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
                    Text("2 Italian Gowns", style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    Text("₦3,000", style: TextStyle(color: textBaseColor)),
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
