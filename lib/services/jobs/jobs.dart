import 'dart:io';

import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/repository/models.dart';

abstract class Jobs {
  Stream<List<JobModel>> fetchAll(String? userId);

  Storage? createFile(File file, String userId);

  Stream<JobModel> update(JobModel job, String userId);
}
