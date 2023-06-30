import 'package:clock/clock.dart';
import 'package:tailor_made/domain.dart';
import 'package:uuid/uuid.dart';

class JobsMockImpl extends Jobs {
  @override
  Stream<List<JobEntity>> fetchAll(String userId) async* {
    yield <JobEntity>[
      JobEntity(
        reference: const ReferenceEntity(id: 'id', path: 'path'),
        userID: '1',
        id: '',
        contactID: '',
        price: 10,
        createdAt: clock.now(),
        dueAt: clock.now().add(const Duration(days: 7)),
      ),
    ];
  }

  @override
  Future<JobEntity> create(String userId, CreateJobData data) async {
    return JobEntity(
      reference: ReferenceEntity(id: data.id, path: 'path'),
      userID: data.userID,
      id: data.id,
      contactID: data.contactID!,
      price: data.price,
      createdAt: data.createdAt,
      dueAt: data.dueAt,
      images: <ImageEntity>[
        for (final ImageOperation op in data.images)
          switch (op) {
            CreateImageOperation() => op.data.toEntity(),
            ModifyImageOperation() => op.data,
          },
      ],
      measurements: data.measurements,
      completedPayment: data.completedPayment,
      isComplete: data.isComplete,
      name: data.name,
      notes: data.notes,
      payments: data.payments,
      pendingPayment: data.pendingPayment,
    );
  }

  @override
  Future<bool> update(
    String userId, {
    required ReferenceEntity reference,
    List<ImageOperation>? images,
    List<PaymentOperation>? payments,
    bool? isComplete,
    DateTime? dueAt,
  }) async {
    return true;
  }
}

extension on CreateImageData {
  ImageEntity toEntity() {
    final String id = const Uuid().v4();
    return ImageEntity(
      reference: ReferenceEntity(id: id, path: path),
      userID: userID,
      contactID: contactID,
      jobID: jobID,
      src: src,
      path: path,
      id: id,
      createdAt: clock.now(),
    );
  }
}
