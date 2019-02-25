import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/firebase/cloud_db.dart';

class Jobs {
  static Stream<List<JobModel>> fetchAll() {
    return CloudDb.jobs.snapshots().map(
      (snapshot) {
        return snapshot.documents
            .map((item) => JobModel.fromDoc(item))
            .toList();
      },
    );
  }
}
