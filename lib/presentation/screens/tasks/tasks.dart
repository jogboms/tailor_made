import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';
import 'package:tailor_made/presentation/widgets.dart';

import 'widgets/task_list_item.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Tasks')),
      body: ViewModelSubscriber<AppState, JobsViewModel>(
        converter: JobsViewModel.new,
        builder: (BuildContext context, _, JobsViewModel vm) {
          if (vm.isLoading) {
            return const LoadingSpinner();
          }
          final List<JobEntity> tasks = vm.tasks;

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
