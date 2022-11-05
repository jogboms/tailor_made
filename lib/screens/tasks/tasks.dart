import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/jobs/view_model.dart';
import 'package:tailor_made/screens/tasks/_partials/task_list_item.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MkAppBar(title: Text('Tasks')),
      body: ViewModelSubscriber<AppState, JobsViewModel>(
        converter: JobsViewModel.new,
        builder: (BuildContext context, _, JobsViewModel vm) {
          if (vm.isLoading) {
            return const MkLoadingSpinner();
          }
          final List<JobModel> tasks = vm.tasks;

          if (tasks.isEmpty) {
            return const Center(child: EmptyResultView(message: 'No tasks available'));
          }

          return ListView.separated(
            itemCount: tasks.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 96.0),
            itemBuilder: (_, int index) => TaskListItem(task: tasks[index]),
            separatorBuilder: (_, __) => const Divider(height: 0.0),
          );
        },
      ),
    );
  }
}
