import 'dart:async';

import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/services/stats/stats.dart';

class StatsImpl extends Stats<FirebaseRepository> {
  @override
  Stream<StatsModel> fetch() {
    return repository.db
        .stats(Dependencies.di().session.getUserId())
        .snapshots()
        .map((snapshot) => StatsModel.fromJson(snapshot.data));
  }
}
