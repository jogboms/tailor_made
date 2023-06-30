import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:timeago/timeago.dart' as time_ago;

class TaskListItem extends StatelessWidget {
  const TaskListItem({super.key, required this.task});

  final JobEntity task;

  static const int _kDayLimit = 5;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppColorTheme appColorTheme = theme.appTheme.color;

    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.event, color: theme.hintColor),
      ),
      trailing: Icon(Icons.timelapse, color: _iconColor(appColorTheme)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(task.name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: AppFontWeight.bold)),
          const SizedBox(height: 2.0),
          Row(
            children: <Widget>[
              Icon(Icons.arrow_downward, color: appColorTheme.success, size: 11.0),
              const SizedBox(width: 2.0),
              Text(
                AppDate(task.dueAt, day: 'EEEE', month: 'MMMM', year: 'yyyy').formatted!,
              ),
            ],
          ),
        ],
      ),
      subtitle: Row(
        children: <Widget>[
          Icon(Icons.arrow_downward, color: appColorTheme.danger, size: 11.0),
          const SizedBox(width: 2.0),
          Text(time_ago.format(task.dueAt, allowFromNow: true)),
        ],
      ),
      onTap: () => context.registry.get<JobsCoordinator>().toJob(task),
    );
  }

  Color _iconColor(AppColorTheme appColorTheme) {
    final DateTime now = clock.now();
    if (now.isAfter(task.dueAt)) {
      return appColorTheme.danger;
    }

    final int diff = task.dueAt.difference(now).inDays;
    if (diff >= 0 && diff < _kDayLimit) {
      return appColorTheme.warning;
    }

    return appColorTheme.success;
  }
}
