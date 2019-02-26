import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/firebase/cloud_db.dart';

class Stats {
  static Stream<StatsModel> fetch() {
    return CloudDb.stats
        .snapshots()
        .map((snapshot) => StatsModel.fromJson(snapshot.data));
  }
}
