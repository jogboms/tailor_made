import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/pages/tasks/task_list_item.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/jobs.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => new _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new StoreConnector<ReduxState, JobsViewModel>(
      converter: (store) => JobsViewModel(store),
      builder: (BuildContext context, JobsViewModel vm) {
        return new Scaffold(
          backgroundColor: theme.scaffoldColor,
          appBar: appBar(
            context,
            title: "Tasks",
          ),
          body: buildBody(vm),
        );
      },
    );
  }

  Widget buildBody(JobsViewModel vm) {
    if (vm.isLoading) {
      return loadingSpinner();
    }
    final _tasks = vm.tasks;

    return _tasks == null || _tasks.isEmpty
        ? Center(
            child: TMEmptyResult(message: "No tasks available"),
          )
        : new ListView.separated(
            itemCount: _tasks.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 96.0),
            itemBuilder: (context, index) => TaskListItem(task: _tasks[index]),
            separatorBuilder: (_, int index) => new Divider(height: 8.0),
          );
  }
}
