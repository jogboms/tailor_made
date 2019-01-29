import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/view_models/jobs.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/tasks/task_list_item.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, JobsViewModel>(
      converter: (store) => JobsViewModel(store),
      builder: (
        BuildContext context,
        DispatchFunction dispatcher,
        JobsViewModel vm,
      ) {
        return Scaffold(
          appBar: MkAppBar(
            title: Text("Tasks"),
          ),
          body: buildBody(vm),
        );
      },
    );
  }

  Widget buildBody(JobsViewModel vm) {
    if (vm.isLoading) {
      return const MkLoadingSpinner();
    }
    final _tasks = vm.tasks;

    return _tasks == null || _tasks.isEmpty
        ? Center(
            child: const EmptyResultView(message: "No tasks available"),
          )
        : ListView.separated(
            itemCount: _tasks.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 96.0),
            itemBuilder: (context, index) => TaskListItem(task: _tasks[index]),
            separatorBuilder: (_, int index) => const Divider(height: 8.0),
          );
  }
}
