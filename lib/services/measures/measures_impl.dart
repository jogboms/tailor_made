import 'package:meta/meta.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/measures/measures.dart';
import 'package:tailor_made/services/session.dart';

class MeasuresImpl extends Measures<FirebaseRepository> {
  @override
  Stream<List<MeasureModel>> fetchAll() {
    return repository.db
        .measurements(Session.di().getUserId())
        .snapshots()
        .map((snapshot) => snapshot.documents.map((item) => MeasureModel.fromSnapshot(FireSnapshot(item))).toList());
  }

  @override
  Future<void> create(List<MeasureModel> measures, {@required String groupName, @required String unitValue}) async {
    await repository.db.batchAction((batch) {
      measures.forEach((measure) {
        if (measure?.reference != null) {
          batch.updateData(measure.reference.source, <String, String>{"group": groupName, "unit": unitValue});
        } else {
          batch.setData(
            repository.db.measurements(Session.di().getUserId()).document(measure.id),
            measure.toMap(),
            merge: true,
          );
        }
      });
    });
  }

  @override
  Future<void> delete(List<MeasureModel> measures) async {
    await repository.db.batchAction((batch) {
      measures.forEach(
        (measure) => batch.delete(repository.db.measurements(Session.di().getUserId()).document(measure.id)),
      );
    });
  }

  @override
  Future<void> update(List<MeasureModel> measures) async {
    await repository.db.batchAction((batch) {
      try {
        measures.forEach(
          (measure) => batch.setData(
            repository.db.measurements(Session.di().getUserId()).document(measure.id),
            measure.toMap(),
            merge: true,
          ),
        );
      } catch (e) {
        print(e);
      }
    });
  }
}
