import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/screens/homepage/_partials/helpers.dart';
import 'package:tailor_made/widgets/screens/measures/measures_manage.dart';
import 'package:tailor_made/widgets/screens/tasks/tasks.dart';

class BottomRowWidget extends StatelessWidget {
  const BottomRowWidget({
    Key key,
    @required this.stats,
    @required this.account,
  }) : super(key: key);

  final StatsModel stats;
  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: MkBorderSide()),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(
                  right: MkBorderSide(),
                ),
              ),
              child: TMGridTile(
                color: kPrimaryColor,
                icon: Icons.content_cut,
                title: "Measures",
                subTitle: "Custom",
                onPressed: () => MkNavigate(
                  context,
                  const MeasuresManagePage(),
                ),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              child: TMGridTile(
                color: Colors.grey,
                icon: Icons.event,
                title: "Tasks",
                subTitle: "${stats.jobs.pending} Pending",
                onPressed: () => MkNavigate(context, const TasksPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
