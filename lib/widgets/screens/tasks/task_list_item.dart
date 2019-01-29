import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/utils/mk_dates.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/widgets/screens/jobs/job.dart';
import 'package:timeago/timeago.dart';

const int _kDayLimit = 5;

class TaskListItem extends StatelessWidget {
  const TaskListItem({
    Key key,
    @required this.task,
  }) : super(key: key);

  final JobModel task;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.event,
          color: kHintColor,
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
            style: mkFontBold(16.0, kTextBaseColor),
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
                MkDates(
                  task.dueAt,
                  day: "EEEE",
                  month: "MMMM",
                  year: "yyyy",
                ).format,
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
      onTap: () => MkNavigate(context, JobPage(job: task)),
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
