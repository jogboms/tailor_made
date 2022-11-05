import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/measures/measures.dart';

class MeasuresImpl extends Measures {
  MeasuresImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<MeasureModel>> fetchAll(String? userId) {
    return repository.db.measurements(userId).snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> item) => MeasureModel.fromSnapshot(FireSnapshot(item)))
              .toList(),
        );
  }

  @override
  Future<void> create(
    List<MeasureModel>? measures,
    String userId, {
    required String? groupName,
    required String? unitValue,
  }) async {
    await repository.db.batchAction((WriteBatch batch) {
      for (final MeasureModel measure in measures!) {
        if (measure.reference != null) {
          batch.update(measure.reference!.source, <String, String?>{'group': groupName, 'unit': unitValue});
        } else {
          batch.set(
            repository.db.measurements(userId).doc(measure.id),
            measure.toMap(),
            SetOptions(merge: true),
          );
        }
      }
    });
  }

  @override
  Future<void> delete(List<MeasureModel> measures, String userId) async {
    await repository.db.batchAction((WriteBatch batch) {
      for (final MeasureModel measure in measures) {
        batch.delete(repository.db.measurements(userId).doc(measure.id));
      }
    });
  }

  @override
  Future<void> update(List<MeasureModel> measures, String? userId) async {
    await repository.db.batchAction((WriteBatch batch) {
      try {
        for (final MeasureModel measure in measures) {
          batch.set(
            repository.db.measurements(userId).doc(measure.id),
            measure.toMap(),
            SetOptions(merge: true),
          );
        }
      } catch (_) {}
    });
  }
}
