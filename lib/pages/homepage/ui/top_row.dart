import 'package:flutter/material.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/pages/contacts/contacts.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/jobs/jobs.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TopRowWidget extends StatelessWidget {
  final StatsModel stats;
  final double height;

  const TopRowWidget({
    Key key,
    @required this.height,
    @required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: height,
      decoration: new BoxDecoration(
        border: new Border(bottom: TMBorderSide()),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: new BoxDecoration(
                border: new Border(right: TMBorderSide()),
              ),
              child: TMGridTile(
                icon: Icons.supervisor_account,
                color: Colors.orangeAccent,
                title: "Contacts",
                subTitle: "${stats.contacts.total} Contacts",
                onPressed: () => TMNavigate(context, ContactsPage()),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: TMGridTile(
                icon: Icons.work,
                color: Colors.greenAccent.shade400,
                title: "Jobs",
                subTitle: "${stats.jobs.total} Total",
                onPressed: () => TMNavigate(context, JobsPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
