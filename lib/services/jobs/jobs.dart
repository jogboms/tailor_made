import 'dart:io';

import 'package:injector/injector.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/repository/models.dart';

abstract class Jobs<T extends Repository> {
  Jobs() : repository = Injector.appInstance.getDependency<Repository>();

  final T repository;

  Stream<List<JobModel>> fetchAll();

  Storage createFile(File file);

  Stream<JobModel> update(JobModel job);
}
