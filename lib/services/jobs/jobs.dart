import 'dart:io';

import 'package:injector/injector.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/job.dart';

abstract class Jobs {
  static Jobs di() => Injector.appInstance.getDependency<Jobs>();

  Stream<List<JobModel>> fetchAll();

  Storage createFile(File file);

  Stream<JobModel> update(JobModel job);
}
