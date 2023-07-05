import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/domain.dart';

import '../../utils.dart';
import '../../widgets.dart';
import 'providers/tasks_provider.dart';
import 'widgets/task_list_item.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: Text(l10n.tasksPageTitle)),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) => ref.watch(tasksProvider).when(
              data: (List<JobEntity> data) {
                if (data.isEmpty) {
                  return Center(child: EmptyResultView(message: l10n.noTasksAvailableMessage));
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
