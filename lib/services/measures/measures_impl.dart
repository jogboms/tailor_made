import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/services/measures/measures.dart';

class MeasuresImpl extends Measures {
  @override
  Stream<List<MeasureModel>> fetchAll() {
    return CloudDb.measurements.snapshots().map((snapshot) =>
        snapshot.documents.map((item) => MeasureModel.fromDoc(Snapshot.fromDocumentSnapshot(item))).toList());
  }

  @override
  Future<void> create(List<MeasureModel> measures, {@required String groupName, @required String unitValue}) async {
    final WriteBatch batch = CloudDb.instance.batch();

    measures.forEach((measure) {
      if (measure?.reference != null) {
        batch.updateData(measure.reference, <String, String>{"group": groupName, "unit": unitValue});
      } else {
        batch.setData(CloudDb.measurements.document(measure.id), measure.toMap(), merge: true);
      }
    });

    await batch.commit();
  }

  @override
  Future<void> delete(List<MeasureModel> measures) async {
    final WriteBatch batch = CloudDb.instance.batch();

    measures.forEach((measure) => batch.delete(CloudDb.measurements.document(measure.id)));

    await batch.commit();
  }

  @override
  Future<void> update(List<MeasureModel> measures) async {
    final WriteBatch batch = CloudDb.instance.batch();

    try {
      measures.forEach(
        (measure) => batch.setData(CloudDb.measurements.document(measure.id), measure.toMap(), merge: true),
      );

      await batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
