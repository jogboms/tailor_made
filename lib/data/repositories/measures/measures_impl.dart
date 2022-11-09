import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class MeasuresImpl extends Measures {
  MeasuresImpl({
    required this.firebase,
    required this.isDev,
  });

  final Firebase firebase;
  final bool isDev;

  @override
  Stream<List<MeasureModel>> fetchAll(String? userId) {
    return firebase.db
        .measurements(userId)
        .snapshots()
        .map((MapQuerySnapshot snapshot) => snapshot.docs.map(_deriveMeasureModel).toList());
  }

  @override
  Future<void> create(
    List<MeasureModel>? measures,
    String userId, {
    required String? groupName,
    required String? unitValue,
  }) async {
    await firebase.db.batchAction((WriteBatch batch) {
      for (final MeasureModel measure in measures!) {
        if (measure.reference != null) {
          batch.update(measure.reference!.source, <String, String?>{'group': groupName, 'unit': unitValue});
        } else {
          batch.set(
            firebase.db.measurements(userId).doc(measure.id),
            measure.toJson(),
            SetOptions(merge: true),
          );
        }
      }
    });
  }

  @override
  Future<void> delete(List<MeasureModel> measures, String userId) async {
    await firebase.db.batchAction((WriteBatch batch) {
      for (final MeasureModel measure in measures) {
        batch.delete(firebase.db.measurements(userId).doc(measure.id));
      }
    });
  }

  @override
  Future<void> update(List<MeasureModel> measures, String? userId) async {
    await firebase.db.batchAction((WriteBatch batch) {
      try {
        for (final MeasureModel measure in measures) {
          batch.set(
            firebase.db.measurements(userId).doc(measure.id),
            measure.toJson(),
            SetOptions(merge: true),
          );
        }
      } catch (_) {}
    });
  }
}

MeasureModel _deriveMeasureModel(MapDocumentSnapshot snapshot) {
  final DynamicMap data = snapshot.data()!;
  return MeasureModel(
    reference: FireReference(snapshot.reference),
    id: data['id'] as String,
    name: data['name'] as String,
    value: data['value'] as double? ?? 0.0,
    unit: data['unit'] as String,
    group: data['group'] as String,
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}
