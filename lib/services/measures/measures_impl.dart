import 'package:meta/meta.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/measures/measures.dart';

class MeasuresImpl extends Measures {
  MeasuresImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<MeasureModel>> fetchAll(String userId) {
    return repository.db
        .measurements(userId)
        .snapshots()
        .map((snapshot) => snapshot.documents.map((item) => MeasureModel.fromSnapshot(FireSnapshot(item))).toList());
  }

  @override
  Future<void> create(List<MeasureModel> measures, String userId,
      {@required String groupName, @required String unitValue}) async {
    await repository.db.batchAction((batch) {
      measures.forEach((measure) {
        if (measure?.reference != null) {
          batch.updateData(measure.reference, <String, String>{"group": groupName, "unit": unitValue});
        } else {
          batch.setData(
            FireReference(repository.db.measurements(userId).document(measure.id)),
            measure.toMap(),
            merge: true,
          );
        }
      });
    });
  }

  @override
  Future<void> delete(List<MeasureModel> measures, String userId) async {
    await repository.db.batchAction((batch) {
      measures.forEach(
        (measure) => batch.delete(FireReference(repository.db.measurements(userId).document(measure.id))),
      );
    });
  }

  @override
  Future<void> update(List<MeasureModel> measures, String userId) async {
    await repository.db.batchAction((batch) {
      try {
        measures.forEach(
          (measure) => batch.setData(
            FireReference(repository.db.measurements(userId).document(measure.id)),
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
