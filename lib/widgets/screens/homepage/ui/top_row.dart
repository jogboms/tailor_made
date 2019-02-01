import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/screens/contacts/contacts.dart';
import 'package:tailor_made/widgets/screens/homepage/ui/helpers.dart';
import 'package:tailor_made/widgets/screens/jobs/jobs.dart';

class TopRowWidget extends StatelessWidget {
  const TopRowWidget({
    Key key,
    @required this.height,
    @required this.stats,
  }) : super(key: key);

  final StatsModel stats;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        border: const Border(bottom: const MkBorderSide()),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: const Border(right: const MkBorderSide()),
              ),
              child: TMGridTile(
                icon: Icons.supervisor_account,
                color: Colors.orangeAccent,
                title: "Contacts",
                subTitle: "${stats.contacts.total} Contacts",
                onPressed: () => MkNavigate(context, const ContactsPage()),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                icon: Icons.work,
                color: Colors.greenAccent.shade400,
                title: "Jobs",
                subTitle: "${stats.jobs.total} Total",
                onPressed: () => MkNavigate(context, const JobsPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
