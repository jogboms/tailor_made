import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/screens/homepage/_partials/helpers.dart';

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
      decoration: const BoxDecoration(border: Border(bottom: MkBorderSide())),
      child: Row(
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(border: Border(right: MkBorderSide())),
              child: TMGridTile(
                color: kPrimaryColor,
                icon: Icons.content_cut,
                title: "Measures",
                subTitle: "Custom",
                onPressed: () => Dependencies.di().measuresCoordinator.toManageMeasures(account.uid),
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
                onPressed: () => Dependencies.di().tasksCoordinator.toTasks(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
