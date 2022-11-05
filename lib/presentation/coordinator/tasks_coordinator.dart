import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/utils/route_transitions.dart';

import '../screens/tasks/tasks.dart';
import 'coordinator_base.dart';

@immutable
class TasksCoordinator extends CoordinatorBase {
  const TasksCoordinator(super.navigatorKey);

  void toTasks() {
    navigator?.push<void>(RouteTransitions.slideIn(const TasksPage()));
  }
}
