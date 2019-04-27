import 'dart:async';

import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/services/stats.dart';

class StatsImpl extends Stats {
  @override
  Stream<StatsModel> fetch() {
    return CloudDb.stats
        .snapshots()
        .map((snapshot) => StatsModel.fromJson(snapshot.data));
  }
}
