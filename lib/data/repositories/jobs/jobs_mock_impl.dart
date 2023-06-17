import 'dart:io';

import 'package:tailor_made/domain.dart';

class JobsMockImpl extends Jobs {
  @override
  Stream<List<JobModel>> fetchAll(String? userId) async* {
    yield <JobModel>[
      JobModel(
        userID: '1',
        id: '',
        contactID: '',
        price: 10,
        createdAt: DateTime.now(),
        dueAt: DateTime.now().add(const Duration(days: 7)),
      ),
    ];
  }

  @override
  Storage? createFile(File file, String userId) {
    return null;
  }

  @override
  Stream<JobModel> update(JobModel job, String userId) async* {}
}
