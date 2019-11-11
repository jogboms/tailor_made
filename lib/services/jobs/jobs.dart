import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/models/job.dart';

abstract class Jobs {
  static Jobs di() => Injector.appInstance.getDependency<Jobs>();

  Stream<List<JobModel>> fetchAll();

  StorageReference createFile(File file);

  Stream<JobModel> update(JobModel job);
}
