import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/screens/tasks/providers/tasks_provider.dart';
import 'package:tailor_made/presentation/widgets.dart';

import 'widgets/task_list_item.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: Text('Tasks')),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) => ref.watch(tasksProvider).when(
              data: (List<JobEntity> data) {
                if (data.isEmpty) {
                  return const Center(child: EmptyResultView(message: 'No tasks available'));
                }

                return ListView.separated(
                  itemCount: data.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 96.0),
                  itemBuilder: (_, int index) => TaskListItem(task: data[index]),
                  separatorBuilder: (_, __) => const Divider(height: 0.0),
                );
              },
              error: ErrorView.new,
              loading: () => child!,
            ),
        child: const Center(child: LoadingSpinner()),
      ),
    );
  }
}
