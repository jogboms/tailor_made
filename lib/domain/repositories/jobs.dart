import 'dart:io';

import '../entities.dart';
import 'file_storage_reference.dart';

abstract class Jobs {
  Stream<List<JobEntity>> fetchAll(String userId);

  FileStorageReference? createFile(File file, String userId);

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
