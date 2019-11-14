import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/coordinator/coordinator_base.dart';
import 'package:tailor_made/screens/tasks/tasks.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

@immutable
class TasksCoordinator extends CoordinatorBase {
  const TasksCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  static TasksCoordinator di() => Injector.appInstance.getDependency<TasksCoordinator>();

  void toTasks() {
    navigator?.push<void>(MkNavigate.slideIn(const TasksPage()));
  }
}
