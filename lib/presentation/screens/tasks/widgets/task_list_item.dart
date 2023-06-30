import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:timeago/timeago.dart' as time_ago;

class TaskListItem extends StatelessWidget {
  const TaskListItem({super.key, required this.task});

  final JobEntity task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      leading: const CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.event, color: kHintColor),
      ),
      trailing: Icon(Icons.timelapse, color: _iconColor),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(task.name, style: Theme.of(context).subhead1Bold),
          const SizedBox(height: 2.0),
          Row(
            children: <Widget>[
              const Icon(Icons.arrow_downward, color: Colors.green, size: 11.0),
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
          const Icon(Icons.arrow_downward, color: Colors.red, size: 11.0),
          const SizedBox(width: 2.0),
          Text(time_ago.format(task.dueAt, allowFromNow: true)),
        ],
      ),
      onTap: () => context.registry.get<JobsCoordinator>().toJob(task),
    );
  }

  Color get _iconColor {
    final DateTime now = clock.now();
    if (now.isAfter(task.dueAt)) {
      return Colors.redAccent.shade400;
    }

    final int diff = task.dueAt.difference(now).inDays;
    if (diff >= 0 && diff < _kDayLimit) {
      return Colors.orangeAccent.shade400;
    }

    return Colors.greenAccent.shade400;
  }
}

const int _kDayLimit = 5;
