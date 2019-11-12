import 'package:meta/meta.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/services/measures/measures.dart';

class MeasuresImpl extends Measures {
  @override
  Stream<List<MeasureModel>> fetchAll() {
    return CloudDb.measurements
        .snapshots()
        .map((snapshot) => snapshot.documents.map((item) => MeasureModel.fromSnapshot(Snapshot(item))).toList());
  }

  @override
  Future<void> create(List<MeasureModel> measures, {@required String groupName, @required String unitValue}) async {
    await CloudDb.batchAction((batch) {
      measures.forEach((measure) {
        if (measure?.reference != null) {
          batch.updateData(measure.reference.source, <String, String>{"group": groupName, "unit": unitValue});
        } else {
          batch.setData(CloudDb.measurements.document(measure.id), measure.toMap(), merge: true);
        }
      });
    });
  }

  @override
  Future<void> delete(List<MeasureModel> measures) async {
    await CloudDb.batchAction((batch) {
      measures.forEach((measure) => batch.delete(CloudDb.measurements.document(measure.id)));
    });
  }

  @override
  Future<void> update(List<MeasureModel> measures) async {
    await CloudDb.batchAction((batch) {
      try {
        measures.forEach(
          (measure) => batch.setData(CloudDb.measurements.document(measure.id), measure.toMap(), merge: true),
        );
      } catch (e) {
        print(e);
      }
    });
  }
}
