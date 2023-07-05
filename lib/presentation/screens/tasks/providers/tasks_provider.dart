import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'tasks_provider.g.dart';

@Riverpod(dependencies: <Object>[jobs])
Future<List<JobEntity>> tasks(TasksRef ref) async => ref.watch(
      jobsProvider.selectAsync(
        (_) => _.where((_) => !_.isComplete).sorted((JobEntity a, JobEntity b) => a.dueAt.compareTo(b.dueAt)),
      ),
    );
