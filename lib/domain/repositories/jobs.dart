import '../entities.dart';

abstract class Jobs {
  Stream<List<JobEntity>> fetchAll(String userId);

  Future<JobEntity> create(String userId, CreateJobData data);

  Future<bool> update(
    String userId, {
    required ReferenceEntity reference,
    List<ImageOperation>? images,
    List<PaymentOperation>? payments,
    bool? isComplete,
    DateTime? dueAt,
  });
}
