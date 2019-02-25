import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/firebase/cloud_db.dart';

class Measures {
  static Stream<List<MeasureModel>> fetchAll() {
    return CloudDb.measurements.snapshots().map(
      (snapshot) {
        return snapshot.documents
            .map((item) => MeasureModel.fromDoc(item))
            .toList();
      },
    );
  }

  static Future<void> update(List<MeasureModel> measures) async {
    final WriteBatch batch = CloudDb.instance.batch();

    try {
      measures.forEach((measure) {
        batch.setData(
          CloudDb.measurements.document(measure.id),
          measure.toMap(),
          merge: true,
        );
      });

      await batch.commit();
    } catch (e) {
      print(e);
    }
  }
}
