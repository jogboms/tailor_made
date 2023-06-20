import 'dart:io';

import '../entities.dart';

abstract class Jobs {
  Stream<List<JobEntity>> fetchAll(String userId);

  Storage? createFile(File file, String userId);

  Future<JobEntity> create(String userId, CreateJobData data);

  Future<bool> update(
    String userId, {
    required ReferenceEntity reference,
    List<ImageEntity>? images,
    List<PaymentEntity>? payments,
    bool? isComplete,
    DateTime? dueAt,
  });
}
