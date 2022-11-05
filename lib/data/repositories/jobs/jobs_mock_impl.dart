import 'dart:io';

import 'package:tailor_made/domain.dart';

class JobsMockImpl extends Jobs {
  @override
  Stream<List<JobModel>> fetchAll(String? userId) async* {
    yield <JobModel>[
      JobModel(
        reference: const NoopReference(),
        userID: '1',
        id: '',
        contactID: '',
        price: 10,
        notes: '',
        images: const <ImageModel>[],
        createdAt: DateTime.now(),
        payments: const <PaymentModel>[],
        dueAt: DateTime.now().add(const Duration(days: 7)),
        measurements: const <String, double>{},
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
