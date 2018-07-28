import 'package:flutter/material.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/pages/jobs/job.dart';
import 'package:tailor_made/utils/tm_format_date.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:timeago/timeago.dart';

const int _kDayLimit = 5;

class TaskListItem extends StatelessWidget {
  final JobModel task;

  const TaskListItem({
    Key key,
    @required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.event,
          color: theme.textMutedColor,
        ),
      ),
      trailing: Icon(
        Icons.timelapse,
        color: _iconColor,
        // size: 24.0,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            task.name,
            style: ralewayBold(16.0, theme.textColor),
          ),
          SizedBox(height: 2.0),
          Row(
            children: <Widget>[
              Icon(
                Icons.arrow_downward,
                color: Colors.green,
                size: 11.0,
              ),
              SizedBox(width: 2.0),
              Text(
                formatDate(
                  task.dueAt,
                  day: "EEEE",
                  month: "MMMM",
                  year: "yyyy",
                ),
              ),
            ],
          ),
        ],
      ),
      subtitle: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_downward,
            color: Colors.red,
            size: 11.0,
          ),
          SizedBox(width: 2.0),
          Text(timeAgo(task.dueAt, until: true)),
        ],
      ),
      onTap: () => TMNavigate(context, JobPage(job: task)),
    );
  }

  Color get _iconColor {
    final now = DateTime.now();
    if (now.isAfter(task.dueAt)) {
      return Colors.redAccent;
    }
    final diff = task.dueAt.difference(now).inDays;
    if (diff >= 0 && diff < _kDayLimit) {
      return Colors.orangeAccent;
    }
    return Colors.greenAccent;
  }
}
