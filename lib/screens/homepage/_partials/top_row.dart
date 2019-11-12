import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/screens/contacts/contacts.dart';
import 'package:tailor_made/screens/homepage/_partials/helpers.dart';
import 'package:tailor_made/screens/jobs/jobs.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

class TopRowWidget extends StatelessWidget {
  const TopRowWidget({Key key, @required this.stats}) : super(key: key);

  final StatsModel stats;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(border: Border(bottom: MkBorderSide())),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(border: Border(right: MkBorderSide())),
              child: TMGridTile(
                icon: Icons.supervisor_account,
                color: Colors.orangeAccent,
                title: "Contacts",
                subTitle: "${stats.contacts.total} Contacts",
                onPressed: () => Navigator.of(context).push<void>(MkNavigate.slideIn<void>(const ContactsPage())),
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
                onPressed: () => Navigator.of(context).push<void>(MkNavigate.slideIn<void>(const JobsPage())),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
