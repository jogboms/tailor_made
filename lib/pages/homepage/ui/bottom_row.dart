import 'package:flutter/material.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/measures/measures_manage.dart';
import 'package:tailor_made/pages/tasks/tasks.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class BottomRowWidget extends StatelessWidget {
  final StatsModel stats;
  final AccountModel account;
  final double height;

  const BottomRowWidget({
    Key key,
    @required this.height,
    @required this.stats,
    @required this.account,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height,
      decoration: new BoxDecoration(
        border: new Border(bottom: TMBorderSide()),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border(
                  right: TMBorderSide(),
                ),
              ),
              child: TMGridTile(
                color: kPrimaryColor,
                icon: Icons.content_cut,
                title: "Measures",
                subTitle: "Custom",
                onPressed: () =>
                    TMNavigate(context, MeasuresManagePage(account: account)),
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              child: TMGridTile(
                color: Colors.grey,
                icon: Icons.event,
                title: "Tasks",
                subTitle: "${stats.jobs.pending} Pending",
                onPressed: () => TMNavigate(context, TasksPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
