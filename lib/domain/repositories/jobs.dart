import 'dart:io';

import '../entities.dart';
import '../models/job.dart';

abstract class Jobs {
  Stream<List<JobModel>> fetchAll(String? userId);

  Storage? createFile(File file, String userId);

  Stream<JobModel> update(JobModel job, String userId);
}
